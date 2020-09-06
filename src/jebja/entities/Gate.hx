package jebja.entities;

import h2d.Graphics;
import jebja.libs.Randomizer;
import differ.Collision;
import differ.shapes.Polygon;
import differ.shapes.Shape;
import h2d.Text;
import h2d.Bitmap;
import h2d.Object;
import hxd.Math;

class Gate extends Object {
	var buoys:Array<Buoy>;
	var line:Graphics;

	var size:Float;
	var indicator:Bitmap;
	var distanceText:Text;

	public var collider:Null<Shape>;

	// TODO: in order to avoid those two force functions I might be better doing a decorator
	public function forcePosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		this.collider.x = x;
		this.collider.y = y;
	}

	public function forceRotation(radians:Float) {
		this.rotation = radians;
		this.collider.rotation = Math.radToDeg(this.rotation);
	}

	public function new(parent:Object, size:Float) {
		super(parent);
		this.size = size;
		initTexture();
		collider = Polygon.rectangle(1000, 1000, size, 1);
	}

	public function update(player:Player) {
		if (Collision.shapeWithShape(player.collider, collider) != null) {
			trace('gate hit ${Randomizer.int(0, 10)}');
		}
	}

	public function destroy() {
		indicator.remove();
		collider.destroy();
		for (buoy in buoys) {
			buoy.destroy();
		}
		line.remove();
	}

	public function toggleLine() {
		line.visible = !line.visible;
	}

	public function initTexture() {
		buoys = new Array<Buoy>();
		buoys.push(Buoy.drop(this, -50, 0, 10));
		buoys.push(Buoy.drop(this, size + 50, 0, 10));

		line = new Graphics(this);
		line.beginFill(0xffffff, .5);
		line.drawRect(buoys[0].x + 10, buoys[0].y, size + 83, 1);
		line.endFill();
	}
}
