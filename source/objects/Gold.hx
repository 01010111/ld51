package objects;

import flixel.tweens.FlxTween;
import flixel.input.mouse.FlxMouseEvent;
import objects.Gadget;
import flixel.FlxSprite;

class Gold extends FlxSprite {

	var killed = false;

	public function new(x:Float, y:Float) {
		super(x, y, Images.gold__png);
		FlxMouseEvent.add(this, g -> send());
		PLAYSTATE.bg_ui_layer.add(this);
	}

	function send() {
		if (!Gadget.get(TELEPORTER).available) return;
		if (killed) return;
		PLAYSTATE.add(this);
		killed = true;
		FlxTween.quadMotion(this, x, y, x, y - 64, Gadget.get(TELEPORTER).mx-4, Gadget.get(TELEPORTER).my-4).onComplete = t -> {
			if (Gadget.get(TELEPORTER).alive) Gadget.get(TELEPORTER).util++;
			kill();
		};
	}

}