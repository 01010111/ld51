package objects.constructions;

import flixel.util.FlxTimer;

class Proxy extends Construction {

	var proxy_timer:Float = 10;

	public function new(x:Int, y:Int) {
		super(x, y);
		loadGraphic(Images.proxy__png);
		this.make_anchored_hitbox(16, 16);

		range = 2;
		max_range = 4;

		power = 1;
		max_power = 3;

		rate = 1;
		max_rate = 3;
	}

	override function update(dt:Float) {
		super.update(dt);
		if ((proxy_timer -= dt) <= 0) {
			proxy_timer = 10;
			proxify();
		}
	}

	function proxify() {
		PLAYSTATE.stars.fire({ position: getMidpoint().add(0, -4)});
		var bldgs = [
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 0, gy - 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 0, gy + 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx - 1, gy + 0),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 1, gy + 0),
		];
		var i = 1;
		for (b in bldgs) {
			if (b == null) continue;
			if (b is Proxy) continue;
			if (b.range > 0) b.range = range.max(b.range).min(b.max_range).int();
			if (b.power > 0) b.power = power.max(b.power).min(b.max_power).int();
			if (b.rate > 0) b.rate = rate.max(b.rate).min(b.max_rate).int();
			new FlxTimer().start(i * 0.1).onComplete = t -> PLAYSTATE.stars.fire({ position: b.getMidpoint().add(0, -4)});
		}
	}

}