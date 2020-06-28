package jebja.libs;

import hxd.Math;

class Geom {
	public static function directionAngle(rotation:Float) {
		return Math.ceil(Math.radToDeg(rotation % (2 * Math.PI)));
	}
}
