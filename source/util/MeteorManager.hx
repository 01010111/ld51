package util;

import zero.utilities.Vec2;
import zero.utilities.IntPoint;
import objects.Meteor;
import flixel.util.FlxTimer;

class MeteorManager {
	
	var tx:Int;
	var ty:Int;
	var do_continue:Bool = false;
	var count:Int = 0;

	public function new() {
		new FlxTimer().start(3).onComplete = t -> {
			fire();
			new FlxTimer().start(10, t -> fire(), 2);
		}
	}

	function adjust() {
		Math.random() > 0.5 ? tx += [-1,-1,0,1,1].get_random() : ty += [-1,-1,0,1,1].get_random();
		tx = tx.clamp(0, GRID_WIDTH - 1).floor();
		ty = ty.clamp(0, GRID_HEIGHT - 1).floor();
		check_center();
	}

	function check_center() {
		if (tx == (GRID_WIDTH/2).floor() - 1 && ty == (GRID_HEIGHT/2).floor() - 1) Math.random() > 0.5 ? tx-- : ty--;
		if (tx == (GRID_WIDTH/2).floor() && ty == (GRID_HEIGHT/2).floor() - 1) Math.random() > 0.5 ? tx++ : ty--;
		if (tx == (GRID_WIDTH/2).floor() - 1 && ty == (GRID_HEIGHT/2).floor()) Math.random() > 0.5 ? tx-- : ty++;
		if (tx == (GRID_WIDTH/2).floor() && ty == (GRID_HEIGHT/2).floor()) Math.random() > 0.5 ? tx++ : ty++;
	}

	public function continue_firing() {
		if (do_continue) return;
		do_continue = true;
		new FlxTimer().start(2).onComplete = t -> fire();
	}

	function fire() {
		count++;
		tx = GRID_WIDTH.get_random().floor();
		ty = GRID_HEIGHT.get_random().floor();	
		adjust();
		warn(3, tx, ty);
		new FlxTimer().start(2).onComplete = t -> {
			adjust();
			warn(2, tx, ty);
			new FlxTimer().start(2).onComplete = t -> {
				adjust();
				warn(1, tx, ty);
				new FlxTimer().start(2).onComplete = t -> {
					adjust();
					warn(0, tx, ty);
					new FlxTimer().start(2).onComplete = t -> new Meteor(
						GRID_OFFSET_X + tx * GRID_SIZE + GRID_SIZE/2 + FlxG.width.get_random_gaussian(-FlxG.width),
						GRID_OFFSET_Y + ty * GRID_SIZE + GRID_SIZE/2 - FlxG.height,
						GRID_OFFSET_X + tx * GRID_SIZE + GRID_SIZE/2,
						GRID_OFFSET_Y + ty * GRID_SIZE + GRID_SIZE/2,
						tx, ty
					);
				}
			}
		}
		if (do_continue) new FlxTimer().start(11.get_random_gaussian(9), t -> fire());
	}

	function warn(r:Int,x:Int,y:Int) {
		PLAYSTATE.warn_ind.fire({ 
			position: FlxPoint.get(
				x * GRID_SIZE + GRID_SIZE/2 + GRID_OFFSET_X,
				y * GRID_SIZE + GRID_SIZE/2 + GRID_OFFSET_Y
			),
			util_int: r
		});
	}

}