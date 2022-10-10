package objects.monsters;

import zero.utilities.IntPoint;
import flixel.util.FlxTimer;

class BigSlime extends Monster {
	
	public function new(side, y) {
		super(side, y);
		loadGraphic(Images.big_slime__png, true, 16, 32);
		setSize(8,8);
		offset.set(4, 20);
		this.set_facing_flip_horizontal();
		animation.add('walk', [0,1,2,1], 12);
		animation.add('attack', [3,4,5,6,7,6,5,4], 20);

		speed = 40;
		health = 12;
		hit_frame = 6;
		power = 3;
	}

	override function update(dt:Float) {
		super.update(dt);
		if (velocity.length == 0) animation.play('attack');
		else animation.play('walk');
		if (velocity.x != 0) facing = velocity.x < 0 ? LEFT : RIGHT;
	}

	var sx = [-1,0,1].shuffle();
	var sy = [-1,0,1].shuffle();

	override function kill() {
		var sel = [];
		for (j in -1...2) for (i in -1...2) {
			if (CONSTRUCTION_MNGR.get_obj_at_coord(gx + i, gy + j) == null) sel.push(IntPoint.get(gx + i, gy + j));
		}
		sel.shuffle();
		for (i in 0...3) {
			var p = sel.shift();
			if (p != null) new LittleSlime(
				p.x * GRID_SIZE + GRID_OFFSET_X + 5, 
				p.y * GRID_SIZE + GRID_OFFSET_Y + 5
			);
		}
		super.kill();
	}

}