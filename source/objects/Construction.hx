package objects;

import zero.utilities.Vec2;

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
		CONSTRUCTION_MNGR.add(this, x, y, mass);
	}

	override function kill() {
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