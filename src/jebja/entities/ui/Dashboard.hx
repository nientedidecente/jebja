package jebja.entities.ui;

import h2d.Flow;
import hxd.Window;
import h2d.Graphics;
import h2d.Object;
import jebja.entities.ui.dashboard.Info;
import jebja.entities.ui.dashboard.ValueLabel;

class Labels {
	public static final HEADING = 'heading: ';
	public static final POSITION = 'position: ';
	public static final SPEED = 'speed: ';
}

class Dashboard {
	static final SIZE = {w: 800, h: 100};

	var parent:Object;
	var info:Null<Info>;

	var position:ValueLabel;
	var heading:ValueLabel;
	var speed:ValueLabel;

	var wrapper:Flow;
	var right:Flow;
	var left:Flow;

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
		var window = Window.getInstance();
		this.parent = parent;
		var wrapper = new Graphics(parent);
		wrapper.beginFill(0x000000);
		wrapper.drawRect(0, 0, window.width / 2, SIZE.h);
		wrapper.endFill();
		wrapper.visible = false;
		texture = wrapper;

		initFlow(window.width);
		heading = new ValueLabel(left);
		heading.label.text = Labels.HEADING;

		position = new ValueLabel(left);
		position.label.text = Labels.POSITION;

		speed = new ValueLabel(right);
		speed.label.text = Labels.SPEED;

		this.x = window.width / 4;
		this.y = window.height - SIZE.h;
	}

	function initFlow(width:Int) {
		wrapper = new h2d.Flow(texture);
		wrapper.layout = FlowLayout.Horizontal;
		wrapper.maxWidth = Math.ceil(width / 2);
		wrapper.maxHeight = SIZE.h;
		wrapper.horizontalAlign = FlowAlign.Middle;
		wrapper.verticalAlign = FlowAlign.Top;

		left = new h2d.Flow(wrapper);
		left.layout = FlowLayout.Vertical;
		left.horizontalAlign = FlowAlign.Left;
		left.verticalAlign = FlowAlign.Top;
		left.minWidth = Math.ceil(wrapper.maxWidth / 2);

		right = new h2d.Flow(wrapper);
		right.layout = FlowLayout.Vertical;
		right.horizontalAlign = FlowAlign.Left;
		right.verticalAlign = FlowAlign.Top;
		right.minWidth = Math.ceil(wrapper.maxWidth / 2);
	}

	public function update(player:Player) {
		if (!visible) {
			return;
		}

		info = new Info(player);

		heading.value.text = '${info.heading}';
		position.value.text = '${info.position}';
		speed.value.text = '${info.speed}';
	}
}
