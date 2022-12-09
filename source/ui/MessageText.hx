package ui;

import flixel.text.FlxText;

class MessageText extends FlxText {

	var msg:String;
	var callback:Void -> Void;

	public function new(msg:String, callback:Void -> Void) {
		super(-128, 64, 256 * 4, '');
		setFormat('IBM Plex Mono Bold', 9 * 4, 0xFFFFFF, LEFT);
		scale.set(0.25, 0.25);
		scrollFactor.set(0,0);
		
		// todo - animate this:
		text = msg;
		callback();
		trace(msg);
	}

}