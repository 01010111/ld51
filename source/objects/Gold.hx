package objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.mouse.FlxMouseEvent;
import objects.Gadget;
import flixel.FlxSprite;

class Gold extends FlxSprite {

	var killed = false;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(Images.gold__png, true, 12, 12);
		animation.frameIndex = 0;
		FlxMouseEvent.add(this, g -> send());
		PLAYSTATE.bg_ui_layer.add(this);
	}
	
	function send() {
		if (!Gadget.get(TELEPORTER).available) return;
		if (killed) return;
		animation.frameIndex = 1;
		PLAYSTATE.add(this);
		killed = true;
		for (i in 0...3) PLAYSTATE.nuggets.fire({ position: FlxPoint.get(x + 6, y + 6), util_amount: 360/3 * i + 45.get_random(-45) });
		PLAYSTATE.stars.fire({ position: FlxPoint.get(x + 6, y + 6) });
		FlxTween.cubicMotion(this, x, y, x, y - 80, Gadget.get(TELEPORTER).mx-4, Gadget.get(TELEPORTER).my-80, Gadget.get(TELEPORTER).mx-4, Gadget.get(TELEPORTER).my-4, 0.75).onComplete = t -> {
			PLAYSTATE.stars.fire({ position: FlxPoint.get(Gadget.get(TELEPORTER).mx, Gadget.get(TELEPORTER).my), velocity: FlxPoint.get(0, -10) });
			if (Gadget.get(TELEPORTER).alive) Gadget.get(TELEPORTER).util++;
			kill();
		};
	}

}