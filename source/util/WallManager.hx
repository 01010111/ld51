package util;

import objects.constructions.Wall;

class WallManager {
	
	var wall_map:Array<Array<Int>> = [for (j in 0...GRID_HEIGHT) [for (i in 0...GRID_WIDTH) 0]];
	var wall_ids:Map<Int, Wall> = [];

	public function new() {}

	function get_id(x:Int, y:Int) {
		return y * 1000 + x;
	}

	function get_x_from_id(id:Int) {
		return id % 1000;
	}

	function get_y_from_id(id:Int) {
		return (id/1000).floor();
	}

	function refresh() {
		for (id => wall in wall_ids) set_index(wall, get_x_from_id(id), get_y_from_id(id));
	}

	function set_index(wall:Wall, x:Int, y:Int) {
		var index = 0;
		if (y > 0 && wall_map[y - 1][x] == 1) index += 1;
		if (y < GRID_HEIGHT - 2 && wall_map[y + 1][x] == 1) index += 2;
		if (x > 0 && wall_map[y][x - 1] == 1) index += 4;
		if (x < GRID_WIDTH - 2 && wall_map[y][x + 1] == 1) index += 8;
		wall.animation.frameIndex = index;
	}

	public function add(wall:Wall, x:Int, y:Int) {
		wall_map[y][x] = 1;
		wall_ids.set(get_id(x, y), wall);
		refresh();
	}

	public function remove(wall:Wall) {
		for (id => wl in wall_ids) if (wl == wall) {
			wall_ids.remove(id);
			wall_map[get_y_from_id(id)][get_x_from_id(id)] = 0;
			refresh();
			return;
		}
	}

}