package ui;

import flixel.FlxSprite;

class GoldCount extends util.Group {

	public var amt(default, set):Int;

	var nums:Array<FlxSprite> = [];

	public function new() {
		super();
		for (i in 0...5) {
			var s = new FlxSprite();
			s.loadGraphic(Images.nums__png, true, 64, 64);
			s.make_and_center_hitbox(0,0);
			s.scale.set(0.25, 0.25);
			s.x = i * 7;
			s.animation.frameIndex = 12;
			s.color = 0xffFEB854;
			add(s);
			nums.push(s);
		}
		amt = 0;
		PLAYSTATE.fg_ui_layer.add(this);

		x = FlxG.width - 35 - 20;
		y = 20;
	}

	function set_amt(v:Int) {
		v = v.clamp(0, 9999).floor();

		nums[1].color = v >= 1000 ? 0xffFEB854 : 0xffE03C32;
		nums[2].color = v >= 100 ? 0xffFEB854 : 0xffE03C32;
		nums[3].color = v >= 10 ? 0xffFEB854 : 0xffE03C32;
		nums[4].color = v > 0 ? 0xffFEB854 : 0xffE03C32;
		
		nums[1].animation.frameIndex = (v/1000).floor();
		nums[2].animation.frameIndex = ((v%1000)/100).floor();
		nums[3].animation.frameIndex = ((v%100)/10).floor();
		nums[4].animation.frameIndex = v%10;

		return amt = v;
	}

}