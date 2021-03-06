package jebja.scenes;

import h2d.col.Point;
import jebja.entities.course.Track;
import jebja.entities.effects.Waves;
import jebja.entities.ui.Dashboard;
import h2d.Object;
import h2d.Text;
import jebja.libs.Geom;
import jebja.libs.Randomizer;
import jebja.config.Strings;
import haxe.Timer;
import jebja.entities.effects.Wind;
import h2d.Camera;
import jebja.entities.floaters.Buoy;
import jebja.config.Colours;
import hxd.Key;
import hxd.Event;
import ui.UiHelper;
import jebja.entities.Player;

class World extends BaseScene {
	var camera:Camera;
	var player:Player;
	var wind:Wind;
	var layers:Array<Object>;

	var homeBuoy:Buoy;
	var gameOver = false;

	var track:Track;
	var startingTime:Float;

	var showInfo = true;
	var windInfo:Text;

	var dashboard:Dashboard;

	override function init() {
		super.init();
		gameOver = false;
		layers = new Array<Object>();
		UiHelper.addBackground(this, Colours.SEA);
		var background = new Object(this);
		layers.push(background);
		camera = new Camera(this);
		var foreground = new Object(this);
		layers.push(foreground);

		dashboard = new Dashboard(this);
		dashboard.visible = false;

		homeBuoy = new Buoy(background, Colours.BUOY_DARK);
		homeBuoy.x = 0;
		homeBuoy.y = 0;

		track = new Track(background, foreground, function() {
			this.startingTime = haxe.Timer.stamp();
			UiHelper.addTips("RACE STARTED", this, 4000, new Point(-100, 100));
		}, function() {
			var elapsed = Std.int((haxe.Timer.stamp() - this.startingTime) * 1000) / 1000;
			UiHelper.addTips('RACE FINISHED\ntime: ${elapsed} sec', this, 4000, new Point(-100, 100));
		}, function(checkpoint, total) {
			var elapsed = Std.int((haxe.Timer.stamp() - this.startingTime) * 1000) / 1000;
			UiHelper.addTips('${checkpoint} / ${total}\ntime: ${elapsed} sec', this, 4000, new Point(-100, 100));
		});

		wind = Wind.generate();
		player = new Player(camera, background, wind);

		player.x = Player.SIZE;
		player.y = 0;

		UiHelper.addTips(Strings.COMMANDS, this);

		initTextIndicators();
		triggerWindChange();
		triggerWaves();
	}

	override function update(dt:Float) {
		#if trackfps
		trace(hxd.Timer.fps());
		#end

		if (gameOver) {
			return;
		}

		player.update(dt);
		dashboard.update(player);
		track.update(player);

		camera.viewX = player.x;
		camera.viewY = player.y;
		updateLayers(camera.x, camera.y);
		updateInfo();

		// Indicator
		if (Key.isReleased(Key.SPACE)) {
			showInfo = !showInfo;
		}

		// Dashboard
		if (Key.isReleased(Key.D)) {
			dashboard.visible = !dashboard.visible;
		}
	}

	function updateLayers(x:Float, y:Float) {
		for (layer in layers) {
			layer.x = x;
			layer.y = y;
		}
	}

	function updateInfo() {
		windInfo.visible = showInfo;
		if (showInfo) {
			windInfo.text = 'W: ${wind.getDirection()} ${Geom.toFixed(wind.intensity * Wind.KNOTS)} kn';
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
		var reportWindChanged = function() {
			var initialColour = 0xffffff;
			windInfo.textColor = 0xff0000;
			Timer.delay(function() {
				windInfo.textColor = initialColour;
			}, 3000);
		}
		Timer.delay(function() {
			var angleIndex = Randomizer.int(0, angles.length);
			var angle = angles[angleIndex];
			var int = Randomizer.int(10, 15) / 10.;
			wind = Wind.generate(angle, int);
			player.setWind(wind);
			reportWindChanged();
			triggerWindChange();
		}, timeout);
	}

	function triggerWaves() {
		var timeout = 2500;
		Waves.generate(player.x, player.y, getBackground(), timeout);
		Timer.delay(function() {
			triggerWaves();
		}, timeout);
	}

	function initTextIndicators() {
		windInfo = new Text(hxd.Res.font.toSdfFont(null, 3), this);
		windInfo.x = 5;
		windInfo.y = 0;
	}

	function getBackground() {
		return layers[0];
	}

	function getForeground() {
		return layers[1];
	}
}
