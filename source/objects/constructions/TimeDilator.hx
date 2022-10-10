package objects.constructions;

import flixel.input.mouse.FlxMouseEvent;

class TimeDilator extends Construction {
	
	public var speed(default, set):TimeDilatorTime;

	function set_speed(v:TimeDilatorTime) {
		switch v {
			case SLOW:PLAYSTATE.timescale = 0.5;
			case NORMAL:PLAYSTATE.timescale = 1;
			case FAST:PLAYSTATE.timescale = 2;
		}
		animation.play(v.string());
		return speed = v;
	}

	public function new(x:Int, y:Int) {
		super(x, y);
		loadGraphic(Images.time_dilator__png, true, 16, 32);
		this.make_anchored_hitbox(16, 16);
		animation.add(SLOW.string(), [0,1,2,3], 30);
		animation.add(NORMAL.string(), [4,5,6,7], 15);
		animation.add(FAST.string(), [8,9,10,11], 8);

		FlxMouseEvent.add(this, t -> {
			speed = switch speed {
				case SLOW:NORMAL;
				case NORMAL:FAST;
				case FAST:SLOW;
			}
		});

		CARDS.deck.remove(TIME_DILATOR);
		speed = NORMAL;
	}

	override function kill() {
		speed = NORMAL;
		super.kill();
		CARDS.deck.push(TIME_DILATOR);
	}

}

enum TimeDilatorTime {
	SLOW;
	NORMAL;
	FAST;
}