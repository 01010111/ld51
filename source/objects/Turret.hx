package objects;

class Turret extends Construction {

	static var frame_count = 8;
	var aim_rot(default, set):Float;

	public function new(x:Int, y:Int) {
		super(x, y);
		loadGraphic(Images.turret__png, true, 16, 32);
		this.make_anchored_hitbox(16, 16);
		aim_rot = 180;
	}

	function set_aim_rot(v:Float) {
		var idx = (v + 360/frame_count/4).map(0, 360, 0, frame_count).cycle(0, frame_count).round();
		animation.frameIndex = idx;
		return aim_rot = v;
	}

	override function update(dt:Float) {
		super.update(dt);
	}

}