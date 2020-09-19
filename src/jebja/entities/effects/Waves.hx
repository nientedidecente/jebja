package jebja.entities.effects;

import jebja.libs.Randomizer;
import haxe.Timer;
import jebja.config.Colours;
import h2d.Tile;
import h2d.Particles;
import h2d.Object;

class Waves {
	static final DISTANCE_MAX = 100;

	public static function generate(x:Float, y:Float, parent:Object, lifespan:Int) {
		var particles = new Particles(parent);
		var g = new ParticleGroup(particles);
		g.texture = Tile.fromColor(Colours.WAVE, 1, 100).getTexture();
		g.size = 4;
		g.nparts = 60;
		g.sizeRand = .2;
		g.life = 2;
		g.speed = 0;
		g.speedRand = 0;
		g.emitMode = PartEmitMode.Point;
		g.emitDist = 800;
		g.fadeIn = 0;
		g.fadeOut = 0.9;
		particles.alpha = .5;
		particles.x = x + Randomizer.intZ(0, DISTANCE_MAX);
		particles.y = y + Randomizer.intZ(0, DISTANCE_MAX);
		particles.addGroup(g);
		Timer.delay(function() {
			particles.removeGroup(g);
			particles.remove();
		}, lifespan + 500);
	}
}
