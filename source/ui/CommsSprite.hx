package ui;

import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

class CommsSprite extends FlxSprite {

	var ping:Ping;
	
	public function new(parent:FlxGroup) {
		super(128 + 12, 32 + 12);
		loadGraphic(Images.ui_incoming_transmission_icon__png, true, 96, 96);
		animation.add('play', [0,1,2,3,4,3,4,3,4,3,4,3,4,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4], 24, true);
		animation.play('play');
		this.make_and_center_hitbox(0, 0);
		scale.set(0.25, 0.25);
		animation.callback = anim_callback;
		parent.add(this);
		ping = new Ping(parent);
		scrollFactor.set(0,0);
		blend = ADD;
	}

	function anim_callback(s:String, n:Int, i:Int) {
		if (n == 0) ping.ping(x, y);
	}

}

class Ping {

	var spr:FlxSprite;

	public function new(parent:FlxGroup) {
		spr = new FlxSprite(0, 0, Images.gradient_circle__png);
		spr.make_and_center_hitbox(0, 0);
		spr.blend = ADD;
		spr.kill();
		parent.add(spr);
	}

	public function ping(x:Float, y:Float) {
		spr.reset(x, y);
		spr.scale.set(0,0);
		spr.alpha = 0.1;
		spr.flicker(1);
		FlxTween.tween(spr, { alpha: 0, 'scale.x': 1, 'scale.y': 1 }, 1, { onComplete: t -> spr.kill() });
	}

}