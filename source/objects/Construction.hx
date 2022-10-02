package objects;

class Construction extends GameObject {

	public function new(x:Int, y:Int, mass:Bool = true) {
		super({
			x: GRID_OFFSET_X + x * GRID_SIZE,
			y: GRID_OFFSET_Y + y * GRID_SIZE,
		});
		CONSTRUCTION_MNGR.add(this, x, y, mass);
	}

	override function kill() {
		CONSTRUCTION_MNGR.remove(this);
		super.kill();
	}

}