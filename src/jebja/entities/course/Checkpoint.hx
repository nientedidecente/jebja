package jebja.entities.course;

import differ.shapes.Shape;

class Checkpoint {
	var active:Bool;
	var visited:Bool;

	public var x(get, set):Float;
	public var y(get, set):Float;

	public function get_x():Float {
		return 0;
	}

	public function set_x(_:Float):Float {
		return 0;
	}

	public function get_y():Float {
		return 0;
	}

	public function set_y(_:Float):Float {
		return 0;
	}

	public function activate() {
		this.active = true;
	}

	public function deActivate() {
		this.active = false;
	}

	public function flagAsVisited() {
		this.visited = true;
	}

	public function onCrossing() {
		deActivate();
		flagAsVisited();
	}

	public function isActive():Bool {
		return this.active;
	}

	public function wasVisited():Bool {
		return this.visited;
	}

	public function getCollider():Null<Shape> {
		return null;
	}
}
