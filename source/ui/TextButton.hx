package ui;

import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;

class TextButton extends FlxText {

	var ox:Float = 0;

	public function new(x:Float, y:Float, text:String, on_click:Void -> Void) {
		super(x, y, 128*4, text, 16*4);
		setFormat('Intro Demo Black CAPS', 16*4);
		FlxMouseEvent.add(this, t -> on_click(), null, t -> on_over(), t -> on_out(), false, true, false);
		origin.set(0, 0);
		setSize(128, 16);
		scale.set(0.25, 0.25);
	}

	function on_over() {
		ox = -8;
	}

	function on_out() {
		ox = 0;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		offset.x += (ox - offset.x) * 0.25;
	}

}