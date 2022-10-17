package objects.monsters;

import objects.monsters.Monster.EntrySide;
import flixel.util.FlxTimer;

class LittleSlime extends Monster {
	
	public function new(x, y) {
		super(LEFT, y);
		loadGraphic(Images.little_slime__png, true, 16, 32);
		setSize(8,8);
		offset.set(4, 20);
		this.set_facing_flip_horizontal();
		animation.add('walk', [0,1], 12);
		animation.add('attack', [0,1,2,3,4,5,6], 20);
		
		setPosition(x, y);
		new FlxTimer().start(0, t -> get_path());

		PLAYSTATE.poofs.fire({ position: FlxPoint.get(mx, my) });

		speed = 40;
		health = 5;
		hit_frame = 6;
		power = 1;
	}

	override function start(side:EntrySide, y:Float) {}

	override function update(dt:Float) {
		super.update(dt);
		if (velocity.length == 0) animation.play('attack');
		else animation.play('walk');
		if (velocity.x != 0) facing = velocity.x < 0 ? LEFT : RIGHT;
	}

}