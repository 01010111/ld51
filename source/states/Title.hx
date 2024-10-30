package states;

import flixel.FlxBasic;
import ui.MenuItem;
import flixel.FlxObject;
import util.Group;
import openfl.system.System;
import ui.TextButton;
import ui.Button;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import zero.flixel.ec.ParticleEmitter;
import zero.flixel.ec.ParticleEmitter.FireOptions;
import zero.flixel.ec.ParticleEmitter.Particle;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;

class Title extends FlxState {

	var ok = true;
	var group = new util.Group();
	var title:FlxSprite;
	var title_fg:FlxSprite;
	var tweens:Array<FlxTween> = [];
	var available = true;
	var state:TitleState = MAIN;
	var aux_objects:Array<FlxBasic> = [];

	override function create() {
		bgColor = 0xff000000;

		title = new FlxSprite(0,0,Images.title__png);
		title.scale.set(0.2, 0.2);
		title.make_and_center_hitbox(0,0);
		title.screenCenter();
		title.alpha = 0;
		tweens.push(FlxTween.tween(title, { alpha: 1 }, 5, { ease: FlxEase.expoIn }));
		tweens.push(FlxTween.tween(title.scale, { x: 0.25, y: 0.25 }, 30, { ease: FlxEase.expoOut }));

		var smokes = new ParticleEmitter(() -> new Smoke());
		for (i in 0...8) new FlxTimer().start(0.05, t -> smokes.fire({ position: FlxPoint.get(FlxG.width.get_random() - FlxG.width/2, FlxG.height) }), 0);

		var bge = new ParticleEmitter(() -> new BGExplosion());
		for (i in 0...4) new FlxTimer().start(1.get_random()).onComplete = t -> {
			new FlxTimer().start(8.get_random(2), t -> {
				bge.fire({ position: FlxPoint.get(FlxG.width.get_random(), FlxG.height + 128.get_random(32)) });
			}, 0);
		}

		var embers = new ParticleEmitter(() -> new Ember());
		for (i in 0...4) new FlxTimer().start(6.get_random(2), t -> embers.fire({ position: FlxPoint.get(FlxG.width.get_random(-FlxG.width), FlxG.height + 32) }), 0);

		title_fg = new FlxSprite(0,0,Images.title__png);
		title_fg.scale.set(0.2, 0.2);
		title_fg.make_and_center_hitbox(0,0);
		title_fg.screenCenter();
		title_fg.alpha = 0;
		tweens.push(FlxTween.tween(title_fg.scale, { x: 0.25, y: 0.25 }, 30, { ease: FlxEase.expoOut }));
		tweens.push(FlxTween.tween(title_fg, { alpha: 1 }, 30, { ease: FlxEase.expoIn, startDelay: 30 }));

		group.add(title);

		add(group);
		add(smokes);
		add(bge);
		add(embers);
		add(title_fg);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		'update'.dispatch(elapsed);
		if (ok && FlxG.mouse.justPressed) {
			ok = false;
			for (tween in tweens) if (tween.active) tween.cancel();
			FlxTween.tween(title_fg, { alpha: 0 }, 0.25);
			FlxTween.tween(title, { alpha: 0 }, 0.25).onComplete = t -> load_menu();
		}
	}

	function load_menu() {
		title_fg.visible = false;
		title.scale.set(0.125, 0.125);
		title.alpha = 1;
		title.setPosition(92, 64);

		group.add(new Button(384, 232, LETS_GO, () -> if (check(MAIN)) exit()));
		// group.add(new TextButton(32, 168, 'CHECKLIST', () -> if (check(MAIN)) show_checklist()));
		// group.add(new TextButton(32, 192, 'DECK', () -> if (check(MAIN)) show_deck()));
		group.add(new TextButton(32, 216, 'OPTIONS', () -> if (check(MAIN)) show_options()));
		#if sys
		group.add(new TextButton(32, 240, 'QUIT', () -> if (check(MAIN)) System.exit(0)));
		#end
	}

	function check(state:TitleState) {
		return available && this.state == state;
	}

	function reset_aux_group() {
		available = false;
		FlxTween.tween(FlxG.camera.scroll, { y: FlxG.height }, 0.25, { ease: FlxEase.quadOut }).onComplete = t -> {
			available = true;
			state = SUB;
		}
	}

	function show_title() {
		available = false;
		FlxTween.tween(FlxG.camera.scroll, { y: 0 }, 0.25, { ease: FlxEase.quadOut }).onComplete = t -> {
			available = true;
			state = MAIN;
			for (o in aux_objects) o.kill();
		};
	}

	function add_aux(object:FlxObject) {
		group.add(object);
		object.y += FlxG.height;
		aux_objects.push(object);
	}

	function show_checklist() {
		reset_aux_group();
		add_aux(new Button(384, 232, GOT_IT, () -> if (check(SUB)) show_title()));
	}

	function show_deck() {
		reset_aux_group();
		add_aux(new Button(384, 232, GOT_IT, () -> if (check(SUB)) show_title()));
	}

	function show_options() {
		reset_aux_group();

		var menu_items:Array<MenuItem> = [
			{
				x: 32,
				y: FlxG.height + 80 + 24 * 0,
				label: 'SOUND',
				type: SLIDER,
				init_value: vol_sound,
				on_change: v -> vol_sound = v,
				subtitle_values: ['SILENT', 'QUIET', 'NORMAL', 'LOUD', 'DEAFENING']
			},
			{
				x: 32,
				y: FlxG.height + 80 + 24 * 1,
				label: 'MUSIC',
				type: SLIDER,
				init_value: vol_music,
				on_change: v -> vol_music = v,
				subtitle_values: ['SILENT', 'QUIET', 'BOPPIN', 'JAMMIN', 'ROCKIN']
			},
			{
				x: 32,
				y: FlxG.height + 80 + 24 * 2,
				label: 'SCREENSHAKE',
				type: SLIDER,
				init_value: screenshake_amt,
				on_change: v -> screenshake_amt = v,
				subtitle_values: ['CALM', 'ROCKY', 'WILDIN', 'DIZZYING']
			},
			#if !html5
			{
				x: 32,
				y: FlxG.height + 80 + 24 * 3,
				label: 'FULLSCREEN',
				type: TOGGLE,
				init_bool: FlxG.fullscreen,
				on_select: v -> FlxG.fullscreen = v,
			},
			#end
		];

		var y = 0;
		for (item in menu_items) {
			item.x = 32;
			item.y = FlxG.height + 80 + y * 24;
			item.init();
			add(item);
			aux_objects.push(item);
			y++;
		}

		add_aux(new Button(384, 232, SURE, () -> if (check(SUB)) show_title()));
	}

	function exit() {
		available = false;
		var smokes = new ParticleEmitter(() -> new Smoke());
		for (i in 0...16) new FlxTimer().start(0.01, t -> smokes.fire({ position: FlxPoint.get(FlxG.width.get_random(-FlxG.width), FlxG.height + 128) }), 0);

		var screen = new FlxSprite();
		screen.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		screen.alpha = 0;

		add(smokes);
		add(screen);

		FlxTween.tween(screen, { alpha: 1 }, 2, { ease: FlxEase.expoIn, onComplete: t -> FlxG.switchState(new PlayState()) });
	}

}

class Smoke extends Particle {

	public function new() {
		super();
		loadGraphic(Images.smoke__png);
		this.make_and_center_hitbox(0,0);
		color = 0xFF000000;
		scrollFactor.set(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		alpha = 0.2.get_random();
		var s = 5.get_random(1);
		scale.set(s, s);
		velocity.set();
		acceleration.set(300.get_random(200), 1000.get_random(1) * -1);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (y < -64) kill();
	}

}

class BGExplosion extends Particle {

	static var _i = 0;

	var alpha_m1:Float = 0;
	var alpha_m2:Float = 0;
	var flicker_timer:Float = 0.04;

	public function new() {
		super();
		loadGraphic(Images.big_smoke__png);
		this.make_and_center_hitbox(0,0);
		color = [0xffe03c32, 0xfffe7000, 0xfffeb854][_i++ % 3];
		blend = ADD;
		scrollFactor.set(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		var s = 2.get_random(1);
		scale.set(s, s);
		alpha_m1 = 0.3.get_random();
		alpha_m2 = 0.75;
		FlxTween.tween(this, { alpha_m1: 0, 'scale.x': s * 2, 'scale.y': s * 2 }, 12.get_random(6), { ease: FlxEase.quadOut, onComplete: t -> kill() });
	}

	override function update(dt:Float) {
		super.update(dt);
		alpha = alpha_m1 * alpha_m2;
		if ((flicker_timer -= dt) <= 0) {
			flicker_timer = 0.12.get_random(0.02);
			alpha_m2 = alpha_m2 < 1 ? 1 : 1.get_random(0.8);
		}
	}
}

class Ember extends Particle {

	var am:Float;
	var trail:FlxTrail;

	public function new() {
		super();
		loadGraphic(Images.ember__png);
		this.make_and_center_hitbox(0, 0);
		blend = ADD;

		trail = new FlxTrail(this, null, 64, 0, 0.2, 0.025);
		trail.blend = ADD;
		trail.scrollFactor.set(0,0);
		FlxG.state.add(trail);
		scrollFactor.set(0,0);
	}

	override function fire(options:FireOptions) {
		super.fire(options);
		t = 0;
		tm = 4.get_random(1);
		m = 2.get_random(1);
		am = 1.get_random(0.25);
		var s = 2.get_random(1);
		scale.set(s,s);
		velocity.set(200.get_random(50), 200.get_random(50) * -1);
	}

	var t:Float;
	var m:Float;
	var tm:Float;

	override function update(dt:Float) {
		super.update(dt);
		if (y < -32) kill();
		velocity.y += Math.sin((t += dt) * tm) * m;
		alpha = 1.get_random(0.25) * am;
	}

}

enum TitleState {
	MAIN;
	SUB;
}