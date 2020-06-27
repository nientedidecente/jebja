package jebja.scenes;

import hxd.Timer;
import h2d.Camera;
import jebja.entities.Buoy;
import jebja.config.Colours;
import hxd.Key;
import hxd.Event;
import ui.UiHelper;
import jebja.entities.Player;

class World extends BaseScene {
	static final THRESHOLD = 100;

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

		player = new Player(camera);

		player.x = bg.width * .5;
		player.y = bg.height * .5;
	}

	override function update(dt:Float) {
		trace(Timer.fps());
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
