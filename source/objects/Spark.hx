package objects;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.components.KillAfterAnimation;
import zero.flixel.ec.ParticleEmitter.Particle;

class Spark extends Particle {
	
	public function new() {
		super();
		loadGraphic(Images.spark__png, true, 8, 8);
		animation.add('play', [0,1,2,3], 30, false);
		add_component(new KillAfterAnimation());
		this.make_and_center_hitbox(0,0);
		blend = ADD;
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		animation.play('play');
	}

}