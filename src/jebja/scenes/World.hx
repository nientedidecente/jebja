package jebja.scenes;

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
	var gameOver = false;

	override function init() {
		super.init();
		gameOver = false;
		var bg = UiHelper.addBackground(this, Colours.SEA);
		camera = new Camera(this);
		for (i in 0...200) {
			var enemy = new Buoy(camera);
			enemy.x = 200 + 200 * (1 * i);
			enemy.y = -(100 + 200 * (1 * i));
		}

		player = new Player(camera, Wind.generate());

		player.x = bg.width * .5;
		player.y = bg.height * .5;

		var tips = UiHelper.addTips(Strings.COMMANDS, this);
		Timer.delay(function() {
			tips.remove();
		}, 6000);

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

		camera.viewX = player.x;
		camera.viewY = player.y;
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
			trace('changing wind to ${angle}');
			player.setWind(Wind.generate(angle));
			triggerWindChange();
		}, timeout);
	}
}
