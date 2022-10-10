package objects.constructions;

import zero.utilities.Vec2;

class Turret extends Construction {

	static var frame_count = 8;
	var aim_rot(default, set):Float;

	public function new(x:Int, y:Int) {
		super(x, y);
		loadGraphic(Images.turret__png, true, 16, 32);
		this.make_anchored_hitbox(16, 16);
		aim_rot = 180;

		range = 2;
		max_range = 4;

		power = 1;
		max_power = 3;

		rate = 1;
		max_rate = 3;

		allowed_special_properties = [
			EXPLOSIVE,
			KAMIKAZE,
		];
	}

	function set_aim_rot(v:Float) {
		var idx = (v + 360/frame_count/4).map(0, 360, 0, frame_count).cycle(0, frame_count).round();
		animation.frameIndex = idx;
		return aim_rot = v;
	}

	override function update(dt:Float) {
		super.update(dt);
		get_target();
		trigger(dt);
	}
	
	override function get_target() {
		super.get_target();
		if (target != null) {
			var p1 = Vec2.get(mx, my);
			var p2 = Vec2.get(target.mx, target.my);
			aim_rot = p1.angle_between(p2);
			p1.put();
			p2.put();
		}
	}

	var trigger_timer:Float = 0;
	function trigger(dt:Float) {
		if (target == null) return;
		if ((trigger_timer -= dt) >= 0) return;
		trigger_timer = 0.5/rate;
		fire();
	}

	function fire() {
		FlxG.camera.shake(0.001, 0.1);
		var bp = Vec2.get(mx, my);
		var bpo = Vec2.get(4, 0);
		bpo.angle = aim_rot;
		bp += bpo;
		bpo.put();
		PLAYSTATE.bullets.fire({
			position:FlxPoint.get(bp.x, bp.y),
			velocity: aim_rot.vector_from_angle(160).to_flxpoint(),
			data: { power: power },
		});
	}

}