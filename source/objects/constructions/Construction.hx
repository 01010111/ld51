package objects.constructions;

import fx.Decal;
import flixel.util.FlxTimer;
import zero.utilities.Vec2;
import objects.monsters.Monster;

class Construction extends GameObject {

	public var target:Monster;

	public var range:Int = 0;
	public var max_range:Int = 0;

	public var power:Int = 0;
	public var max_power:Int = 0;

	public var rate:Int = 0;
	public var max_rate:Int = 0;

	public var special_properties:Array<SpecialProperty> = [];
	public var allowed_special_properties:Array<SpecialProperty> = [];

	public function new(x:Int, y:Int, mass:Bool = true) {
		super({
			x: GRID_OFFSET_X + x * GRID_SIZE,
			y: GRID_OFFSET_Y + y * GRID_SIZE,
		});
		CONSTRUCTION_MNGR.add(this, x, y, mass, this is Gadget);
		MONSTERS.refresh();
		if (mass) {
			PLAYSTATE.beams.fire({position: FlxPoint.get(x * 16 + GRID_OFFSET_X + 8, y * 16 + GRID_OFFSET_Y + 8)});
			PLAYSTATE.stars.fire({position: FlxPoint.get(x * 16 + GRID_OFFSET_X + 8, y * 16 + GRID_OFFSET_Y + 8)});
			PLAYSTATE.poofs.fire({position: FlxPoint.get(x * 16 + GRID_OFFSET_X + 8, y * 16 + GRID_OFFSET_Y + 8)});
		}
		new FlxTimer().start(0.02).onComplete = t -> FlxG.overlap(this, PLAYSTATE.gold, (c,g) -> g.get());
	}

	override function kill() {
		for (i in 1...4) new FlxTimer().start(i * 0.25).onComplete = t -> PLAYSTATE.explosions.fire({ position: FlxPoint.get(mx, my).add(10.get_random(-10), 10.get_random(-10)) });
		for (i in 0...2) new Decal(BANG, mx, my, 0.25, 360.get_random());
		CONSTRUCTION_MNGR.remove(this);
		super.kill();
	}

	function get_target() {
		var r = range * 16 + 8;
		var p = Vec2.get(mx, my);
		var mp = Vec2.get();

		// check current target
		if (target != null) {
			mp.set(target.mx, target.my);
			var target_ok = target.alive && p.distance(mp) <= r; // TODO: && raycast
			if (target_ok) {
				p.put();
				mp.put();
				return;
			}
			else target = null;
		}

		// check others
		var t:Monster = null;
		var ld:Float = range * 16 + 9;
		for (monster in MONSTERS.all) {
			mp.set(monster.mx, monster.my);
			var d = p.distance(mp);
			if (d > r) continue;
			if (d > ld) continue;
			// TODO: if (!raycast(this, monster)) continue;
			t = monster;
			ld = d;
		}
		if (t == null) return;
		target = t;
	}

}

enum SpecialProperty {
	EXPLOSIVE;
	KAMIKAZE;
}