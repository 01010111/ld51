package fx;

import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Spotlight extends Particle {

	var t = 0.0;

	public function new() {
		super();
		loadGraphic(Images.spotlight__png);
		this.make_and_center_hitbox(0,0);
		alpha = 0.5;
		blend = MULTIPLY;
	}

	override function fire(options:FireOptions) {
		t = options.util_int != null ? options.util_amount : 0.01;
		super.fire(options);
	}

	override function update(dt:Float) {
		super.update(dt);
		if ((t -= dt) <= 0) kill();
	}

}