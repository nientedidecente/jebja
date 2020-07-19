package jebja.libs;

import hxd.Res;
import h2d.Tile;

class Atlas {
	var atlas:hxd.res.Atlas;

	public static final instance:Atlas = new Atlas();

	private function new() {
		#if hl
		Res.initLocal();
		#end

		#if js
		Res.initEmbed();
		#end
		atlas = hxd.Res.load("boat_s.atlas").to(hxd.res.Atlas);
	}

	public function get(name:String):Tile {
		return atlas.get(name);
	}

	public function getTexture(name:String) {
		return getRes(name).toTexture();
	}

	public function getRes(name:String) {
		return Res.load('${name}.png');
	}
}
