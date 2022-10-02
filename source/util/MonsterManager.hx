package util;

import objects.Gremlin;
import objects.Monster;

class MonsterManager {
	
	var budget:Int = 3;
	var monsters:Array<Monster> = [];
	var waves:Int = 0;

	public var all(get, never):Array<Monster>;
	function get_all() return monsters;

	public function new() {}

	public function spawn() {
		get_monsters();
		waves++;
		if (waves % 2 == 0) budget++;
	}

	function get_monsters() {
		var b = budget;
		var monsters = [];
		while (b > 0) {
			var m = monster_pile.get_random();
			while (monster_cost[m.string()] > b) m = monster_pile.get_random();
			monsters.push(m);
			b -= monster_cost[m.string()];
		}
		var split = monsters.length > 3;
		var def_side:EntrySide = Math.random() > 0.5 ? LEFT : RIGHT;
		var left = [];
		var right = [];
		for (monster in monsters) {
			if (split) [left, right].get_random().push(monster);
			else switch def_side {
				case LEFT: left.push(monster);
				case RIGHT: right.push(monster);
			}
		}
		var y = FlxG.height/2 - left.length * 12;
		for (monster in left) {
			Type.createInstance(cast monster, [LEFT, y]);
			y += 24;
		}
		y = FlxG.height/2 - right.length * 12;
		for (monster in right) {
			Type.createInstance(cast monster, [RIGHT, y]);
			y += 24;
		}
	}

	public function add(monster:Monster) {
		monsters.push(monster);
	}

	public function remove(monster:Monster) {
		monsters.remove(monster);
	}

}

enum abstract MonsterType(Class<Monster>) {
	var GREMLIN = Gremlin;
}

private var monster_pile = [
	GREMLIN,
];

private var monster_cost:Map<String, Int> = [
	'GREMLIN' => 1,
];