package fx;

import objects.constructions.Gadget;
import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class WarningIndicator extends Particle {

	public function new() {
		super();
		loadGraphic(Images.warning_indicator__png, true, 144 * 4, 144 * 4);
		this.make_and_center_hitbox(0,0);
		scale.set(0.25, 0.25);
		blend = ADD;
		alpha = 0.75;
	}

	override function fire(options:FireOptions) {
		if (!Gadget.get(RADAR).alive) return;
		super.fire(options);
		animation.frameIndex = options.util_int;
		this.flicker(0.2);
		new FlxTimer().start(0.5, t -> this.flicker(0.2, 0.04, true, true, f -> kill()));
	}

}