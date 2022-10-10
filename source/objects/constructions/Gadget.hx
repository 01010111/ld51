package objects.constructions;

import zero.utilities.Vec2;
import flixel.input.mouse.FlxMouseEvent;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Gadget extends Construction {
	
	public static function get(type:GadgetType) return gadget_map[type];
	static var gadget_map:Map<GadgetType, Gadget> = [];
	public static var gadgets:Array<Gadget> = [];
	public static function get_nearest(x:Float, y:Float, r:Float = 12) {
		var p1 = Vec2.get(x, y);
		var p2 = Vec2.get(0, 0);
		var d = 999;
		var nearest = null;
		for (g in gadgets) {
			if (g == null || !g.alive) continue;
			p2.set(g.mx, g.my);
			if (p1.distance(p2) <= r && p1.distance(p2) < d) nearest = g;
		}
		p1.put();
		p2.put();
		return nearest;
	}

	public var gadget_type:GadgetType;
	public var available:Bool = true;
	public var max_health:Int = 50;

	public var util(default, set):Int = 0;

	override function get_my():Float {
		return super.get_my() - 8;
	}

	public function new(x:Int, y:Int, type:GadgetType) {
		super(x, y, false);
		gadget_type = type;
		gadget_map.set(type, this);
		loadGraphic(Images.gadgets__png, true, 16, 32);
		switch type {
			case TELEPORTER:
				animation.frameIndex = 0;
			case RADAR:
				animation.add('radar', [4,5,6,5], 8);
				animation.play('radar');
			case CARD_MACHINE:
				animation.frameIndex = 7;
				st = new FlxSprite();
				st.loadGraphic(Images.numbers__png, true, 6, 7);
				FlxMouseEvent.add(this, g -> {
					if (util > 0 && CARDS.hand.length < 8) {
						new ui.Card();
						util--;
					}
				});
		}
		this.make_anchored_hitbox(16, 16);
		gadgets.push(this);
		health = max_health;
		util = 0;
	}

	function set_util(v:Int) {
		switch gadget_type {
			case RADAR:
			case TELEPORTER:
				animation.frameIndex = v;
				if (v == 3) teleport();
			case CARD_MACHINE: 
				v = v.min(99).floor();
				stamp_num(v);
		}
		return util = v;
	}

	var st:FlxSprite;
	function stamp_num(v) {
		if (v == 0) {
			st.animation.frameIndex = 10;
			stamp(st, 2, 19);
			stamp(st, 8, 19);
		}
		else if (v < 10) {
			st.animation.frameIndex = 10;
			stamp(st, 2, 19);
			st.animation.frameIndex = v;
			stamp(st, 8, 19);
		}
		else {
			st.animation.frameIndex = (v/10).floor();
			stamp(st, 2, 19);
			st.animation.frameIndex = v % 10;
			stamp(st, 8, 19);
		}
	}

	function teleport() {
		MONSTERS.begin();
		METEORS.continue_firing();
		available = false;
		for (i in 0...16) {
			new FlxTimer().start(i * 0.1).onComplete = t -> PLAYSTATE.stars.fire({ position: FlxPoint.get(mx, my - 4 - i * 16) });
		}
		new FlxTimer().start(0.5).onComplete = t -> {
			util = 0;
			new FlxTimer().start(0.1, t -> PLAYSTATE.score++, 3);
			PLAYSTATE.beams.fire({ position: FlxPoint.get(mx, my - 2) });
			for (i in 1...4) new FlxTimer().start(i * 0.2).onComplete = t -> if (get(CARD_MACHINE).alive) get(CARD_MACHINE).util ++;
			available = true;
		}
	}

	override function hurt(damage:Float) {
		super.hurt(damage);
		PLAYSTATE.meters.refresh(gadget_type, health/max_health);
	}

	override function kill() {
		for (i in 1...4) new FlxTimer().start(i * 0.25).onComplete = t -> PLAYSTATE.explosions.fire({ position: FlxPoint.get(mx, my).add(10.get_random(-10), 10.get_random(-10)) });
		for (i in 0...3) new FlxTimer().start(i * 0.25).onComplete = t -> PLAYSTATE.stars.fire({ position: getMidpoint().add(0, -16 * i) });
		super.kill();
		MONSTERS.refresh();
	}

}

enum GadgetType {
	TELEPORTER;
	RADAR;
	CARD_MACHINE;
}