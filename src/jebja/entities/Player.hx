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
	static final WIND_DIRECTION = Geom.ANGLE_180;

	var t:Text;

	var maxSpeed:Int;
	var currentSpeed:Float;
	var particles:Particles;
	var g:ParticleGroup;
	var movement = new Point(0, 0);

	public function new(parent:Object) {
		var tile = Res.boat.toTile();
		tile = tile.center();
		super(parent, tile);
		this.maxSpeed = 2;
		this.currentSpeed = 0;
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
		var turning = false;

		if (Key.isDown(Key.RIGHT)) {
			this.rotation += ROTATION_SPEED;
			turning = true;
		}
		if (Key.isDown(Key.LEFT)) {
			this.rotation -= ROTATION_SPEED;
			turning = true;
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

		currentSpeed = currentSpeed + this.getTotalAcceleration(dt, turning);

		// Max speed and min speed should be dictated by the wind direction too
		currentSpeed = this.adjustSpeed(currentSpeed);

		var oldX = this.x;
		var oldY = this.y;
		this.x += this.movement.x * currentSpeed;
		this.y += this.movement.y * currentSpeed;

		if (currentSpeed > 0.6) {
			Timer.delay(function() {
				this.generateTrace(oldX, oldY);
				// trail delay should be dictated by the current speed
				// maybe I could get oldX and oldY and correlate position 
				// with newX and newY
			}, TRAIL_DELAY);
		}
	}

	function printDirection() {
		t.text = 'x: ${this.movement.x}\n' + 'y: ${this.movement.y}\n' + 'rot: ${this.rotation}\n' + 'angle:${Geom.directionAngle(this.rotation)}\n'
			+ 'relative-angle:${this.getRelativeAngle()}\n' + 'wind-acceleration:${this.acceleration()}\n' + 'wind-resistence:${this.windResistence()}\n'
			+ 'speed:${this.currentSpeed}\n';
		t.x = this.x - 300;
		t.y = this.y - 300;
	}

	function getRelativeAngle() {
		return (Geom.ANGLE_180 - WIND_DIRECTION - Geom.directionAngle(this.rotation));
	}

	function acceleration() {
		return Geom.speedModifierFromAngle(this.getRelativeAngle());
	}

	function windResistence() {
		if (Math.abs(this.getRelativeAngle()) <= Geom.ANGLE_SENSITIVITY * 2) {
			return 0.8;
		}
		return 0.3;
	}

	function getTotalAcceleration(dt:Float, turning:Bool) {
		return (this.acceleration() * dt) - ((turning ? 3 : 1) * this.windResistence() * dt);
	}

	function getMaxSpeed() {
		// max speed should get also dictated by the tipe of
		// sail: Spinnaker +5, normal +2
		return this.maxSpeed * this.acceleration();
	}

	function adjustSpeed(currentSpeed:Float) {
		var maxSpeed = this.getMaxSpeed();
		if (currentSpeed > maxSpeed) {
			currentSpeed = maxSpeed;
		}

		if (currentSpeed < 0) {
			currentSpeed = 0;
		}

		return currentSpeed;
	}
}
