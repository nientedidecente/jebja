package ui;

import h2d.Bitmap;
import h2d.Scene;
import h2d.Text;
import h2d.Tile;

class UiHelper {
	public static function addBackground(scene:Scene, colour:Int = 0xffffff) {
		var backgound = new Bitmap(Tile.fromColor(colour, scene.width, scene.height), scene);
		backgound.x = 0;
		backgound.y = 0;
		return backgound;
	}

	public static function addHeader(label:String, scene:Scene, colour:Int = 0xffffff) {
		var t = new h2d.Text(hxd.res.DefaultFont.get(), scene);
		t.scale(10);
		t.text = label;
		t.textColor = colour;
		t.textAlign = Align.Center;
		t.x = scene.width * .5;

		return t;
	}

	public static function addInfo(label:String, scene:Scene) {
		var t = new h2d.Text(hxd.res.DefaultFont.get(), scene);
		t.scale(5);
		t.text = label;
		t.textAlign = Align.Center;
		t.x = scene.width * .5;
		t.y = scene.height * .5;

		return t;
	}
}
