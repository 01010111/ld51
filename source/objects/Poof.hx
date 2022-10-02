package objects;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Poof extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.poof__png, true, 16, 16);
		animation.add('play', [0,1,2,3,3,4,4,5,5,6,6,6,7,7,7,8,8,8], 24, false);
		add_component(new KillAfterAnimation());
		this.make_and_center_hitbox(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		angle = 4.get_random().floor() * 90;
		animation.play('play');
	}

}