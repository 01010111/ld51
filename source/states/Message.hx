package states;

import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxTimer;
import ui.MessageText;
import ui.Button;
import ui.CommsSprite;
import flixel.FlxSubState;

class Message extends FlxSubState {
	
	var msg:String;
	var btn:Button;

	public function new(msg:String) {
		super();
		this.msg = msg;
	}

	override function create() {
		bgColor = 0xDE000000;
		new CommsSprite(this);
		add(new MessageText(msg, () -> add(btn = new Button(384, 232, SURE, () -> {
			new FlxTimer().start(0.1, t -> {
				FlxMouseEvent.remove(btn);
				close();
			});
		}))));
	}

}