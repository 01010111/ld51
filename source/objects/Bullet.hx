package objects;

import zero.flixel.ec.components.KillAfterTimer;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;

class Bullet extends Projectile {

	var timer:KillAfterTimer;
	
	public function new() {
		super();
		loadGraphic(Images.bullet__png, true, 24, 24);
		animation.add('play', [0,1,2,3]);
		offset.set(11, 16);
		setSize(2, 2);
		blend = OVERLAY;
		PLAYSTATE.projectiles.add(this);
		add_component(timer = new KillAfterTimer());
	}

	override function fire(options:FireOptions) {
		PLAYSTATE.poofs.fire({ position: options.position.copyTo().add(0, -6) });
		options.position.add(-1,-1);
		super.fire(options);
		animation.play('play');
		power = options.data.power;
		timer.reset(2);
	}

	override function kill() {
		PLAYSTATE.sparks.fire({ position: FlxPoint.get(x + 1, y - 6) });
		super.kill();
	}

}