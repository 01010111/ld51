package fx;

import flixel.tweens.FlxTween;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class MeteorTrail extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.trail__png, true, 16, 16);
		animation.add('play', [
			0,1,2,3,
			4,4,5,5,6,6,7,7,
			8,8,8,9,9,9,10,10,10,11,11,11,
			12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,], 20.get_random(15).floor(), false);
		this.make_and_center_hitbox(0,0);
		add_component(new KillAfterAnimation());
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		angle = 4.get_random().floor() * 90;
		animation.play('play');
		scale.set(1,1);
		FlxTween.tween(scale, { x: 4, y: 4 }, 1);
		FlxTween.tween(this, { alpha: 0 }, 1);
		alpha = 1;
	}

	override function update(dt:Float) {
		super.update(dt);
	}

}