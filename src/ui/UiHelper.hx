package ui;

import haxe.Timer;
import h2d.col.Point;
import h2d.Bitmap;
import h2d.Scene;
import h2d.Text;
import h2d.Tile;

class UiHelper {
	public static function addBackground(scene:Scene, colour:Int = 0xffffff) {
		var background = new Bitmap(Tile.fromColor(colour, scene.width, scene.height), scene);
		background.x = 0;
		background.y = 0;
		return background;
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

	public static function addTips(label:String, scene:Scene, timeout:Int = 10000, offset:Null<Point> = null) {
		offset = offset == null ? new Point(-100, -300) : offset;
		var t = new h2d.Text(hxd.res.DefaultFont.get(), scene);
		t.scale(2);
		t.text = label;
		t.x = scene.width * .5 + offset.x;
		t.y = scene.height * .5 + offset.y;

		Timer.delay(function() {
			t.remove();
		}, timeout);

		return t;
	}
}
