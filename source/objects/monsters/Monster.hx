package objects.monsters;

import zero.utilities.Vec2;
import zero.utilities.IntPoint;
import fx.Decal;
import util.ConstructionManager;
import flixel.path.FlxPath;
import flixel.util.FlxTimer;
import objects.constructions.Gadget;

class Monster extends GameObject {

	public var collision_timer:Float = 0.25;

	public var target(get, default):Gadget;
	function get_target() {
		if (target != null && target.alive) return target;
		for (g in Gadget.gadgets) if (g.gadget_type == DECOY) return target = g;
		Gadget.gadgets.shuffle();
		for (g in Gadget.gadgets) if (g.alive) return target = g;
		return null;
	}
	var speed:Float = 0;
	var power:Int = 0;
	var hit_frame:Int = -1;

	public var walking:Bool = false;

	public function new(side:EntrySide, y:Float) {
		super();
		MONSTERS.add(this);
		PLAYSTATE.monsters.add(this);
		PLAYSTATE.m_col.add(this);
		drag.set(500, 500);
		start(side, y);
		animation.callback = anim_callback;
		elasticity = 1;
		mass = 100.get_random(50);
	}

	function anim_callback(s:String, i:Int, f:Int) {
		if (f == hit_frame) {
			var c = Gadget.get_nearest(mx, my - 4);
			if (c == null) return;
			if (c is Gadget) {
				c.hurt(power);
			}
		}
	}

	function start(side:EntrySide, y:Float) {
		var _x = switch side {
			case LEFT:-64;
			case RIGHT:FlxG.width + 64;
		}
		setPosition(_x, y);
		new FlxTimer().start(y/16 * 0.05, t -> {
			path = new FlxPath();
			var nx = switch side {
				case LEFT:24;
				case RIGHT:FlxG.width - 24;
			}
			path.start([FlxPoint.get(mx, my), FlxPoint.get(nx, my)], 40).onComplete = p -> {
				new FlxTimer().start(3, t -> get_path());
			}
		});
	}

	public function get_path() {
		walking = true;
		target = target;
		var nodes = target == null ? [IntPoint.get(wx, wy)] : CONSTRUCTION_MNGR.path(wx, wy, target.wx, target.wy);
		if (path == null) path = new FlxPath();
		if (path.active) path.cancel();
		path.start([for (node in nodes) FlxPoint.get(node.x * GRID_SIZE + GRID_SIZE/2, node.y * GRID_SIZE + GRID_SIZE/2 + 4)], speed).onComplete = p -> {};
	}

	override function kill() {
		for (i in 0...2) new Decal([BLOOD_1, BLOOD_2].get_random(), mx + 8.get_random(-8), my + 8.get_random(-8), 0.25.get_random(0.1), 360.get_random());
		for (i in 0...3) new FlxTimer().start(i * 0.1).onComplete = t -> PLAYSTATE.poofs.fire({ position: FlxPoint.get(mx, my).add(8.get_random(-8), 8.get_random(-8)) });
		MONSTERS.remove(this);
		super.kill();
		MONSTER_COUNT.amt++;
	}

	var ptimer = 5.0;
	override function update(dt:Float) {
		var d = (last.x - x).abs() + (last.y - y).abs();
		if (d == 0 && target != null && path != null && path.active && (ptimer -= dt) <= 0) {
			target = null;
			get_path();
			ptimer = 5;
		}
		super.update(dt);
	}

}

enum EntrySide {
	LEFT;
	RIGHT;
}