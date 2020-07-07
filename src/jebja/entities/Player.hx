package jebja.entities;

import jebja.libs.Atlas;
import jebja.libs.Geom;
import h2d.Text;
import hxd.Res;
import h2d.Object;
import h2d.col.Point;
import hxd.Key;
import differ.shapes.Circle;

final class SailTypes {
	public static final MAINSAIL = 'mainsail';
	public static final STAYSAIL = 'staysail';
	public static final SPINNAKER = 'spinnaker';

	public static function getConfig(type:Null<String>) {
		if (type == null) {
			return {
				maxSpeed: 2
			};
		}

		if (type == SailTypes.STAYSAIL) {
			return {
				maxSpeed: 2
			};
		}

		if (type == SailTypes.SPINNAKER) {
			return {
				maxSpeed: 5
			};
		}

		return {
			maxSpeed: 2
		};
	}
}

class Player extends Collidable {
	public static final SIZE = 64;

	static final ROTATION_SPEED = 0.02;
	static final WIND_DIRECTION = Geom.ANGLE_180;

	var t:Text;

	var maxSpeed:Int;
	var currentSpeed:Float;
	var sail:Null<String>;
	var movement = new Point(0, 0);

	public function new(parent:Object) {
		this.sail = SailTypes.STAYSAIL;
		var tile = Atlas.instance.get(this.sail).center();
		super(parent, tile);

		this.maxSpeed = SailTypes.getConfig(this.sail).maxSpeed;
		this.maxSpeed = SailTypes.getConfig(this.sail).maxSpeed;
		this.currentSpeed = 0;
		this.collider = new Circle(this.x, this.y, tile.width * .5);
		this.rotation = -Math.PI / 2;
		t = new h2d.Text(hxd.res.DefaultFont.get(), parent);
	}

	function generateTrace(position:Point, movement:Point, speed:Float) {
		var origin = Trace.getOrigin(position, movement);
		if (speed > 0.3) {
			Trace.show(origin.x, origin.y, this.parent);
		}
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
		if (Key.isReleased(Key.SPACE)) {
			this.toggleSail();
		}

		#if debug
		this.printDebugInfo();
		#end

		this.movement.x = Math.cos((-Math.PI / 2) + this.rotation);
		this.movement.y = Math.sin((-Math.PI / 2) + this.rotation);
		this.movement.normalize();

		currentSpeed = this.maxSpeed - ((this.maxSpeed - currentSpeed) * Math.exp(-this.getTotalAcceleration(dt, turning)));

		// Max speed and min speed should be dictated by the wind direction too
		currentSpeed = this.adjustSpeed(currentSpeed);

		var oldX = this.x;
		var oldY = this.y;
		this.x += this.movement.x * currentSpeed;
		this.y += this.movement.y * currentSpeed;
		this.generateTrace(new Point(oldX, oldY), this.movement, currentSpeed);
	}

	function printDebugInfo() {
		t.text = 'mov: (${this.movement.x} , ${this.movement.y})\n' + 'rot: ${this.rotation}\n' + 'angle:${Geom.directionAngle(this.rotation)}\n'
			+ 'relative-angle:${this.getRelativeAngle()}\n' + 'wind-acceleration:${this.acceleration()}\n' + 'wind-resistence:${this.windResistence()}\n'
			+ 'speed:${this.currentSpeed}\n' + 'sail:${this.sail}\n';
		t.x = this.x - 300;
		t.y = this.y - 300;
	}

	function getRelativeAngle() {
		return (Geom.ANGLE_180 - WIND_DIRECTION - Geom.directionAngle(this.rotation));
	}

	function acceleration() {
		// here we could pass the type of sail so we can
		// check whether the acceleration should be changed
		if (this.sail == null)
			return 0.;

		return Geom.speedModifierFromAngle(this.getRelativeAngle());
	}

	function windResistence() {
		// the .3 is a base one, should be given by the sail used
		// no sail means higher resistence
		return (Geom.speedModifierFromAngle(this.getRelativeAngle() - Geom.ANGLE_180) * .5) + .3;
	}

	function getTotalAcceleration(dt:Float, turning:Bool) {
		return (this.acceleration() * dt) - ((turning ? 3 : 1) * this.windResistence() * dt);
	}

	function adjustSpeed(currentSpeed:Float) {
		if (currentSpeed < 0) {
			currentSpeed = 0;
		}

		return currentSpeed;
	}

	function toggleSail() {
		this.sail = (this.sail == SailTypes.STAYSAIL) ? null : SailTypes.STAYSAIL;
		this.tile = Atlas.instance.get(sail == null ? 'base' : sail).center();
		this.maxSpeed = SailTypes.getConfig(this.sail).maxSpeed;
	}
}
