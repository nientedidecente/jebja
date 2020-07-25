package jebja.scenes;

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

	var buoys = new Array<Buoy>();
	var gameOver = false;

	var showInfo = true;
	var speedInfo:Text;
	var windInfo:Text;

	override function init() {
		super.init();
		gameOver = false;
		var bg = UiHelper.addBackground(this, Colours.SEA);
		camera = new Camera(this);
		for (i in 0...200) {
			var buoy = new Buoy(camera);
			buoy.x = 200 + 200 * (1 * i);
			buoy.y = -(100 + 200 * (1 * i));

			buoys.push(buoy);
		}
		wind = Wind.generate();
		player = new Player(camera, wind);

		player.x = bg.width * .5;
		player.y = bg.height * .5;

		var tips = UiHelper.addTips(Strings.COMMANDS, this);
		Timer.delay(function() {
			tips.remove();
		}, 6000);

		speedInfo = new Text(hxd.Res.font.toSdfFont(null, 3), this);
		windInfo = new Text(hxd.Res.font.toSdfFont(null, 3), this);
		windInfo.x = 0;
		windInfo.y = 0;
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

		for (buoy in buoys) {
			buoy.update(player);
		}

		camera.viewX = player.x;
		camera.viewY = player.y;

		updateInfo();

		// Indicator
		if (Key.isReleased(Key.SPACE)) {
			showInfo = !showInfo;
		}
	}

	function updateInfo() {
		speedInfo.visible = showInfo;
		windInfo.visible = showInfo;
		if (showInfo) {
			windInfo.text = 'W: ${wind.getDirection()} ${Geom.toFixed(wind.intensity * Wind.KNOTS)} kn';
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
