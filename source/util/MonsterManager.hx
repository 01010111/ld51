package util;

import objects.Bombo;
import objects.BigSlime;
import zero.utilities.Vec2;
import flixel.util.FlxTimer;
import objects.Gremlin;
import objects.Monster;

class MonsterManager {
	
	var budget:Int = 20;
	var monsters:Array<Monster> = [];
	var waves:Int = 0;
	var begun:Bool = false;

	public var all(get, never):Array<Monster>;
	function get_all() return monsters;

	public function new() {
		monster_pile.shuffle();
	}

	public function begin () {
		if (begun) return;
		begun = true;
		new FlxTimer().start(3).onComplete = t -> spawn();
	}

	public function spawn() {
		get_monsters();
		waves++;
		if (waves % 2 == 0) budget++;

		new FlxTimer().start(16, t -> spawn());
	}

	function get_next_monster() {
		var m = monster_pile.shift();
		monster_pile.push(m);
		return m;
	}

	public function get_monsters_in_range(x:Float, y:Float, r:Float) {
		var out = [];
		var p = Vec2.get(x, y);
		var mp = Vec2.get();
		for (monster in monsters) {
			if (!monster.alive) continue;
			mp.set(monster.mx, monster.my);
			if (p.distance(mp) <= r) out.push(monster);
		}
		p.put();
		mp.put();
		return out;
	}

	function get_monsters() {
		var b = budget;
		var monsters = [];
		while (b > 0 && monsters.length < 10) {
			var m = get_next_monster();
			while (monster_cost[m.string()] > b) m = get_next_monster();
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

	public function refresh() {
		for (monster in monsters) if (monster.alive && monster.walking) monster.get_path();
	}

}

enum abstract MonsterType(Class<Monster>) {
	var GREMLIN = Gremlin;
	var SLIME = BigSlime;
	var BOMBO = Bombo;
}

private var monster_pile = [
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	GREMLIN,
	SLIME,
	SLIME,
	SLIME,
	SLIME,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
	BOMBO,
];

private var monster_cost:Map<String, Int> = [
	GREMLIN.string() => 1,
	SLIME.string() => 4,
	BOMBO.string() => 12,
];