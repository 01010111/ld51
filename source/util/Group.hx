package util;

import haxe.ds.Either;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class Group extends FlxTypedGroup<FlxObject> {
	
	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;

	override function update(elapsed:Float) {
		for (o in members) {
			o.x += x;
			o.y += y;
		}
		super.update(elapsed);
		for (o in members) {
			o.x -= x;
			o.y -= y;
		}
	}

	override function draw() {
		for (o in members) {
			o.x += x;
			o.y += y;
		}
		super.draw();
		for (o in members) {
			o.x -= x;
			o.y -= y;
		}
	}

	public function add_group(g:Group) {
		add(cast g);
	}

	function set_x(v) return x = v;
	function set_y(v) return y = v;

}