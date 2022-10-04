package objects;

import util.CardManager;
import flixel.input.mouse.FlxMouseEvent;
import zero.utilities.Vec2;
import flixel.FlxSprite;

class Card extends FlxSprite {
	
	public var held:Bool = false;
	public var target:Vec2 = Vec2.get();

	public var card_type:util.CardManager.Card;

	public function new() {
		super(FlxG.width/2, FlxG.height);
		loadGraphic(Images.cards__png, true, 48, 64);
		card_type = CARDS.next();
		animation.frameIndex = cast card_type;
		CARDS.add(this);
		FlxMouseEvent.add(this, c -> pickup());
		PLAYSTATE.fg_ui_layer.add(this);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!held) target.set(
			FlxG.width/2 - CARDS.hand.length/2 * 56 + CARDS.hand.indexOf(this) * 56,
			FlxG.height - 32
		);
		else {
			if (PLAYSTATE.field.containsPoint(FlxG.mouse.getPosition())) {
				target.set(
					FlxG.mouse.x.snap_to_grid(16, 0, true) + 8 - 24,
					FlxG.mouse.y.snap_to_grid(16, 0, true) + 8 - 96
				);
				PLAYSTATE.placement_indicator.show();
				PLAYSTATE.placement_indicator.revise(PLAYSTATE.px_to_gx(FlxG.mouse.x), PLAYSTATE.py_to_gy(FlxG.mouse.y), CARDS.get_indicator_radius(card_type));
			}
			else {
				target.set(FlxG.mouse.x - 24, FlxG.mouse.y - 48);
				PLAYSTATE.placement_indicator.hide();
			}
			if (FlxG.mouse.justReleased) drop();
		}
		x += (target.x - x) * 0.35;
		y += (target.y - y) * 0.35;
	}

	function pickup() {
		held = true;
	}

	function drop() {
		held = false;
		PLAYSTATE.placement_indicator.hide();
		attempt_placement();
	}

	function attempt_placement() {
		switch card_type {
			case WALL:
				if (CONSTRUCTION_MNGR.can_place(PLAYSTATE.px_to_gx(FlxG.mouse.x), PLAYSTATE.py_to_gy(FlxG.mouse.y))) {
					new Wall(PLAYSTATE.px_to_gx(FlxG.mouse.x), PLAYSTATE.py_to_gy(FlxG.mouse.y));
					kill();
				}
			case TURRET:
				if (CONSTRUCTION_MNGR.can_place(PLAYSTATE.px_to_gx(FlxG.mouse.x), PLAYSTATE.py_to_gy(FlxG.mouse.y))) {
					new Turret(PLAYSTATE.px_to_gx(FlxG.mouse.x), PLAYSTATE.py_to_gy(FlxG.mouse.y));
					kill();
				}
			case PROXY:
			case RATE_UP:
			case RANGE_UP:
			case POWER_UP:
			case BOOBYTRAP:
			case SHIELD:
		}
	}

	override function kill() {
		super.kill();
		CARDS.remove(this);
	}

}