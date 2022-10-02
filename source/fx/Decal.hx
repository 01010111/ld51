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
		PLAYSTATE.tile_layer.add(this);
	}

}

enum abstract Sticker(Int) {
	var CRATER = 0;
	var BANG = 1;
	var BLOOD_1 = 2;
	var BLOOD_2 = 3;
}