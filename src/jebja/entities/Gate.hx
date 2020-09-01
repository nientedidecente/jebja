package jebja.entities;

import jebja.libs.Randomizer;
import differ.Collision;
import differ.shapes.Polygon;
import differ.shapes.Shape;
import h2d.Text;
import h2d.Bitmap;
import h2d.Object;
import hxd.Math;

class Gate extends Object {
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
		/*

			indicator = new Bitmap(Atlas.instance.getRes('target').toTile().center(), parent);
			indicator.scale(.5);

			distanceText = new h2d.Text(hxd.res.DefaultFont.get(), parent);
			distanceText.textColor = Colours.BUOY_LIGHT;
			distanceText.textAlign = Align.Center;

			collider = new Circle(1000, 1000, size * 2);
		 */
	}

	public function update(player:Player) {
		if (Collision.shapeWithShape(player.collider, collider) != null) {
			trace('gate hit ${Randomizer.int(0, 10)}');
		}
		/*
			var parentPos = new Point(player.x, player.y);
			var me = new Point(this.x, this.y);
				var distance = parentPos.distance(me);
				var inView = distance < 900 + this.size / 2;
					var pos = Geom.pointOnLine(player.x, player.y, x, y, distance, Math.min(300.0, distance / 2));

					indicator.x = pos.x;
					indicator.y = pos.y;
					var showIndicator = pos.distance(me) > 180;
					indicator.visible = showIndicator;
					indicator.rotation = ((Math.PI / 2) + Math.atan2(y - pos.y, x - pos.x));
					distanceText.text = '${std.Math.ceil(distance)}';
					distanceText.x = pos.x - 20;
					distanceText.y = pos.y - 20;
					distanceText.visible = showIndicator;
		 */
	}

	public function destroy() {
		indicator.remove();
		collider.destroy();
	}

	public function initTexture() {
		var left = Buoy.drop(this, -50, 0, 10);
		var right = Buoy.drop(this, size + 50, 0, 10);
	}
}
