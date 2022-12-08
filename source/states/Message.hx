package states;

import ui.MessageText;
import ui.Button;
import ui.CommsSprite;
import flixel.FlxSubState;

class Message extends FlxSubState {
	
	var msg:String;

	public function new(msg:String) {
		super();
		this.msg = msg;
	}

	override function create() {
		new CommsSprite(this);
		new MessageText(msg, () -> add(new Button(384, 232, SURE, close)));
	}

}