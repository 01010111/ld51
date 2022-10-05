package fx;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Beam extends Particle {

	public function new() {
		super();
		makeGraphic(16, 258, 0x00FFFFFF);
		this.drawCircle(8, 250, 8);
		this.drawRect(0, 0, 16, 250);
		this.make_anchored_hitbox(0, 8);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		alpha = 1;
		this.flicker(0.5, 0.04, true, true, f -> kill());
		new FlxTimer().start(0.04, t -> color = [0xfffeb854, 0xffe8ea4a, 0xff58f5b1, 0xffcc68e4, 0xfffe626e].get_random(), (0.5/0.04).floor());
		FlxTween.tween(this, { alpha: 0 }, 0.5, { ease: FlxEase.expoIn });
	}

}