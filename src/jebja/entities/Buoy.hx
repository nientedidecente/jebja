package jebja.entities;

import h2d.Graphics;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Object;
import jebja.config.Colours;
import jebja.libs.Randomizer;

class Buoy {
	var size:Int;

	public var texture:Graphics;
	public var x(get, set):Float;
	public var y(get, set):Float;

	public function get_x() {
		return this.texture.x;
	}

	public function set_x(x) {
		return this.texture.x = x;
	}

	public function get_y() {
		return this.texture.y;
	}

	public function set_y(y) {
		return this.texture.y = y;
	}

	public function new(parent:Object) {
		this.size = Randomizer.int(5, 10);

		var cirle = new Graphics(parent);
		cirle.beginFill(Colours.BUOY);
		cirle.drawCircle(0, 0, size);
		cirle.endFill();

		this.texture = cirle;
	}

	public function update(player:Player) {
		var parentPos = new Point(player.x, player.y);
		var me = new Point(this.x, this.y);
		this.texture.visible = parentPos.distance(me) < 900 + this.size / 2;
	}
}
