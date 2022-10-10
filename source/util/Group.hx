package util;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class Group extends FlxTypedGroup<FlxObject> {
	
	public var x:Float = 0;
	public var y:Float = 0;

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

}