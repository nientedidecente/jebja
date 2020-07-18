package jebja.scenes;

import jebja.config.Colours;
import ui.UiHelper;
import hxd.Event;
import hxd.Key;

class Menu extends BaseScene {
	override function init() {
		super.init();
		UiHelper.addBackground(this, Colours.SEA);
		UiHelper.addHeader('jebja', this);
		#if js
		var escAction = 'to see the github repo';
		#else
		var escAction = 'to Quit';
		#end
		UiHelper.addInfo('[ENTER] to Start\n[ESC] ${escAction}', this);
	}

	public function registerOnStart(onStart:Void->Void) {
		this.addEventListener(function(event:Event) {
			if (event.kind == EventKind.EKeyDown && event.keyCode == Key.ENTER) {
				onStart();
			}
		});
	}
}
