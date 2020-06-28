package jebja.libs;

import hxd.Math;

class Geom {
	static final ANGLE_SENSITIVITY = 3;
	public static final ANGLE_45 = 45;
	public static final ANGLE_90 = 95;
	public static final ANGLE_135 = 135;
	public static final ANGLE_180 = 180;

	static final HALF_WAY_MODIFIER = .5;
	static final MAX_MODIFIER = 2;
	static final INTERPOLATED_WEIGHT = 0.0111111;

	public static function toFixed(number:Float):Float {
		return Math.floor(number * 100 + .5) / 100.;
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
			return Geom.toFixed(((1 + HALF_WAY_MODIFIER) - (angle * INTERPOLATED_WEIGHT)));
		}

		if (angle > (ANGLE_90 + ANGLE_SENSITIVITY) && angle <= (ANGLE_135 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((angle * INTERPOLATED_WEIGHT) - HALF_WAY_MODIFIER);
		}

		if (angle > (ANGLE_135 + ANGLE_SENSITIVITY) && angle <= (ANGLE_180 + ANGLE_SENSITIVITY)) {
			return Geom.toFixed((angle / ANGLE_45) - MAX_MODIFIER);
		}

		return 0;
	}
}
