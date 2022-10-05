package objects;

import objects.Monster.EntrySide;
import flixel.util.FlxTimer;

class LittleSlime extends Monster {
	
	public function new(x, y) {
		super(LEFT, y);
		loadGraphic(Images.little_slime__png, true, 16, 32);
		setSize(6, 6);
		offset.set(5, 21);
		this.set_facing_flip_horizontal();
		animation.add('walk', [0,1], 12);
		animation.add('attack', [0,1,2,3,4,5,6], 20);
		
		setPosition(x, y);
		new FlxTimer().start(0, t -> get_path());

		PLAYSTATE.poofs.fire({ position: FlxPoint.get(mx, my) });

		speed = 40;
		health = 2;
	}

	override function start(side:EntrySide, y:Float) {}

	override function update(dt:Float) {
		super.update(dt);
		if (velocity.length == 0) animation.play('attack');
		else animation.play('walk');
		if (velocity.x != 0) facing = velocity.x < 0 ? LEFT : RIGHT;
	}

}