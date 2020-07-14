package jebja.entities;

import jebja.libs.Atlas;
import jebja.libs.Geom;
import h2d.Text;
import h2d.Object;
import h2d.col.Point;
import hxd.Key;
import differ.shapes.Circle;

final class SailConfig {
	public var maxSpeed:{
		closeWind:Float,
		stern:Float,
		bow:Float,
		across:Float
	};
	public var windResistence:Float;

	public function new(config:{maxSpeed:Array<Float>, windResistence:Float}) {
		this.maxSpeed = {
			stern: config.maxSpeed[0],
			bow: config.maxSpeed[1],
			closeWind: config.maxSpeed[2],
			across: config.maxSpeed[3],
		};
		this.windResistence = config.windResistence;
	}

	public static function make(config:{maxSpeed:Array<Float>, windResistence:Float}):SailConfig {
		return new SailConfig(config);
	}
}

final class SailTypes {
	static final SENSITIVITY = .2;
	public static final MAINSAIL = 'mainsail';
	public static final STAYSAIL = 'staysail';
	public static final SPINNAKER = 'spinnaker';

	public static function getConfig(type:Null<String>):SailConfig {
		if (type == SailTypes.STAYSAIL) {
			return SailConfig.make({
				// Stern, Bow, CloseWind, Across
				maxSpeed: [2, 0, 2, 1.5],
				windResistence: .3
			});
		}

		if (type == SailTypes.SPINNAKER) {
			return SailConfig.make({
				maxSpeed: [3.5, 0, .5, .5],
				windResistence: .4
			});
		}

		return SailConfig.make({
			maxSpeed: [.3, 0, 0, 0],
			windResistence: .6
		});
	}

	public static function getMaxSpeed(config:SailConfig, angle:Float):Float {
		var modifier = Geom.modifierFromAngle(angle);

		if (modifier <= SENSITIVITY) {
			return config.maxSpeed.bow;
		}

		if (modifier <= (.5 + SENSITIVITY)) {
			return config.maxSpeed.across;
		}

		if (modifier <= (1 + SENSITIVITY)) {
			return config.maxSpeed.closeWind;
		}

		return config.maxSpeed.stern;
	}
}

class Player extends Collidable {
	public static final SIZE = 64;
	static final TRACE_SESITIVITY = .24;

	static final ROTATION_SPEED = 0.02;
	// need to make this variable
	// and also add a way to get the intensity of it
	// maybe also made maxspeed dependent on this
	static final WIND_DIRECTION = Geom.ANGLE_180;

	var t:Text;
	var currentSpeed:Float;
	var sail:Null<String>;
	var sailConfig:SailConfig;
	var movement = new Point(0, 0);

	public function new(parent:Object) {
		this.sail = SailTypes.STAYSAIL;
		var tile = Atlas.instance.get(this.sail).center();
		super(parent, tile);
		this.setSail(this.sail);

		this.currentSpeed = 0;
		this.collider = new Circle(this.x, this.y, tile.width * .5);
		this.rotation = -Math.PI / 2;
		t = new h2d.Text(hxd.res.DefaultFont.get(), parent);
	}

	function generateTrace(position:Point, movement:Point, speed:Float) {
		var origin = Trace.getOrigin(position, movement);
		if (speed >= TRACE_SESITIVITY) {
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

		// toggling sails
		if (Key.isReleased(Key.SPACE)) {
			this.toggleSail();
		}

		// opening spinnaker
		if (Key.isReleased(Key.S)) {
			this.setSail(SailTypes.SPINNAKER);
		}

		this.movement.x = Math.cos((-Math.PI / 2) + this.rotation);
		this.movement.y = Math.sin((-Math.PI / 2) + this.rotation);
		this.movement.normalize();

		var totalAcc = this.getTotalAcceleration(dt, turning);
		currentSpeed = this.getMaxSpeed() - ((this.getMaxSpeed() - currentSpeed) * Math.exp(-totalAcc));
		#if debug
		this.printDebugInfo(totalAcc);
		#end

		// Max speed and min speed should be dictated by the wind direction too
		currentSpeed = this.adjustSpeed(currentSpeed);

		var oldX = this.x;
		var oldY = this.y;
		this.x += this.movement.x * currentSpeed;
		this.y += this.movement.y * currentSpeed;
		this.generateTrace(new Point(oldX, oldY), this.movement, currentSpeed);
	}

	function printDebugInfo(totalAcc:Float) {
		t.text = 'mov: (${this.movement.x} , ${this.movement.y})\n' + 'rot: ${this.rotation}\n' + 'angle:${Geom.directionAngle(this.rotation)}\n'
			+ 'relative-angle:${this.getRelativeAngle()}\n' + 'acceleration:${this.acceleration()}\n'
			+ 'wind-resistence:${this.windResistence()}\n' + 'totalAcc:${totalAcc}\n' + 'speed:${this.currentSpeed}\n' + 'maxSpeed:${this.getMaxSpeed()}\n'
			+ 'sail:${this.sail}\n';
		t.x = this.x - 300;
		t.y = this.y - 300;
	}

	function getRelativeAngle():Int {
		return (Geom.ANGLE_180 - WIND_DIRECTION - Geom.directionAngle(this.rotation));
	}

	function acceleration() {
		// here we could pass the type of sail so we can
		// check whether the acceleration should be changed
		if (this.sail == null)
			return 0.;

		return Geom.modifierFromAngle(this.getRelativeAngle());
	}

	function windResistence() {
		return (Geom.modifierFromAngle(this.getRelativeAngle() - Geom.ANGLE_180) * .3) + this.sailConfig.windResistence;
	}

	function getTotalAcceleration(dt:Float, turning:Bool) {
		// the abs fixes the incredible acceleration on no sail
		// but breaks the way we decelerate to 0 against wind
		// we need maxspeed to be a function of SailType and Angle against wind
		return Math.abs((this.acceleration() * dt) - ((turning ? 3 : 1) * this.windResistence() * dt));
	}

	function adjustSpeed(currentSpeed:Float) {
		if (currentSpeed < 0) {
			currentSpeed = 0;
		}

		return currentSpeed;
	}

	function getMaxSpeed() {
		return SailTypes.getMaxSpeed(this.sailConfig, this.getRelativeAngle());
	}

	function toggleSail() {
		var sail = (this.sail == null) ? SailTypes.STAYSAIL : null;
		this.setSail(sail);
	}

	function setSail(sailType:String) {
		this.sail = sailType;
		this.tile = Atlas.instance.get(sail == null ? 'base' : sail).center();
		this.sailConfig = SailTypes.getConfig(this.sail);
	}
}
