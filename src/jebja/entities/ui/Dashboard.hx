package jebja.entities.ui;

import haxe.display.Display.SignatureHelpParams;
import h2d.Flow;
import jebja.entities.effects.Wind;
import jebja.entities.ui.dashboard.Info;
import hxd.Window;
import h2d.Text;
import h2d.Graphics;
import h2d.Object;

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
		wrapper.beginFill(0xffffff);
		wrapper.drawRect(0, 0, window.width / 2, SIZE.h);
		wrapper.endFill();
		wrapper.visible = false;
		texture = wrapper;

		initFlow(window.width);
		heading = Dashboard.addText(left);
		heading.text = 'heading: ';

		position = Dashboard.addText(left);
		position.text = 'position: ';

		speed = Dashboard.addText(right);
		speed.text = 'speed: ';

		this.x = window.width / 4;
		this.y = window.height - SIZE.h;
	}

	function initFlow(width:Int) {
		wrapper = new h2d.Flow(texture);
		wrapper.layout = FlowLayout.Horizontal;
		wrapper.maxWidth = Math.ceil(width / 2);
		wrapper.maxHeight = SIZE.h;
		wrapper.horizontalAlign = FlowAlign.Left;
		wrapper.verticalAlign = FlowAlign.Top;

		left = new h2d.Flow(wrapper);
		left.layout = FlowLayout.Vertical;
		left.minWidth = Math.ceil(wrapper.maxWidth / 2);

		right = new h2d.Flow(wrapper);
		right.layout = FlowLayout.Vertical;
		right.minWidth = Math.ceil(wrapper.maxWidth / 2);
	}

	public function update(player:Player) {
		info = new Info(player);
	}

	public static function addText(texture:Object):Text {
		var textBox = new Text(hxd.res.DefaultFont.get(), texture);
		textBox.text = '';
		textBox.textColor = 0x000000;
		textBox.scale(2);
		return textBox;
	}
}
