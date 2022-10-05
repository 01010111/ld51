package fx;

import flixel.tweens.FlxTween;
import zero.utilities.Vec2;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Nugget extends Particle {

	public function new() {
		super();
		loadGraphic(Images.gold__png, true, 12, 12);
		this.make_and_center_hitbox(0, 0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.frameIndex = Math.random() > 0.5 ? 2 : 3;
		var v = Vec2.get(32.get_random(16));
		v.angle = options.util_amount != null ? options.util_amount : 360.get_random();
		var a = 32.get_random(16);
		this.flicker(0.6, 0.04, true, true, f -> kill());
		FlxTween.cubicMotion(this, x, y, x, y - a, x + v.x, y + v.y - a, x + v.x, y + v.y, 0.6.get_random(0.3)).onComplete = t -> {
			velocity.set(v.x, v.y - 10);
			v.put();
		}
	}
	
}