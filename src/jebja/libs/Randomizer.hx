package jebja.libs;

class Randomizer {
	public static inline function chance(percentage:Int):Bool {
		return int(0, 100) >= percentage;
	}

	public static inline function int(from:Int, to:Int):Int {
		return from + Math.floor(((to - from + 1) * Math.random()));
	}

	public static inline function intZ(from:Int, to:Int):Int {
		return (chance(50) ? 1 : -1) * int(from, to);
	}
}
