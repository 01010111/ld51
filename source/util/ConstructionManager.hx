package util;

import objects.Construction;

using zero.utilities.AStar;

class ConstructionManager {

	var vacancies:Array<Array<Int>> = [for (j in 0...GRID_HEIGHT) [for (i in 0...GRID_WIDTH) 0]];
	var objects_by_id:Map<Int,Construction> = [];

	public function new() {
		for (j in 0...2) for (i in 0...2) vacancies[j + (GRID_HEIGHT/2).floor()][i + (GRID_WIDTH/2).floor()] = 1;
	}

	var temp_map:Array<Array<Int>> = [for (j in 0...(FlxG.height/GRID_SIZE).floor()) [for (i in 0...(FlxG.width/GRID_SIZE).floor()) 0]];
	public function path(wx_s:Int, wy_s:Int, wx_e:Int, wy_e:Int) {
		for (j in 0...vacancies.length) for (i in 0...vacancies[0].length) temp_map[j + (GRID_OFFSET_Y/16).floor()][i + (GRID_OFFSET_X/16).floor()] = vacancies[j][i];
		var path = temp_map.get_path({
			start: [wx_s,wy_s],
			end: [wx_e, wy_e],
			passable: [0]
		});
		return path;
	}

	public function can_place(x:Int, y:Int) {
		if (!is_vacant(x, y)) return false;
		if (path(0, 0, (GRID_OFFSET_X/16 + GRID_WIDTH/2).floor(), (GRID_OFFSET_Y/16 + GRID_HEIGHT/2).floor()).length == 0) return false;
		return true;
	}

	public function is_vacant(x:Int, y:Int) return vacancies[y][x] == 0;

	function get_id(x:Int, y:Int) {
		return y * 1000 + x;
	}

	function get_x_from_id(id:Int) {
		return id % 1000;
	}

	function get_y_from_id(id:Int) {
		return (id/1000).floor();
	}

	public function add(object:Construction, x:Int, y:Int, mass:Bool) {
		if (!is_vacant(x, y)) return false;
		objects_by_id.set(get_id(x, y), object);
		if (mass) vacancies[y][x] = 1;
		return true;
	}

	public function get_obj_at_coord(x:Int, y:Int) {
		if (!objects_by_id.exists(get_id(x, y))) return null;
		return objects_by_id[get_id(x, y)];
	}

	public function remove(object:Construction) {
		for (id => obj in objects_by_id) if (obj == object) {
			objects_by_id.remove(id);
			vacancies[get_y_from_id(id)][get_x_from_id(id)] = 0;
			return true;
		}
		return false;
	}

	public function remove_by_coord(x:Int, y:Int) {
		if (!objects_by_id.exists(get_id(x, y))) return false;
		objects_by_id.remove(get_id(x, y));
		vacancies[y][x] = 0;
		return true;
	}

}