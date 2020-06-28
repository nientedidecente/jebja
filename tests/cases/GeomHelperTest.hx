package tests.cases;

import jebja.libs.Geom;
import utest.Test;
import utest.Assert;

class GeomHelperTest extends Test {
	public function testRotationCorrectlyConvertsToDegrees() {
		var angle = Geom.directionAngle(Math.PI);
		Assert.equals(180, angle);

		var angle = Geom.directionAngle(Math.PI / 2);
		Assert.equals(90, angle);

		var angle = Geom.directionAngle(Math.PI / 4);
		Assert.equals(45, angle);

		var angle = Geom.directionAngle(0);
		Assert.equals(0, angle);

		var angle = Geom.directionAngle(-(Math.PI / 4));
		Assert.equals(-45, angle);

		var angle = Geom.directionAngle(-(Math.PI / 2));
		Assert.equals(-90, angle);

		var angle = Geom.directionAngle(-(Math.PI));
		Assert.equals(-180, angle);
	}

	public function testSpeedModifiers() {
		Assert.equals(0, Geom.speedModifierFromAngle(0));
		Assert.equals(1, Geom.speedModifierFromAngle(Geom.ANGLE_45));
		Assert.equals(.5, Geom.speedModifierFromAngle(Geom.ANGLE_90));
		Assert.equals(1, Geom.speedModifierFromAngle(Geom.ANGLE_135));
		Assert.equals(2, Geom.speedModifierFromAngle(Geom.ANGLE_180));
		Assert.equals(1, Geom.speedModifierFromAngle(Geom.ANGLE_225));
		Assert.equals(.5, Geom.speedModifierFromAngle(Geom.ANGLE_270));
		Assert.equals(1, Geom.speedModifierFromAngle(Geom.ANGLE_315));
		Assert.equals(0, Geom.speedModifierFromAngle(Geom.ANGLE_360));
	}
}
