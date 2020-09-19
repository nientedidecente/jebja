package jebja.entities.floaters;

import h2d.Graphics;
import jebja.libs.Randomizer;
import differ.shapes.Circle;
import differ.shapes.Shape;
import h2d.Text;
import jebja.libs.Atlas;
import jebja.libs.Geom;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Object;
import jebja.config.Colours;
import hxd.Math;

class TargetBuoy extends Buoy {
	static final MIN_DISTANCE = 1;
	static final MAX_DISTANCE = 3;
	static final DISTANCE_MULTIPLIER = 300;

	var halo:Graphics;
	var indicator:Bitmap;
	var distanceText:Text;

	public var collider:Null<Shape>;

	override function set_x(x:Float):Float {
		this.collider.x = x;
		this.halo.x = x;
		return super.set_x(x);
	}

	override function set_y(y:Float):Float {
		this.collider.y = y;
		this.halo.y = y;
		return super.set_y(y);
	}

	public function new(parent:Object, colour:Null<Int> = null) {
		super(parent, Colours.BUOY_LIGHT);
		halo = new Graphics(parent);
		halo.beginFill(Colours.BUOY_LIGHT, .1);
		halo.drawCircle(0, 0, size * 4);
		halo.endFill();

		collider = new Circle(1000, 1000, size * 2);
	}

	public function showHalo() {
		halo.visible = true;
	}

	public function hideHalo() {
		halo.visible = false;
	}

	override public function destroy() {
		indicator.remove();
		collider.destroy();
		halo.remove();
		texture.remove();
	}

	public static function generate(parent) {
		var target = new TargetBuoy(parent);
		target.x = Randomizer.intZ(MIN_DISTANCE, MAX_DISTANCE) * DISTANCE_MULTIPLIER;
		target.y = Randomizer.intZ(MIN_DISTANCE, MAX_DISTANCE) * DISTANCE_MULTIPLIER;

		return target;
	}
}
