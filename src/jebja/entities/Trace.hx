package jebja.entities;

import h2d.col.Point;
import haxe.Timer;
import jebja.config.Colours;
import h2d.Tile;
import h2d.Particles;
import h2d.Object;

class Trace {
	public static final DELAY = 350;
	static final LIFE = 4000;

	public function new(x, y, parent:Object, lifespan:Null<Int> = null) {
		lifespan = lifespan == null ? LIFE : lifespan;
		var particles = new Particles(parent);
		var g = new ParticleGroup(particles);
		g.texture = Tile.fromColor(Colours.TRAIL).getTexture();
		g.size = 3;
		g.nparts = 10;
		g.sizeRand = .2;
		g.life = .3;
		g.speed = 5;
		g.speedRand = 3;
		g.emitMode = PartEmitMode.Point;
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

	public static function getOrigin(oldPosition:Point, newPosition:Point) {
		return {
			x: oldPosition.x,
			y: oldPosition.y,
			delay: Trace.DELAY
		}
	}
}
