package jebja.entities;

import jebja.libs.Atlas;
import h2d.col.Point;
import haxe.Timer;
import jebja.config.Colours;
import h2d.Tile;
import h2d.Particles;
import h2d.Object;

class Trace {
	static final LIFE = 5000;

	public static function show(x, y, parent:Object, texture:Null<String> = null, mode:PartEmitMode = PartEmitMode.Point, lifespan:Null<Int> = null) {
		lifespan = lifespan == null ? LIFE : lifespan;
		var particles = new Particles(parent);
		var g = new ParticleGroup(particles);
		g.texture = texture == null ? Tile.fromColor(Colours.TRAIL).getTexture() : Atlas.instance.getTexture(texture);
		g.size = texture == null ? 3 : .2;
		g.nparts = 10;
		g.sizeRand = .2;
		g.life = .3;
		g.speed = 5;
		g.speedRand = 3;
		g.emitMode = mode;
		g.emitDist = 10;
		g.fadeIn = 0;
		g.fadeOut = 0.9;
		particles.x = x;
		particles.y = y;
		particles.addGroup(g);
		Timer.delay(function() {
			particles.removeGroup(g);
			particles.remove();
		}, lifespan);
	}

	public static function getOrigin(position:Point, movement:Point):Point {
		var spacing = (Player.SIZE / 2) + 1;
		var x = position.x + (-1 * movement.x * spacing);
		var y = position.y + (-1 * movement.y * spacing);
		return new Point(x, y);
	}
}
