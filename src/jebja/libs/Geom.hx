package jebja.libs;

import hxd.Math;

class Geom {
	public static final ANGLE_SENSITIVITY = 3;
	public static final ANGLE_45 = 45;
	public static final ANGLE_90 = 95;
	public static final ANGLE_135 = 135;
	public static final ANGLE_180 = 180;
	public static final ANGLE_225 = 225;
	public static final ANGLE_270 = 270;
	public static final ANGLE_315 = 315;
	public static final ANGLE_360 = 360;

	static final HALF_WAY_MODIFIER = .5;
	static final MAX_MODIFIER = 2;
	static final INTERPOLATED_WEIGHT = 0.0111111;

	public static function toFixed(number:Float, positions:Int = 2):Float {
		var modifier = Math.pow(10, positions);
		return Math.floor(number * modifier + .5) / modifier;
	}

	public static function directionAngle(rotation:Float) {
		return Math.ceil(Math.radToDeg(rotation % (2 * Math.PI)));
	}

	public static function speedModifierFromAngle(angle:Float):Float {
		angle = Math.abs(angle);

		if (angle == 0 || angle < ANGLE_SENSITIVITY) {
			return 0;
		}

		if (angle > ANGLE_SENSITIVITY && angle <= ANGLE_45 + ANGLE_SENSITIVITY) {
			return angle / ANGLE_45;
		}

		if (angle > (ANGLE_45 + ANGLE_SENSITIVITY) && angle <= (ANGLE_90 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((1 + 0.6) - (angle * INTERPOLATED_WEIGHT), 1);
		}

		if (angle > (ANGLE_90 + ANGLE_SENSITIVITY) && angle <= (ANGLE_135 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((angle * INTERPOLATED_WEIGHT) - HALF_WAY_MODIFIER);
		}

		if (angle > (ANGLE_135 + ANGLE_SENSITIVITY) && angle <= (ANGLE_180 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((angle / ANGLE_45) - MAX_MODIFIER);
		}

		// those next ones need reinterpolation if we want to change maxes
		if (angle > (ANGLE_180 + ANGLE_SENSITIVITY) && angle <= (ANGLE_225 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed(6 - (angle / ANGLE_45));
		}

		if (angle > (ANGLE_225 + ANGLE_SENSITIVITY) && angle <= (ANGLE_270 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed(3.5 - (angle * INTERPOLATED_WEIGHT));
		}

		if (angle > (ANGLE_270 + ANGLE_SENSITIVITY) && angle <= (ANGLE_315 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((angle * INTERPOLATED_WEIGHT) - 2.5);
		}

		if (angle > (ANGLE_315 + ANGLE_SENSITIVITY) && angle <= (ANGLE_360 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed(8 - (angle / ANGLE_45));
		}

		return 0;
	}
}
