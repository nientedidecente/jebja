package jebja.entities;

import jebja.libs.Atlas;
import jebja.libs.Geom;
import h2d.Bitmap;
import h2d.col.Point;
import h2d.Object;
import jebja.config.Colours;
import hxd.Math;

class TargetBuoy extends Buoy {
	public var indicator:Bitmap;

	public function new(parent:Object, colour:Null<Int> = null) {
		super(parent, Colours.BUOY_LIGHT);

		indicator = new Bitmap(Atlas.instance.getRes('target').toTile().center(), parent);
		indicator.scale(.5);
	}

	override public function update(player:Player) {
		var parentPos = new Point(player.x, player.y);
		var me = new Point(this.x, this.y);
		var distance = parentPos.distance(me);
		var inView = distance < 900 + this.size / 2;
		var pos = Geom.pointOnLine(player.x, player.y, x, y, distance, Math.min(400.0, distance / 2));
		this.indicator.x = pos.x;
		this.indicator.y = pos.y;

		this.texture.visible = inView;
		this.indicator.visible = pos.distance(me) > 100;
		this.indicator.rotation = ((Math.PI / 2) + Math.atan2(y - pos.y, x - pos.x));
	}
}