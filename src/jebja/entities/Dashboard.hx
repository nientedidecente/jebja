package jebja.entities;

import h2d.Graphics;
import h2d.Object;

class Dashboard {
	static final SIZE = {w: 300, h: 500};

	var parent:Object;

	public var texture:Graphics;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var visible(get, set):Bool;

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

	public function get_visible() {
		return texture.visible;
	}

	public function set_visible(visible:Bool) {
		return texture.visible = visible;
	}

	public function new(parent:Object) {
		this.parent = parent;
		var wrapper = new Graphics(parent);
		wrapper.beginFill(0x000000);
		wrapper.drawRect(0, 0, SIZE.w, SIZE.h);
		wrapper.endFill();
		wrapper.visible = false;
		this.texture = wrapper;
		this.texture.tile = this.texture.tile.center();
	}

	public function update(player:Player) {
		x = player.x + 50;
		y = player.y - 200;
	}
}
