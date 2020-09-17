package jebja.entities.course;

import differ.shapes.Shape;
import h2d.Object;

class BuoyCP extends Checkpoint {
	var buoy:TargetBuoy;

	override public function get_x():Float {
		return buoy.x;
	}

	override public function set_x(x:Float):Float {
		buoy.x = x;
		return x;
	}

	override public function get_y():Float {
		return buoy.y;
	}

	override public function set_y(y:Float):Float {
		buoy.y = y;
		return y;
	}

	public function new(parent:Object, x:Float, y:Float) {
		active = false;
		visited = false;

		buoy = new TargetBuoy(parent);
		buoy.x = x;
		buoy.y = y;
	}

	override function getCollider():Null<Shape> {
		return buoy.collider;
	}

	override function onActivation() {
		buoy.showHalo();
	}

	override function onDeActivation() {
		buoy.hideHalo();
	}
}
