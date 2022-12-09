package ui;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;

class Button extends FlxSprite {
	
	var text:ButtonText;
	var over(default, set):Bool;

	public function new(x:Float, y:Float, text:ButtonText, on_click:Void -> Void) {
		super(x, y);
		loadGraphic(Images.buttons__png, true, 64 * 4, 24 * 4);
		this.text = text;
		over = false;
		origin.set(0,0);
		scale.set(0.25, 0.25);
		setSize(64, 24);

		FlxMouseEvent.add(this, b -> on_click(), null, b -> over = true, b -> over = false, false, true, false);
	}

	function set_over(v) {
		animation.frameIndex = switch text {
			case GOT_IT:v ? 1 : 0;
			case SURE:v ? 3 : 2;
			case LETS_GO:v ? 5 : 4;
		}
		return over = v;
	}

}

enum ButtonText {
	GOT_IT;
	SURE;
	LETS_GO;
}