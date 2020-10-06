package jebja.entities.ui.dashboard;

import h2d.Object;
import h2d.Text;
import h2d.Flow;

class ValueLabel extends Flow {
	public var label:Text;
	public var value:Text;

	public function new(parent) {
		super(parent);
		layout = FlowLayout.Horizontal;
		label = ValueLabel.addText(this);
		value = ValueLabel.addText(this);
	}

	public static function addText(texture:Object):Text {
		var textBox = new Text(hxd.res.DefaultFont.get(), texture);
		textBox.text = '';
		textBox.textColor = 0xffffff;
		textBox.scale(2);
		return textBox;
	}
}
