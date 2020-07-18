package jebja.scenes;

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

		var tips = UiHelper.addTips('[Enter] to Restart\n[SPACE] to Toggle Stailsail\n[S] To open Spinnaker\n[-] To show Debug\n[Q] To Quit', this);
		Timer.delay(function() {
			tips.remove();
		}, 6000);
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
}
