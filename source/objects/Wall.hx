package objects;

class Wall extends Construction {

	public function new(x:Int, y:Int) {
		super(x, y);

		loadGraphic(Images.fences__png, true, 16, 32);
		this.make_anchored_hitbox(16, 16);

		WALL_MNGR.add(this, x, y);
		PLAYSTATE.walls.add(this);
	}

	override function kill() {
		WALL_MNGR.remove(this);
		super.kill();
	}

}