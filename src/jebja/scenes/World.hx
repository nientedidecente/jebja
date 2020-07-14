package jebja.scenes;

import h2d.Particles;
import jebja.entities.Buoy;
import jebja.config.Colours;
import hxd.Key;
import hxd.Event;
import ui.UiHelper;
import jebja.entities.Player;

class World extends BaseScene {
	var player:Player;
	var gameOver = false;

	override function init() {
		super.init();
		gameOver = false;
		var bg = UiHelper.addBackground(this, Colours.SEA);
		bg.tile = bg.tile.center();
		this.generateSea(this);
		for (i in 0...200) {
			var enemy = new Buoy(this);
			enemy.x = 200 + 200 * (1 * i);
			enemy.y = -(100 + 200 * (1 * i));
		}

		player = new Player(this);

		player.x = 0;
		player.y = 0;
		camera.setAnchor(.5, .5);
		camera.follow = player;
	}

	override function update(dt:Float) {
		#if trackfps
		trace(hxd.Timer.fps());
		#end

		if (gameOver) {
			return;
		}

		player.update(dt);
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

	public function generateSea(parent) {
		var particles = new Particles(parent);
		var g = new ParticleGroup(particles);
		particles.addGroup(g);
		g.nparts = 400;
		g.size = .2;
		g.gravity = -1;
		g.life = 5;
		g.speed = 2;
		g.speedRand = 3;
		g.emitMode = PartEmitMode.Box;
		g.emitAngle = Math.PI;
		g.emitDist = this.width;
		g.emitDistY = this.height;
		g.dx = cast this.width;
	}
}
