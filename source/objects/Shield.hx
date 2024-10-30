package objects;

import objects.constructions.Gadget;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.constructions.Construction;

class Shield extends GameObject {

	static var pool:Array<Shield> = [];

	public static function get() {
		for (shield in pool) {
			if (!shield.alive) return shield;
		}
		return new Shield();
	}

	public function new() {
		super();
		loadGraphic(Images.shield__png, true, 32, 32);
		this.make_and_center_hitbox(0, 0);
		animation.add('play', [0,1,2,3]);
		blend = SCREEN;
		alpha = 0.75;
		PLAYSTATE.object_layer.add(this);
		pool.push(this);
		exists = alive = false;
	}

	public function set(x:Float, y:Float, c:Construction) {
		reset(x, y + (c is Gadget ? 8 : 0));
		scale.set(0, 0);
		FlxTween.tween(scale, { x: 1, y: 1 }, 0.25, { ease: FlxEase.backOut });
		angle = 90 * 4.get_random().floor();
		animation.play('play');
		return this;
	}

	function superkill() {
		super.kill();
	}

	override function kill() {
		FlxTween.tween(scale, { x: 2, y: 2 }, 0.1);
		FlxTween.tween(this, { alpha: 0 }, 0.1).onComplete = _ -> superkill();
	}

}