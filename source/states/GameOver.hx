package states;

import flixel.text.FlxText;
import ui.FadeRect;
import ui.Button;
import zero.flixel.states.State;

using flixel.util.FlxSpriteUtil;

class GameOver extends State {

	override function create() {
		bgColor = 0xFF000000;

		var monster_count = MONSTER_COUNT == null ? 12.get_random().floor() : MONSTER_COUNT.amt;
		var gold_count = GOLD_COUNT == null ? 12.get_random().floor() : GOLD_COUNT.amt;
		var build_count = CONSTRUCTION_MNGR == null ? 12.get_random().floor() : CONSTRUCTION_MNGR.amt;

		var failure_text = new FlxText(32, 168, 128*4, 'FAILURE', 16*4);
		failure_text.setFormat('Intro Demo Black CAPS', 16*4);
		failure_text.origin.set(0, 0);
		failure_text.scale.set(0.25, 0.25);
		add(failure_text);

		var stats_title_text = new FlxText(0, 168, 160*4, '', 10*4);
		stats_title_text.setFormat('Intro Demo Black CAPS', 10*4);
		stats_title_text.screenCenter();
		stats_title_text.scale.set(0.25, 0.25);
		stats_title_text.y -= 40;
		add(stats_title_text);

		var stats_amt_text = new FlxText(0, 168, 160*4, '', 10*4);
		stats_amt_text.setFormat('Intro Demo Black CAPS', 10*4, 0xFE7000, RIGHT);
		stats_amt_text.screenCenter();
		stats_amt_text.scale.set(0.25, 0.25);
		stats_amt_text.y -= 40;
		add(stats_amt_text);

		stats_title_text.drawRect(0, 0, stats_title_text.width, stats_title_text.height, 0x00FFFFFF, { thickness: 4, color: 0xFFFF004D });

		var cont_btn = new Button(384, 232, SURE, () -> exit());
		add(cont_btn);

		stats_title_text.text = 'MONSTERS KILLED:\n\nBUILDINGS PLACED:\n\nGOLD RETRIEVED:';
		stats_amt_text.text = '${monster_count}\n\n${build_count}\n\n${gold_count}';
	}

	function exit() {
		add(new FadeRect(OUTRO, 0.5, null, () -> FlxG.switchState(new Title())));
	}

}