package jebja.entities.ui;

import h2d.Flow;
import jebja.entities.ui.dashboard.Info;
import hxd.Window;
import h2d.Text;
import h2d.Graphics;
import h2d.Object;

class Labels {
	public static final HEADING = 'heading: ';
	public static final POSITION = 'position: ';
	public static final SPEED = 'speed: ';
}

class Dashboard {
	static final SIZE = {w: 800, h: 100};

	var parent:Object;
	var info:Null<Info>;

	var position:Text;
	var heading:Text;
	var speed:Text;

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
		heading = Dashboard.addText(left);
		heading.text = Labels.HEADING;

		position = Dashboard.addText(left);
		position.text = Labels.POSITION;

		speed = Dashboard.addText(right);
		speed.text = Labels.SPEED;

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

		heading.text = '${Labels.HEADING} ${info.heading}';
		position.text = '${Labels.POSITION} ${info.position}';
		speed.text = '${Labels.SPEED} ${info.speed}';
	}

	public static function addText(texture:Object):Text {
		var textBox = new Text(hxd.res.DefaultFont.get(), texture);
		textBox.text = '';
		textBox.textColor = 0xffffff;
		textBox.scale(2);
		return textBox;
	}
}
