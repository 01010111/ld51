package objects;

import flixel.util.FlxTimer;

class BigSlime extends Monster {
	
	public function new(side, y) {
		super(side, y);
		loadGraphic(Images.big_slime__png, true, 16, 32);
		setSize(6, 6);
		offset.set(5, 21);
		this.set_facing_flip_horizontal();
		animation.add('walk', [0,1,2,1], 12);
		animation.add('attack', [3,4,5,6,7,6,5,4], 20);

		speed = 40;
		health = 5;
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
		for (i in 0...2) {
			var ix = 0;
			while (ix < 3 && CONSTRUCTION_MNGR.get_obj_at_coord(gx + sx[0], gy + sy[0]) != null) {
				sx.push(sx.shift());
				sy.push(sy.shift());
				ix++;
			}
			if (ix == 3) continue;
			sx.push(sx.shift());
			sy.push(sy.shift());
			new FlxTimer().start(i * 0.1).onComplete = t -> new LittleSlime((x + sx[0]*16).snap_to_grid(16, 5), (y + sy[0]*16).snap_to_grid(16, 5));
		}
		super.kill();
	}

}