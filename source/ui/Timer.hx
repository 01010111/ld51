package ui;

import flixel.FlxSprite;
import util.Group;

class Timer extends Group {
	public var time:Float = 1800;
	var digits:Array<FlxSprite> = [];
	var time_int(get, never):Int;
	var min(get, never):String;
	var sec(get, never):String;
	var ms(get, never):String;
	var text(get, never):String;
	var state:TimerState;

	function get_text() return '$min:$sec.$ms';
	function get_time_int() return (time * 1000).floor();
	function get_min() {
		var mini = (time_int/1000/60).max(0).floor();
		return mini < 10 ? '0$mini' : '$mini';
	}
	function get_sec() {
		var seci = (time_int/1000).floor() % 60;
		return seci < 10 ? '0$seci' : '$seci';
	}
	function get_ms() {
		var msi = (time_int % 1000);
		return msi < 100 ? msi < 10 ? '00$msi' : '0$msi' : '$msi';
	}

	public function new() {
		super();
		var letter_width = 6;
		for (i in 0...9) {
			var s = new FlxSprite();
			s.loadGraphic(Images.nums__png, true, 64, 64);
			s.make_and_center_hitbox(0, 0);
			s.scale.set(0.25, 0.25);
			s.animation.frameIndex = 12;
			s.color = 0xFFFF004D;
			s.x = i * letter_width;
			add(s);
			digits.push(s);
		}
		x = FlxG.width/2 - 4.5 * letter_width;
		y = 12;
		PLAYSTATE.fg_ui_layer.add(this);
		active = false;
		set_text('30:00.000');
	}

	override function update(elapsed:Float) {
		time -= elapsed;
		time = time.max(0);
		super.update(elapsed);
		set_text(text);
		if (time == 0) {
			active = false;
			PLAYSTATE.apocalypse();
		}
	}

	function set_text(text:String) {
		var dig = text.split('');
		for (i in 0...dig.length) {
			if (digits[i] == null) return;
			digits[i].animation.frameIndex = switch dig[i] {
				case ':': 16;
				case '.': 10;
				default: dig[i].parseInt();
			}
		}
	}

}

enum TimerState {
	NORMAL;
	WARNING;
	URGENT;
	CRITICAL;
}