package objects;

import flixel.util.FlxTimer;
import fx.Decal;
import zero.utilities.Vec2;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Meteor extends FlxSprite {
	
	public function new(x1:Float, y1:Float, x2:Float, y2:Float, tx:Int, ty:Int) {
		super(x1, y1, Images.meteor__png);
		this.make_and_center_hitbox(0,0);
		FlxTween.tween(this, { x:x2, y:y2 }, 0.5).onComplete = t -> {
			var c = CONSTRUCTION_MNGR.get_obj_at_coord(tx, ty);
			if (c != null) {
				CONSTRUCTION_MNGR.remove(c);
				c.kill();
			}
			kill();
		}
		PLAYSTATE.foreground_layer.add(this);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		for (i in 0...3) fire_trail();
	}

	function fire_trail() {
		var v = Vec2.get(x, y);
		var o = Vec2.get(10.get_random(), 0);
		o.angle = 360.get_random();
		v += o;
		var trail = PLAYSTATE.trails.fire({ position: FlxPoint.get(v.x, v.y) });
		PLAYSTATE.trails.sort((i, o1, o2) -> o1 == trail ? -1 : o2 == trail ? 1 : 0);
		v.put();
		o.put();
	}

	override function kill() {
		var dust_num = 16;
		for (i in 0...dust_num) {
			PLAYSTATE.dust.fire({
				position: FlxPoint.get(x, y),
				velocity: (i * 360/dust_num + 15.get_random_gaussian(-15)).vector_from_angle(480.get_random(320)).to_flxpoint(),
			});
		}
		PLAYSTATE.explosions.fire({ position: FlxPoint.get(x,y) });
		new Decal(CRATER, x, y);
		for (monster in MONSTERS.get_monsters_in_range(x, y, 24)) monster.kill();
		new Gold(x - 6, y - 6);
		super.kill();
		PLAYSTATE.flash(0.2, 0.8);
		FlxG.camera.shake(0.02, 0.5);
	}

}