package jebja.entities.ui.dashboard;

import jebja.libs.Geom;
import h2d.col.Point;
import jebja.entities.effects.Wind;

class Info {
	public var position:Point;
	public var heading:Int;
	public var optimalHeading:Int;
	public var speed:Float;

	public function new(player:Player) {
		var wind = player.getWind();
		position = new Point(Math.ceil(player.x), Math.ceil(player.y));
		heading = Geom.getHeading(player.rotation);
		optimalHeading = Geom.getOptimalHeading(wind.direction, player.rotation);
		speed = Geom.toFixed(player.currentSpeed * wind.intensity * Wind.KNOTS);
	}
}
