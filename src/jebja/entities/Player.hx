package jebja.entities;

import jebja.libs.Geom;
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
	static final TRAIL_DELAY = 350;
	static final TRAIL_LIFE = 1500;
	static final ACCELLERATION = 1;
	static final ROTATION_SPEED = 0.02;
	static final SIZE = 30;
	static final WIND_DIRECTION = -Math.PI / 2;

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

	function generateTrace(x, y) {
		var particles = new Particles(this.parent);
		var g = new ParticleGroup(particles);
		g.texture = Tile.fromColor(Colours.TRAIL).getTexture();
		g.size = 3;
		g.nparts = 10;
		g.sizeRand = .2;
		g.life = .3;
		g.speed = 5;
		g.speedRand = 3;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 10;
		g.fadeIn = 0;
		g.fadeOut = 0.9;
		particles.x = x;
		particles.y = y;
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
		#if debug
		this.printDirection();
		#end
		this.movement.normalize();
		this.x += this.movement.x * this.speed * dt;
		this.y += this.movement.y * this.speed * dt;

		if (this.movement.x != 0 || this.movement.y != 0) {
			var x = this.x;
			var y = this.y;
			Timer.delay(function() {
				this.generateTrace(x, y);
			}, TRAIL_DELAY);
		}
	}

	function printDirection() {
		t.text = 'x: ${this.movement.x}\n' 
		+ 'y: ${this.movement.y}\n' 
		+ 'rot: ${this.rotation}\n' 
		+ 'bearing: ${this.getBearing()}\n'
		+ 'angle:${Geom.directionAngle(this.rotation)}';
		t.x = this.x - 400;
		t.y = this.y - 100;
	}

	function getBearing() {
		var diff = Math.abs((this.rotation % 2 * Math.PI) - WIND_DIRECTION);
		return diff < Math.PI ? diff : 2 * Math.PI - diff;
	}
}
