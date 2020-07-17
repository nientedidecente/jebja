package jebja.entities;

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
