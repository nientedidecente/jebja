package jebja.entities;

import jebja.libs.Camera;
import h2d.Text;
import hxd.Res;
import h2d.Object;
import jebja.config.Colours;
import haxe.Timer;
import h2d.Particles;
import h2d.col.Point;
import hxd.Key;
import h2d.Tile;
import differ.shapes.Circle;

class Player extends Collidable {
	static final TRAIL_LIFE = 300;
	static final ACCELLERATION = 1;
	static final ROTATION_SPEED = 0.02;
	static final SIZE = 30;

	var t:Text;

	var speed:Int;
	var particles:Particles;
	var g:ParticleGroup;
	var movement = new Point(0, 0);

	public function new(parent:Object) {
		var tile = Res.boat.toTile();
		tile = tile.center();
		super(parent, tile);
		this.speed = 100;
		this.collider = new Circle(this.x, this.y, tile.width * .5);
		this.rotation = -Math.PI / 2;
		t = new h2d.Text(hxd.res.DefaultFont.get(), parent);
	}

	function generateTrace() {
		var particles = new Particles(this.parent);
		var g = new ParticleGroup(particles);
		g.texture = Tile.fromColor(Colours.TRAIL).getTexture();
		g.size = SIZE / 4;
		g.nparts = 40;
		g.sizeRand = .2;
		g.life = .5;
		g.speed = 30;
		g.speedRand = 3;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 10;
		g.fadeIn = 0;
		g.fadeOut = 0;
		particles.x = this.x + 10;
		particles.y = this.y + 30;
		particles.addGroup(g);
		Timer.delay(function() {
			particles.removeGroup(g);
			particles.remove();
		}, TRAIL_LIFE);
	}

	override function update(dt:Float) {
		super.update(dt);

		if (Key.isDown(Key.RIGHT)) {
			this.rotation += ROTATION_SPEED;
		}
		if (Key.isDown(Key.LEFT)) {
			this.rotation -= ROTATION_SPEED;
		}

		// stopping for debug purposes
		if (Key.isDown(Key.SPACE)) {
			this.movement.y = 0;
			this.movement.x = 0;
			this.rotation = Math.PI;
		}

		this.movement.x = Math.cos((-Math.PI / 2) + this.rotation);
		this.movement.y = Math.sin((-Math.PI / 2) + this.rotation);
		this.movement.normalize();
		this.printDirection();
		this.x += this.movement.x * this.speed * dt;
		this.y += this.movement.y * this.speed * dt;

		if (this.movement.x != 0 || this.movement.y != 0) {
			this.generateTrace();
		}
	}

	function printDirection() {
		t.text = 'x: ${this.movement.x}\ny: ${this.movement.y}\nrot: ${this.rotation}';
		t.x = this.x - 200;
		t.y = this.y - 100;
	}
}
