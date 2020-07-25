import hxd.Res;
import jebja.scenes.BaseScene;
import jebja.scenes.Menu;
import jebja.scenes.World;
import hxd.Key;
import hxd.App;

class Game extends App {
	var currentScene:Null<BaseScene>;

	function setCurrentScene(scene:BaseScene) {
		this.setScene2D(scene);
		currentScene = scene;
	}

	static function main() {
		#if hl
		Res.initLocal();
		#end

		#if js
		Res.initEmbed();
		#end
		
		new Game();
	}

	override function init() {
		mainMenu();
	}

	function mainMenu() {
		var onStart = function() {
			startGame();
		};
		var menuScene = new Menu();
		menuScene.registerOnStart(onStart);
		setCurrentScene(menuScene);
	}

	function startGame() {
		var levelScene = new World();

		levelScene.registerHandlers(function() {
			mainMenu();
		}, function() {
			levelScene.init();
		});
		setCurrentScene(levelScene);
	}

	override function update(dt:Float) {
		if (Key.isPressed(Key.ESCAPE)) {
			trace('ESCAPE pressed');
			#if js
			js.Browser.document.location.replace("https://github.com/nientedidecente/jebja");
			#else
			Sys.exit(0);
			#end
		}

		if (currentScene != null) {
			currentScene.update(dt);
		}
	}
}
