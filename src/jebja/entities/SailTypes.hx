package jebja.entities;

import jebja.libs.Geom;

final class SailTypes {
	static final SENSITIVITY = .2;
	public static final NONE = 'base';
	public static final MAINSAIL = 'mainsail';
	public static final STAYSAIL = 'staysail';
	public static final SPINNAKER = 'spinnaker';

	public static function getConfig(type:Null<String>):SailConfig {
		if (type == SailTypes.STAYSAIL) {
			return SailConfig.make({
				// Stern, Bow, CloseWind, Across
				maxSpeed: [2.5, 0, 2.5, 1.8],
				windResistence: .3
			});
		}

		if (type == SailTypes.SPINNAKER) {
			return SailConfig.make({
				maxSpeed: [4, 0, 1, 1],
				windResistence: .4
			});
		}

		return SailConfig.make({
			maxSpeed: [.3, 0, 0.2, 0.2],
			windResistence: .2
		});
	}

	public static function getMaxSpeed(config:SailConfig, angle:Float):Float {
		var modifier = Geom.modifierFromAngle(angle);

		if (modifier <= SENSITIVITY) {
			return config.maxSpeed.bow;
		}

		if (modifier <= (.5 + SENSITIVITY)) {
			return config.maxSpeed.across;
		}

		if (modifier <= (1 + SENSITIVITY)) {
			return config.maxSpeed.closeWind;
		}

		return config.maxSpeed.stern;
	}
}
