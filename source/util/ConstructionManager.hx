package util;

import objects.Construction;

class ConstructionManager {

	var vacancies:Array<Array<Int>> = [for (j in 0...GRID_HEIGHT) [for (i in 0...GRID_WIDTH) 0]];
	var objects_by_id:Map<Int,Construction> = [];

	public function new() {
		for (j in 0...2) for (i in 0...2) vacancies[j + (GRID_HEIGHT/2).floor()][i + (GRID_WIDTH/2).floor()] = 1;
	}

	public function is_vacant(x:Int, y:Int) return vacancies[y][x] == 0;

	function get_id(x:Int, y:Int) {
		return y * 1000 + x;
	}

	public function add(object:Construction, x:Int, y:Int) {
		if (!is_vacant(x, y)) return false;
		objects_by_id.set(get_id(x, y), object);
		vacancies[y][x] = 1;
		return true;
	}

	public function get_obj_at_coord(x:Int, y:Int) {
		if (!objects_by_id.exists(get_id(x, y))) return null;
		return objects_by_id[get_id(x, y)];
	}

	public function remove_by_coord(x:Int, y:Int) {
		if (!objects_by_id.exists(get_id(x, y))) return false;
		objects_by_id.remove(get_id(x, y));
		vacancies[y][x] = 0;
		return true;
	}

}