package ui;

import util.CardManager.Card;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class PlacementIndicator extends FlxGroup {

	var placement:FlxSprite;
	var circle:FlxSprite;

	public function new() {
		super();

		placement = new FlxSprite();
		placement.loadGraphic(Images.placement_indicator__png, true, 16, 48);
		placement.make_anchored_hitbox(16, 16);
		placement.blend = ADD;
		add(placement);

		circle = new FlxSprite();
		circle.loadGraphic(Images.circles__png, true, 144*4, 144*4);
		circle.make_and_center_hitbox(0,0);
		circle.scale.set(0.25, 0.25);
		circle.blend = ADD;
		add(circle);

		hide();
	}

	public function show() {
		visible = true;
	}

	public function hide() {
		visible = false;
	}

	public function revise(x:Int, y:Int, r:Int, card:Card) {
		var c = CONSTRUCTION_MNGR.get_obj_at_coord(x, y);
		var a = switch card {
			case WALL, TURRET, PROXY, DIGGER, TIME_DILATOR, RADAR, CARD_BOX, TELEPORTER: CONSTRUCTION_MNGR.can_place(x, y);
			case RATE_UP: c != null && c.rate < c.max_rate;
			case RANGE_UP: c != null && c.range < c.max_range;
			case POWER_UP: c != null && c.power < c.max_power;
			case BOOBYTRAP: c != null && !c.boobytrapped;
			case SHIELD: c != null;
		}

		circle.visible = a && r > 0;

		placement.animation.frameIndex = a ? 0 : 1;
		circle.animation.frameIndex = (4 - r).clamp(0, 3).floor();

		placement.setPosition(x * 16 + GRID_OFFSET_X, y * 16 + GRID_OFFSET_Y);
		circle.setPosition(x * 16 + GRID_OFFSET_X + 8, y * 16 + GRID_OFFSET_Y + 8);
	}
	
}