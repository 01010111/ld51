package ui;

import util.CardManager;
import flixel.input.mouse.FlxMouseEvent;
import zero.utilities.Vec2;
import flixel.FlxSprite;
import objects.constructions.*;

class Card extends FlxSprite {

	public var held:Bool = false;
	public var mouseover:Bool = false;
	public var target:Vec2 = Vec2.get();

	public var card_type:util.CardManager.Card;

	public function new(?type:util.CardManager.Card) {
		super(FlxG.width/2 - 24, FlxG.height);
		loadGraphic(Images.cards__png, true, 48 * 4, 64 * 4);
		setSize(48, 64);
		origin.set(0,0);
		scale.set(0.25, 0.25);
		card_type = type != null ? type : CARDS.next();
		animation.frameIndex = cast card_type;
		CARDS.add(this);
		FlxMouseEvent.add(this, c -> pickup(), null, c -> over(), c -> out());
		PLAYSTATE.card_layer.add(this);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!held) target.set(
			FlxG.width/2 - CARDS.hand.length/2 * 56 + CARDS.hand.indexOf(this) * 56,
			FlxG.height - (mouseover ? 48 : 32)
		);
		else {
			if (PLAYSTATE.field.containsPoint(FlxG.mouse.getPosition())) {
				target.set(
					FlxG.mouse.x.snap_to_grid(16, 0, true) + 8 - 24,
					FlxG.mouse.y.snap_to_grid(16, 0, true) + 8 - 96
				);
				PLAYSTATE.placement_indicator.show();
				var mx = FlxG.mouse.x.px_to_gx();
				var my = FlxG.mouse.y.py_to_gy();
				PLAYSTATE.placement_indicator.revise(
					mx, my,
					CARDS.get_indicator_radius(card_type, CONSTRUCTION_MNGR.get_obj_at_coord(mx, my)),
					card_type
				);
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
		if (!PLAYSTATE.available) return;
		held = true;
		mouseover = false;
	}

	function over() {
		for (c in CARDS.hand) c.mouseover = false;
		mouseover = true;
	}

	function out() {
		mouseover = false;
	}

	function drop() {
		held = false;
		PLAYSTATE.placement_indicator.hide();
		attempt_placement();
	}

	function attempt_placement() {
		var x = FlxG.mouse.x.px_to_gx();
		var y = FlxG.mouse.y.py_to_gy();
		var c = CONSTRUCTION_MNGR.get_obj_at_coord(x, y);
		var can_place = CONSTRUCTION_MNGR.can_place(x, y) && PLAYSTATE.available;
		switch card_type {
			case WALL:
				if (can_place) {
					new Wall(x, y);
					kill();
				}
			case TURRET:
				if (can_place) {
					new Turret(x, y);
					kill();
				}
			case PROXY:
				if (can_place) {
					new Proxy(x, y);
					kill();
				}
			case DIGGER:
				if (can_place) {
					new Digger(x, y);
					kill();
				}
			case TIME_DILATOR:
				if (can_place) {
					new TimeDilator(x, y);
					kill();
				}
			case RADAR:
				if (can_place) {
					new Gadget(x, y, RADAR);
					kill();
				}
			case DECOY:
				if (can_place) {
					new Gadget(x, y, DECOY);
					kill();
				}
			case CARD_BOX:
				if (can_place) {
					new Gadget(x, y, CARD_MACHINE);
					kill();
				}
			case TELEPORTER:
				if (can_place) {
					new Gadget(x, y, TELEPORTER);
					kill();
				}
			case RATE_UP:
				if (c != null && c.rate < c.max_rate) {
					c.rate++;
					PLAYSTATE.stars.fire({ position: c.getMidpoint() });
					kill();
				}
			case RANGE_UP:
				if (c != null && c.range < c.max_range) {
					c.range++;
					PLAYSTATE.stars.fire({ position: c.getMidpoint() });
					kill();
				}
			case POWER_UP:
				if (c != null && c.power < c.max_power) {
					c.power++;
					PLAYSTATE.stars.fire({ position: c.getMidpoint() });
					kill();
				}
			case BOOBYTRAP:
				if (c != null && !c.boobytrapped) {
					c.boobytrapped = true;
					PLAYSTATE.stars.fire({ position: c.getMidpoint() });
					kill();
				}
			case SHIELD:
				if (c != null && !c.shielded) {
					c.shielded = true;
					kill();
				}
			default:
		}
	}

	override function kill() {
		super.kill();
		CARDS.remove(this);
	}

}