package jebja.entities;

import jebja.entities.boats.sails.SailConfig;
import jebja.entities.boats.sails.SailTypes;
import jebja.entities.effects.Trace;
import jebja.entities.effects.Wind;
import h2d.Bitmap;
import jebja.libs.Atlas;
import jebja.libs.Geom;
import h2d.Text;
import h2d.Object;
import h2d.col.Point;
import hxd.Key;
import differ.shapes.Polygon;

class Player extends Collidable {
	public static final SIZE = 64;
	static final TRACE_SESITIVITY = .24;
	static final ROTATION_SPEED = 1;

	public var currentSpeed:Float;
	public var movement = new Point(0, 0);

	var seaLayer:Object;

	var sail:Null<String>;
	var sailConfig:SailConfig;

	var wind:Wind;

	var showIndicators = true;
	var windIndicator:Bitmap;

	#if debug
	var showDebug = false;
	var debugText:Text = null;
	#end

	public function new(parent:Object, seaLayer:Object, wind:Wind) {
		var tile = Atlas.instance.get(SailTypes.NONE).center();
		super(parent, tile);
		this.setSail(SailTypes.NONE);
		this.wind = wind;
		this.seaLayer = seaLayer;

		this.currentSpeed = 0;
		this.collider = Polygon.rectangle(this.x, this.y, tile.width, tile.height);
		this.rotation = Math.PI / 2;
		windIndicator = new Bitmap(Atlas.instance.getRes('wind').toTile(), parent);
		windIndicator.setScale(.5);

		#if debug
		debugText = new h2d.Text(hxd.res.DefaultFont.get(), parent);
		#end
	}

	public function setWind(wind:Wind):Player {
		this.wind = wind;
		return this;
	}

	public function getWind():Wind {
		return wind;
	}

	public function updateIndicators() {
		windIndicator.visible = showIndicators;

		if (showIndicators) {
			windIndicator.x = this.x + (SIZE * 2 * movement.x);
			windIndicator.y = this.y + (SIZE * 2 * movement.y);
			windIndicator.rotation = hxd.Math.degToRad(Geom.ANGLE_180 - wind.direction);
		}
	}

	function generateTrace(position:Point, movement:Point, speed:Float) {
		var origin = Trace.getOrigin(position, movement);
		if (speed >= TRACE_SESITIVITY) {
			Trace.show(origin.x, origin.y, seaLayer);
		}
	}

	override function update(dt:Float) {
		super.update(dt);
		this.updateIndicators();
		var turning = false;

		if (Key.isDown(Key.RIGHT)) {
			this.rotation += ROTATION_SPEED * dt;
			turning = true;
		}
		if (Key.isDown(Key.LEFT)) {
			this.rotation -= ROTATION_SPEED * dt;
			turning = true;
		}

		// toggling sails
		if (Key.isReleased(Key.UP)) {
			this.toggleSail();
		}

		// putting sails down
		if (Key.isReleased(Key.DOWN)) {
			this.setSail(SailTypes.NONE);
		}

		// Indicator
		if (Key.isReleased(Key.W)) {
			showIndicators = !showIndicators;
		}

		this.movement.x = Math.cos((-Math.PI / 2) + this.rotation);
		this.movement.y = Math.sin((-Math.PI / 2) + this.rotation);
		this.movement.normalize();

		var totalAcc = this.getTotalAcceleration(dt, turning);
		currentSpeed = this.getMaxSpeed() - ((this.getMaxSpeed() - currentSpeed) * Math.exp(-totalAcc));
		#if debug
		this.debug(totalAcc);
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
		debugText.text = 'mov: (${this.movement.x} , ${this.movement.y})\n' + 'rot: ${this.rotation}\n' + 'angle:${Geom.directionAngle(this.rotation)}\n'
			+ 'relative-angle:${this.getRelativeAngle()}\n' + 'acceleration:${this.acceleration()}\n' + 'wind-resistence:${this.windResistence()}\n'
			+ 'totalAcc:${totalAcc}\n' + 'speed:${this.currentSpeed}\n' + 'maxSpeed:${this.getMaxSpeed()}\n' + 'sail:${this.sail}\n';
		debugText.x = this.x - 300;
		debugText.y = this.y - 300;
	}

	function getRelativeAngle():Int {
		return (Geom.ANGLE_180 - this.wind.direction - Geom.directionAngle(this.rotation)) % Geom.ANGLE_360;
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
		return Math.abs((this.acceleration() * dt) - ((turning ? 3 : 1) * this.windResistence() * dt));
	}

	function adjustSpeed(currentSpeed:Float) {
		if (currentSpeed < 0) {
			currentSpeed = 0;
		}

		return currentSpeed;
	}

	function getMaxSpeed() {
		return SailTypes.getMaxSpeed(this.sailConfig, this.getRelativeAngle()) * wind.intensity;
	}

	function toggleSail() {
		var sail = (this.sail == SailTypes.NONE) ? SailTypes.STAYSAIL : (this.sail == SailTypes.STAYSAIL ? SailTypes.SPINNAKER : SailTypes.STAYSAIL);
		this.setSail(sail);
	}

	function setSail(sailType:String) {
		this.sail = sailType;
		this.tile = Atlas.instance.get(this.sail).center();
		this.sailConfig = SailTypes.getConfig(this.sail);
	}

	function debug(totalAcc) {
		if (Key.isReleased(Key.QWERTY_MINUS)) {
			showDebug = !showDebug;
		}
		if (showDebug) {
			this.printDebugInfo(totalAcc);
		} else {
			debugText.text = '';
		}
	}
}
