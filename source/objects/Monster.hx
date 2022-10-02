package objects;

import util.ConstructionManager;
import flixel.path.FlxPath;
import flixel.util.FlxTimer;

class Monster extends GameObject {

	var target(get, default):Gadget;
	function get_target() return target == null || !target.alive ? target = Gadget.gadgets.get_random() : target;
	var speed:Float = 0;

	public function new(side:EntrySide, y:Float) {
		super();
		var _x = switch side {
			case LEFT:-64;
			case RIGHT:FlxG.width + 64;
		}
		setPosition(_x, y);
		new FlxTimer().start(y/16 * 0.05, t -> {
			path = new FlxPath();
			var nx = switch side {
				case LEFT:32;
				case RIGHT:FlxG.width - 32;
			}
			path.start([FlxPoint.get(mx, my), FlxPoint.get(nx, my)], 40).onComplete = p -> {
				new FlxTimer().start(3, t -> get_path());
			}
		});
		MONSTERS.add(this);
	}

	public function get_path() {
		var nodes = CONSTRUCTION_MNGR.path(wx, wy, target.wx, target.wy);
		trace('path', nodes);
		if (path.active) path.cancel();
		path.start([for (node in nodes) FlxPoint.get(node.x * GRID_SIZE + GRID_SIZE/2, node.y * GRID_SIZE + GRID_SIZE/2)], speed).onComplete = p -> {};
	}

	override function kill() {
		MONSTERS.remove(this);
		super.kill();
	}

}

enum EntrySide {
	LEFT;
	RIGHT;
}