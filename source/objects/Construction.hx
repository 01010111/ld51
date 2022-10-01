package objects;

class Construction extends GameObject {

	public function new(x:Int, y:Int) {
		super({
			x: GRID_OFFSET_X + x * GRID_SIZE,
			y: GRID_OFFSET_Y + y * GRID_SIZE,
		});
	}

}