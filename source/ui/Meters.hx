package ui;

import objects.constructions.Gadget.GadgetType;
import flixel.tweens.FlxTween;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class Meters extends FlxTypedGroup<FlxObject> {
	
	public var m1_icon:FlxSprite = new FlxSprite();
	public var m2_icon:FlxSprite = new FlxSprite();
	public var m3_icon:FlxSprite = new FlxSprite();

	public var m1_bg:FlxSprite = new FlxSprite();
	public var m2_bg:FlxSprite = new FlxSprite();
	public var m3_bg:FlxSprite = new FlxSprite();

	public var m1_submeter:FlxSprite = new FlxSprite();
	public var m2_submeter:FlxSprite = new FlxSprite();
	public var m3_submeter:FlxSprite = new FlxSprite();

	public var m1_t:FlxTween;
	public var m2_t:FlxTween;
	public var m3_t:FlxTween;

	public var m1_meter:FlxSprite = new FlxSprite();
	public var m2_meter:FlxSprite = new FlxSprite();
	public var m3_meter:FlxSprite = new FlxSprite();

	public var x:Float = 0;
	public var y:Float = 0;

	public function new() {
		super();

		for (icon in [m1_icon, m2_icon, m3_icon]) {
			var i = [m1_icon, m2_icon, m3_icon].indexOf(icon);
			icon.loadGraphic(Images.icons__png, true, 16*4, 16*4);
			icon.setPosition(16, 16 * i + 16);
			icon.make_and_center_hitbox(0, 0);
			icon.scale.set(0.25, 0.25);
			icon.animation.frameIndex = i;
			add(icon);
		}

		for (bg in [m1_bg, m2_bg, m3_bg]) {
			var i = [m1_bg, m2_bg, m3_bg].indexOf(bg);
			bg.loadGraphic(Images.healthbar__png, true, 42*4, 4*4);
			bg.setPosition(24 - 1, 16 * i + 16 - 2);
			bg.animation.frameIndex = 0;
			bg.origin.set(0,0);
			bg.scale.set(0.25, 0.25);
			add(bg);
		}

		for (submeter in [m1_submeter, m2_submeter, m3_submeter]) {
			var i = [m1_submeter, m2_submeter, m3_submeter].indexOf(submeter);
			submeter.makeGraphic(40, 2, 0xFFd10f4c);
			submeter.setPosition(24, 16 * i + 16 - 1);
			submeter.origin.x = 0;
			add(submeter);
		}

		for (meter in [m1_meter, m2_meter, m3_meter]) {
			var i = [m1_meter, m2_meter, m3_meter].indexOf(meter);
			meter.makeGraphic(40, 2, 0xFFFFFFFF);
			meter.setPosition(24, 16 * i + 16 - 1);
			meter.origin.x = 0;
			add(meter);
		}

		PLAYSTATE.fg_ui_layer.add(this);
	}

	override function draw() {
		for (child in members) child.setPosition(child.x + x, child.y + y); 
		super.draw();
		for (child in members) child.setPosition(child.x - x, child.y - y); 
	}

	public function refresh(g:GadgetType, n:Float) {
		var i = [RADAR, CARD_MACHINE, TELEPORTER].indexOf(g);
		n = n.clamp(0, 1);

		var icon = [m1_icon, m2_icon, m3_icon][i];
		var bg = [m1_bg, m2_bg, m3_bg][i];
		var submeter = [m1_submeter, m2_submeter, m3_submeter][i];
		var meter = [m1_meter, m2_meter, m3_meter][i];
		var t = [m1_t, m2_t, m3_t][i];

		icon.color = n == 0 ? 0xFFd10f4c : 0xFFFFFFFF;
		bg.animation.frameIndex = n == 0 ? 1 : 0;
		meter.scale.x = n;
		if (t != null && t.active) t.cancel();
		t = FlxTween.tween(submeter.scale, { x: n }, 0.1, { startDelay: 0.4 });
	}

}