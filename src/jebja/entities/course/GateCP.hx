package jebja.entities.course;

import differ.shapes.Shape;
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

	public function new(parent:Object, x:Float, y:Float, size = 50) {
		active = false;
		visited = false;

		gate = new Gate(parent, size);
		gate.forcePosition(x, y);
		gate.setLineVisibility(false);
	}

	override function getCollider():Null<Shape> {
		return gate.collider;
	}

	override function onActivation() {
		gate.setLineVisibility(true);
	}

	override function onDeActivation() {
		gate.setLineVisibility(false);
	}
}
