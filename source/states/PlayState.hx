package states;

import ui.GoldCount;
import flixel.util.FlxTimer;
import objects.Gold;
import haxe.Timer;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.input.mouse.FlxMouseEventManager;
import fx.*;
import objects.Bullet;
import objects.GameObject;
import objects.Projectile;
import objects.Tilemap;
import objects.constructions.Gadget;
import openfl.Assets;
import ui.Meters;
import util.CardManager;
import util.ConstructionManager;
import util.MeteorManager;
import util.MonsterManager;
import util.WallManager;
import zero.flixel.ec.ParticleEmitter;
import zero.flixel.states.State;

using zero.utilities.OgmoUtils;

class PlayState extends State
{

	// visual layers
	public var tile_layer:FlxGroup;
	public var decals_a:FlxGroup;
	public var decals_b:FlxGroup;
	public var bg_ui_layer:FlxGroup;
	public var object_layer:FlxTypedGroup<GameObject>;
	public var foreground_layer:FlxGroup;
	public var fg_ui_layer:FlxGroup;
	public var flash_layer:FlxSprite;

	// particles
	public var bullets:ParticleEmitter;
	public var poofs:ParticleEmitter;
	public var sparks:ParticleEmitter;
	public var trails:ParticleEmitter;
	public var dust:ParticleEmitter;
	public var explosions:ParticleEmitter;
	public var warn_ind:ParticleEmitter;
	public var stars:ParticleEmitter;
	public var beams:ParticleEmitter;
	public var nuggets:ParticleEmitter;
	public var spotlights:ParticleEmitter;

	// logical layers
	public var projectiles:FlxTypedGroup<Projectile> = new FlxTypedGroup();
	public var monsters:FlxGroup = new FlxGroup();
	public var walls:FlxGroup = new FlxGroup();
	public var gold:FlxTypedGroup<Gold> = new FlxTypedGroup();

	// game stuff 
	public var score(default, set):Int = 0;
	public var field:FlxRect = FlxRect.get(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_WIDTH * GRID_SIZE, GRID_HEIGHT * GRID_SIZE);
	public var placement_indicator:PlacementIndicator;
	public var meters:Meters;
	public var timescale:Float = 1;
	public var hit_stop:Bool = false;

	override function create() {
		bgColor = 0xFF8a6042;
		FlxG.plugins.add(new FlxMouseEventManager());
		FlxG.mouse.useSystemCursor = true;
		PLAYSTATE = this;
		add_layers();
		init_managers();
		init_stage();
		FlxG.camera.fade(0xFF000000, 1, true);
	}

	function add_layers() {
		add(tile_layer = new FlxGroup());
		add(decals_a = new FlxGroup());
		add(decals_b = new FlxGroup());
		add(bg_ui_layer = new FlxGroup());
		add(dust = new ParticleEmitter(() -> new Dust()));
		add(object_layer = new FlxTypedGroup());
		add(nuggets = new ParticleEmitter(() -> new Nugget()));
		add(bullets = new ParticleEmitter(() -> new Bullet()));
		add(sparks = new ParticleEmitter(() -> new Spark()));
		add(poofs = new ParticleEmitter(() -> new Poof()));
		add(foreground_layer = new FlxGroup());
		add(trails = new ParticleEmitter(() -> new MeteorTrail()));
		add(explosions = new ParticleEmitter(() -> new Explosion()));
		add(warn_ind = new ParticleEmitter(() -> new WarningIndicator()));
		add(placement_indicator = new PlacementIndicator());
		add(stars = new ParticleEmitter(() -> new Star()));
		add(beams = new ParticleEmitter(() -> new Beam()));
		add(fg_ui_layer = new FlxGroup());
		add(spotlights = new ParticleEmitter(() -> new Spotlight()));
		add(flash_layer = new FlxSprite());
		flash_layer.makeGraphic(FlxG.width, FlxG.height);
		flash_layer.blend = ADD;
		flash_layer.alpha = 0;
	}
	
	function init_managers() {
		CONSTRUCTION_MNGR = new ConstructionManager();
		WALL_MNGR = new WallManager();
		MONSTERS = new MonsterManager();
		METEORS = new MeteorManager();
		CARDS = new CardManager();
		Gadget.gadgets = [];
	}

	function init_stage() {
		meters = new Meters();
		GOLD_COUNT = new GoldCount();

		var level = OgmoUtils.parse_level_json(Assets.getText(Data.stage__json)).get_tile_layer('tiles');
		tile_layer.add(new Tilemap({ data: level.data2D, tile_width: 16, tile_height: 16, tiles: Images.tiles__png, flags: level.tileFlags2D }));

		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor(), TELEPORTER);
		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor() - 1, RADAR);
		new Gadget((GRID_WIDTH/2).floor(), (GRID_HEIGHT/2).floor() - 1, CARD_MACHINE);
		
		new FlxTimer().start(2).onComplete = t -> {
			new ui.Card(TURRET);
			new ui.Card(TIME_DILATOR);
		}
	}

	override function update(e:Float) {
		super.update(e * timescale);
		object_layer.sort((i,o1,o2) -> o1.my < o2.my ? -1 : 1);
		FlxG.collide(monsters,monsters);
		FlxG.overlap(walls, projectiles, (w, p) -> p.kill());
		FlxG.overlap(monsters, projectiles, (m, p) -> {
			p.kill();
			m.hurt(p.power);
		});
		if (flash_layer.alpha > 0) flash_layer.color = [0xfffeb854, 0xffe8ea4a, 0xff58f5b1, 0xffcc68e4, 0xfffe626e].get_random();
		FlxG.timeScale = hit_stop ? 0 : timescale;
	}

	public function px_to_gx(v:Float) return ((v - GRID_OFFSET_X)/GRID_SIZE).floor();
	public function py_to_gy(v:Float) return ((v - GRID_OFFSET_Y)/GRID_SIZE).floor();

	public function hitstop(ms:Int) {
		Timer.delay(() -> {
			hit_stop = true;
			Timer.delay(() -> hit_stop = false, ms);
		}, 17);
	}

	public function flash(t:Float, a:Float) {
		flash_layer.alpha = a;
		FlxTween.tween(flash_layer, { alpha: 0 }, t);
	}

	function set_score(v:Int) {
		GOLD_COUNT.amt = v;
		return score = v;
	}

}