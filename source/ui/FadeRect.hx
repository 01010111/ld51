package ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class FadeRect extends FlxSprite {
	
	public function new(fade:FadeType, time:Float, ?ease:Float -> Float, ?on_complete:Void -> Void) {
		super();
		if (ease == null) ease = FlxEase.linear;
		if (on_complete == null) on_complete = () -> {};
		makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		scrollFactor.set();
		alpha = switch fade {
			case INTRO:0;
			case OUTRO:1;
		}
		FlxTween.tween(this, { alpha: switch fade {
			case INTRO:1;
			case OUTRO:0;
		} }, time, { ease: ease, onComplete: t -> on_complete() });
	}

}

enum FadeType {
	INTRO;
	OUTRO;
}