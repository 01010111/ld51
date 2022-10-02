package objects;

class Wall extends Construction {

	public function new(x:Int, y:Int) {
		super(x, y);

		loadGraphic(Images.walls__png, true, 16, 16);

		WALL_MNGR.add(this, x, y);
	}

}