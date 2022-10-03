package fx;

import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Explosion extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.explosion__png, true, 64, 64);
		animation.add('play', [0,1,2,3,3,4,4,5,5,6,6,7,7,8,8,8], 20, false);
		this.make_and_center_hitbox(0,0);
		add_component(new KillAfterAnimation());
	}

	override function fire(options) {
		super.fire(options);
		angle = 4.get_random().floor() * 90;
		animation.play('play');
	}

}