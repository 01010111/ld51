package objects.monsters;

import haxe.Timer;
import zero.utilities.Vec2;
import flixel.util.FlxTimer;
import objects.constructions.Gadget;

class Bombo extends Monster {

	public function new(side, y) {
		super(side, y);
		loadGraphic(Images.bombo__png, true, 48, 48);
		this.make_and_center_hitbox(8,8);
		this.set_facing_flip_horizontal();
		animation.add('walk', [12,12,13,14,15,15,16,17], 8);
		animation.add('attack', [0,1,2,3,4,5,6,7,8,9,10,11], 24);

		speed = 30;
		health = 24;
	}

	override function update(dt:Float) {
		super.update(dt);
		if (velocity.length == 0) animation.play('attack');
		else animation.play('walk');
		if (velocity.x != 0) facing = velocity.x < 0 ? LEFT : RIGHT;
	}

	var dead = false;
	override function kill() {
		if (dead) return;
		dead = true;
		PLAYSTATE.add(this);
		PLAYSTATE.spotlights.fire({ position: getMidpoint().add(0, -4), util_amount: 0.01 });
		PLAYSTATE.hitstop(250);
		new FlxTimer().start(0.01, t -> really_kill());
	}

	function really_kill() {
		PLAYSTATE.flash(0.02, 1);
		for (i in 0...8) new FlxTimer().start(i * 0.1).onComplete = t -> {
			var v = Vec2.get(i * 3);
			v.angle = 360.get_random();
			PLAYSTATE.flash(0.02, 0.5);
			PLAYSTATE.explosions.fire({ position: FlxPoint.get(mx + v.x, my + v.y) });
			for (i in 0...6) PLAYSTATE.dust.fire({ position: FlxPoint.get(mx + v.x, my + v.y), velocity: (i*360/6).vector_from_angle(400.get_random(300)).to_flxpoint() });
			v.put();
		}
		var bldgs = [
			CONSTRUCTION_MNGR.get_obj_at_coord(gx - 1, gy - 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 0, gy - 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 1, gy - 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx - 1, gy + 0),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 0, gy + 0),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 1, gy + 0),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx - 1, gy + 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 0, gy + 1),
			CONSTRUCTION_MNGR.get_obj_at_coord(gx + 1, gy + 1),
		].shuffle();
		var i = 5;
		for (bldg in bldgs) new FlxTimer().start(i * 0.1).onComplete = t -> {
			if (bldg == null) return;
			if (bldg is Gadget) bldg.hurt(20);
			else bldg.kill();
			i++;
		}
		for (m in MONSTERS.get_monsters_in_range(mx, my, 24)) m.kill();

		super.kill();
	}

}