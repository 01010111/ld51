package fx;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Star extends Particle {

	var i = 0;
	
	public function new() {
		super();
		loadGraphic(Images.squares__png, true, 32, 32);
		blend = ADD;
		this.make_and_center_hitbox(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		alpha = 1;
		this.flicker(0.5, 0.04, true, true, f -> kill());
		new FlxTimer().start(0.08, t -> {
			color = [0xfffeb854, 0xffe8ea4a, 0xff58f5b1, 0xffcc68e4, 0xfffe626e].get_random();
			animation.frameIndex = i++ % 4;
		}, (0.5/0.08).floor());
		FlxTween.tween(this, { alpha: 0 }, 0.5, { ease: FlxEase.expoIn });
	}

}