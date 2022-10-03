package util;

import zero.utilities.Vec2;
import zero.utilities.IntPoint;
import objects.Meteor;
import flixel.util.FlxTimer;

class MeteorManager {
	
	public function new() {
		new FlxTimer().start(3).onComplete = t -> fire();
	}

	function fire() {
		var tx = GRID_WIDTH.get_random().floor();
		var ty = GRID_HEIGHT.get_random().floor();
		warn(3, tx, ty);
		new FlxTimer().start(2).onComplete = t -> {
			Math.random() > 0.5 ? tx += [-1,0,1].get_random() : ty += [-1,0,1].get_random();
			tx = tx.clamp(0, GRID_WIDTH).floor();
			ty = ty.clamp(0, GRID_HEIGHT).floor();
			warn(2, tx, ty);
			new FlxTimer().start(2).onComplete = t -> {
				Math.random() > 0.5 ? tx += [-1,0,1].get_random() : ty += [-1,0,1].get_random();
				tx = tx.clamp(0, GRID_WIDTH).floor();
				ty = ty.clamp(0, GRID_HEIGHT).floor();
				warn(1, tx, ty);
				new FlxTimer().start(2).onComplete = t -> {
					Math.random() > 0.5 ? tx += [-1,0,1].get_random() : ty += [-1,0,1].get_random();
					tx = tx.clamp(0, GRID_WIDTH).floor();
					ty = ty.clamp(0, GRID_HEIGHT).floor();
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
		new FlxTimer().start(14.get_random_gaussian(6), t -> fire());
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