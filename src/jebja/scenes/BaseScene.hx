package jebja.scenes;

import h2d.Scene;

class BaseScene extends Scene {
	public function new() {
		super();
		this.init();
	}

	public function init() {}

	public function update(dt:Float) {
		return;
	}
}
