package fx;

import flixel.FlxSprite;

class Decal extends FlxSprite {
	
	public function new(sticker:Sticker, x:Float, y:Float, alpha:Float = 1, angle:Float = 0) {
		super(x, y);
		this.alpha = alpha;
		this.angle = angle;
		loadGraphic(Images.decals__png, true, 48, 48);
		animation.frameIndex = cast sticker;
		this.make_and_center_hitbox(0, 0);
		active = false;
		switch sticker {
			case CRATER: PLAYSTATE.decals_a.add(this);
			default: PLAYSTATE.decals_b.add(this);
		}
		blend = switch sticker {
			case CRATER:NORMAL;
			case BANG:MULTIPLY;
			case BLOOD_1:MULTIPLY;
			case BLOOD_2:MULTIPLY;
		}
	}

}

enum abstract Sticker(Int) {
	var CRATER = 0;
	var BANG = 1;
	var BLOOD_1 = 2;
	var BLOOD_2 = 3;
}