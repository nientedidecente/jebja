package jebja.entities;

import h2d.Object;
import jebja.config.Colours;
import jebja.libs.Randomizer;
import h2d.Tile;
import differ.shapes.Circle;

class Buoy extends Collidable {
	var size:Int;

	public function new(parent:Object) {
		this.size = Randomizer.int(10, 80);
		var tile = Tile.fromColor(Colours.BUOY, size, size);
		tile = tile.center();
		super(parent, tile);
		collider = new Circle(this.x, this.y, size * .5);
	}
}
