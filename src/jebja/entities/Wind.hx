package jebja.entities;

import jebja.libs.Geom;

class Wind {
	public var direction:Int;
	public var intensity:Float;

	public function new(direction:Int, intensity:Float) {
		this.direction = direction;
		this.intensity = intensity;
	}

	public static function generate(direction:Null<Int> = null, intensity:Null<Float> = null):Wind {
		direction = direction == null ? Geom.ANGLE_180 : direction;
		intensity = intensity == null ? 1. : intensity;
		return new Wind(direction, intensity);
	}
}
