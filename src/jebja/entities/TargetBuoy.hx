package jebja.entities;

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
	var indicator:Bitmap;
	var distanceText:Text;

	public var collider:Null<Shape>;

	override function set_x(x:Float):Float {
		this.collider.x = x;
		return super.set_x(x);
	}

	override function set_y(y:Float):Float {
		this.collider.y = y;
		return super.set_y(y);
	}

	public function new(parent:Object, colour:Null<Int> = null) {
		super(parent, Colours.BUOY_LIGHT);

		indicator = new Bitmap(Atlas.instance.getRes('target').toTile().center(), parent);
		indicator.scale(.5);

		distanceText = new h2d.Text(hxd.res.DefaultFont.get(), parent);
		distanceText.textColor = Colours.BUOY_LIGHT;
		distanceText.textAlign = Align.Center;

		collider = new Circle(1000, 1000, size);
	}

	override public function update(player:Player) {
		var parentPos = new Point(player.x, player.y);
		var me = new Point(this.x, this.y);
		var distance = parentPos.distance(me);
		var inView = distance < 900 + this.size / 2;
		texture.visible = inView;
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
	}

	public function destroy() {
		indicator.remove();
		collider.destroy();
		texture.remove();
	}

	public static function generate(parent) {
		var target = new TargetBuoy(parent);
		target.x = Randomizer.int(1, 10) * 1000 * (Randomizer.chance(50) ? 1 : -1);
		target.y = Randomizer.int(1, 10) * 1000 * (Randomizer.chance(50) ? 1 : -1);

		return target;
	}
}
