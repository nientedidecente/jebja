package jebja.entities.course;

import h2d.col.Point;
import jebja.libs.Geom;
import jebja.libs.Atlas;
import h2d.Object;
import jebja.config.Colours;
import h2d.Text;
import h2d.Bitmap;

class Track {
	static final INDICATOR_RENDER_DISTANCE = 50;

	var background:Object;
	var foreground:Object;
	var checkpoints:Array<Checkpoint>;

	var nextCheckpoint:Null<Checkpoint>;
	var previousCheckpoint:Null<Checkpoint>;

	var indicator:Bitmap;
	var distanceText:Text;

	public function new(background:Object, foreground:Object) {
		this.background = background;
		this.foreground = foreground;
		indicator = new Bitmap(Atlas.instance.getRes('target').toTile().center(), foreground);
		indicator.scale(.5);

		distanceText = new h2d.Text(hxd.res.DefaultFont.get(), foreground);
		distanceText.textColor = Colours.BUOY_LIGHT;
		distanceText.textAlign = Align.Center;

		checkpoints = new Array<Checkpoint>();
		checkpoints.push(new GateCP(background, 1000, 1000));
		checkpoints.push(new GateCP(background, -800, -800));

		nextCheckpoint = checkpoints[0];
	}

	public function update(player:Player) {
		if (nextCheckpoint == null) {
			trace("finished track");
			return;
		}

		// check distance between player and next checkpoint
		// check collision between player and checkpoint
		// update indicator
		updateStepIndicator(player);
		// check if there are more checkpoints
	}

	function updateStepIndicator(player:Player) {
		if (nextCheckpoint == null)
			return;

		var x = nextCheckpoint.x;
		var y = nextCheckpoint.y;
		var parentPos = new Point(player.x, player.y);
		var me = new Point(x, y);
		var distance = parentPos.distance(me);
		var pos = Geom.pointOnLine(player.x, player.y, x, y, distance, Math.min(300.0, distance / 2));

		indicator.x = pos.x;
		indicator.y = pos.y;
		var showIndicator = pos.distance(me) > INDICATOR_RENDER_DISTANCE;
		indicator.visible = showIndicator;
		indicator.rotation = ((Math.PI / 2) + Math.atan2(y - pos.y, x - pos.x));
		distanceText.text = '${std.Math.ceil(distance)}';
		distanceText.x = pos.x - 20;
		distanceText.y = pos.y - 20;
		distanceText.visible = showIndicator;
	}
}
