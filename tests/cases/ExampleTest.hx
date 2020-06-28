package tests.cases;

import utest.Test;
import utest.Assert;

class ExampleTest extends Test {
	public function testBooleans() {
		Assert.isTrue(true);
		Assert.isFalse(false);
	}
}
