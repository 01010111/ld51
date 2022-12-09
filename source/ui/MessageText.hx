package ui;

import flixel.text.FlxText;

class MessageText extends FlxText {

	var msg:Array<String>;
	var om:String;
	var callback:Void -> Void;
	var zoom:Float = 4;
	var timer:Float = 0.1;
	var done:Bool = false;

	public function new(msg:String, callback:Void -> Void) {
		super(-256, 64, 256 * zoom, '');
		setFormat('IBM Plex Mono Bold', (9 * zoom).round(), 0xFFFFFF, LEFT);
		scale.set(1/zoom, 1/zoom);
		scrollFactor.set(0,0);
		this.msg = msg.split('');
		om = msg;
		this.callback = callback;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.mouse.justPressed) finish();
		if (done) return;
		if ((timer -= elapsed) > 0) return;
		text += msg.shift();
		if (msg.length > 0) return;
		finish();
	}

	function finish() {
		if (done) return;
		done = true;
		text = om;
		callback();
	}

}