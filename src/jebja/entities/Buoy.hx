package jebja.entities;

import h2d.Bitmap;
import h2d.col.Point;
import h2d.Object;
import jebja.config.Colours;
import jebja.libs.Randomizer;
import h2d.Tile;
import differ.shapes.Circle;

class Buoy extends Bitmap {
	var size:Int;

	public function new(parent:Object) {
		this.size = Randomizer.int(10, 80);
		var tile = Tile.fromColor(Colours.BUOY, size, size);
		tile = tile.center();
		super(tile, parent);
		visible = false;
	}

	public function update(player:Player) {
		var parentPos = new Point(player.x, player.y);
		var me = new Point(this.x, this.y);
		this.visible = parentPos.distance(me) < 900 + this.size / 2;
	}
}
