package ui;

import flixel.text.FlxText;

class MessageText extends FlxText {

	var msg:String;
	var callback:Void -> Void;

	public function new(msg:String, callback:Void -> Void) {
		super(128, 64, 256, '');
		setFormat('IBM Plex Mono Bold', 9 * 4);
		
		// todo - animate this:
		text = msg;
		callback();
	}

}