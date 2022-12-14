package objects.monsters;

class Gremlin extends Monster {
	
	public function new(side, y) {
		super(side, y);
		loadGraphic(Images.gremlin__png, true, 32, 32);
		this.make_and_center_hitbox(8,8);
		this.set_facing_flip_horizontal();
		animation.add('walk', [0,0,1,2,3,3,4,5], 12);
		animation.add('attack', [6,6,7,8,9,9,10,11], 40);

		speed = 60;
		health = 3;
		hit_frame = 8;
		power = 2;
	}

	override function update(dt:Float) {
		super.update(dt);
		if (velocity.length == 0) animation.play('attack');
		else animation.play('walk');
		if (velocity.x != 0) facing = velocity.x < 0 ? LEFT : RIGHT;
	}

}