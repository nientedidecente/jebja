package jebja.entities.course;

import h2d.Object;

class GateCP extends Checkpoint {
	var gate:Gate;

	override public function get_x():Float {
		return gate.x;
	}

	override public function set_x(x:Float):Float {
		gate.x = x;
		return x;
	}

	override public function get_y():Float {
		return gate.y;
	}

	override public function set_y(y:Float):Float {
		gate.y = y;
		return y;
	}

	public function new(parent:Object, x:Float, y:Float) {
		active = false;
		visited = false;

		gate = new Gate(parent, 10);
		gate.x = x;
		gate.y = y;
	}
}
