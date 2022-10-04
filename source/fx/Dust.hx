package fx;

import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Dust extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.dust__png, true, 8, 8);
		animation.add('play', [0,1,2,3,4,4,5,5,5], 16, false);
		this.make_and_center_hitbox(0,0);
		//add_component(new KillAfterAnimation());
		alpha = 0.75.get_random(0.5);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('play');
		new FlxTimer().start(0.6.get_random(0.5)).onComplete = t -> this.flicker(0.5, 0.04, true, true, f -> kill());
	}

	override function update(dt:Float) {
		super.update(dt);
		velocity.length *= 0.9;
	}

}