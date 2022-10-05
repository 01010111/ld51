package objects;

class Wall extends Construction {

	public function new(x:Int, y:Int) {
		super(x, y);

		loadGraphic(Images.fences__png, true, 16, 32);
		//this.make_anchored_hitbox(16, 16);
		animation.callback = anim_callback;

		WALL_MNGR.add(this, x, y);
		PLAYSTATE.walls.add(this);

	}

	function anim_callback(n:String, i:Int, f:Int) {
		var up = i & 1 > 0;
		var down = i & 2 > 0;
		var left = i & 4 > 0;
		var right = i & 8 > 0;

		setSize(left && right ? 16 : left || right ? 12 : 8, up && down ? 16 : up || down ? 12 : 8);
		offset.set(left ? 0 : 4, up ? 16 : 20);
		setPosition(x.snap_to_grid(16, offset.x, true), y.snap_to_grid(16, offset.y - 16, true));
	}

	override function kill() {
		WALL_MNGR.remove(this);
		super.kill();
	}

}