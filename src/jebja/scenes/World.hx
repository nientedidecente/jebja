package jebja.scenes;

import differ.Collision;
import jebja.entities.TargetBuoy;
import h2d.Text;
import jebja.libs.Geom;
import jebja.libs.Randomizer;
import jebja.config.Strings;
import haxe.Timer;
import jebja.entities.Wind;
import h2d.Camera;
import jebja.entities.Buoy;
import jebja.config.Colours;
import hxd.Key;
import hxd.Event;
import ui.UiHelper;
import jebja.entities.Player;

class World extends BaseScene {
	var camera:Camera;
	var player:Player;
	var wind:Wind;

	var homeBuoy:Buoy;
	var targetBuoy:TargetBuoy;
	var gameOver = false;

	var showInfo = true;
	var speedInfo:Text;
	var worldInfo:Text;

	override function init() {
		super.init();
		gameOver = false;
		UiHelper.addBackground(this, Colours.SEA);
		camera = new Camera(this);
		homeBuoy = new Buoy(camera, Colours.BUOY_DARK);
		homeBuoy.x = 0;
		homeBuoy.y = 0;

		targetBuoy = new TargetBuoy(camera);
		targetBuoy.x = Randomizer.int(1, 10) * 1000 * (Randomizer.chance(50) ? 1 : -1);
		targetBuoy.y = Randomizer.int(1, 10) * 1000 * (Randomizer.chance(50) ? 1 : -1);

		wind = Wind.generate();
		player = new Player(camera, wind);

		player.x = Player.SIZE;
		player.y = 0;

		var tips = UiHelper.addTips(Strings.COMMANDS, this);
		Timer.delay(function() {
			tips.remove();
		}, 6000);

		speedInfo = new Text(hxd.Res.font.toSdfFont(null, 3), this);
		worldInfo = new Text(hxd.Res.font.toSdfFont(null, 3), this);
		worldInfo.x = 0;
		worldInfo.y = 0;
		speedInfo.x = 0;
		speedInfo.y = this.height - 70;
		triggerWindChange();
	}

	override function update(dt:Float) {
		#if trackfps
		trace(hxd.Timer.fps());
		#end

		if (gameOver) {
			return;
		}

		player.update(dt);

		targetBuoy.update(player);

		camera.viewX = player.x;
		camera.viewY = player.y;

		updateInfo();

		// Indicator
		if (Key.isReleased(Key.SPACE)) {
			showInfo = !showInfo;
		}

		var colliding = Collision.shapeWithShape(player.collider, targetBuoy.collider);
		if (colliding != null) {
			trace("GOT IT", colliding);
		}
	}

	function updateInfo() {
		speedInfo.visible = showInfo;
		worldInfo.visible = showInfo;
		if (showInfo) {
			worldInfo.text = 'W: ${wind.getDirection()} ${Geom.toFixed(wind.intensity * Wind.KNOTS)} kn\nP: ${Geom.toFixed(player.x)}, ${Geom.toFixed(player.y)}';
			speedInfo.text = 'H: ${Geom.getHeading(player.rotation)} (deg)\nV: ${Geom.toFixed(player.currentSpeed * wind.intensity * Wind.KNOTS)} kn';
		}
	}

	public function registerHandlers(onQuit:Void->Void, onStart:Void->Void) {
		this.addEventListener(function(event:Event) {
			if (event.kind == EventKind.EKeyDown && event.keyCode == Key.Q) {
				onQuit();
			}

			if (event.kind == EventKind.EKeyDown && event.keyCode == Key.ENTER) {
				onStart();
			}
		});
	}

	function triggerWindChange() {
		var timeout = Randomizer.int(10, 60) * 1000;
		var angles = [Geom.ANGLE_180, Geom.ANGLE_135, Geom.ANGLE_90, Geom.ANGLE_45];
		trace('changing wind in ${timeout}');
		Timer.delay(function() {
			var angleIndex = Randomizer.int(0, angles.length);
			var angle = angles[angleIndex];
			var int = Randomizer.int(10, 15) / 10.;
			trace('changing wind to ${angle} ${int}');
			wind = Wind.generate(angle, int);
			player.setWind(wind);
			triggerWindChange();
		}, timeout);
	}
}
