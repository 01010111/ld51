package states;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import fx.Spotlight;
import haxe.Timer;
import fx.Nugget;
import fx.Beam;
import fx.Star;
import fx.PlacementIndicator;
import zero.utilities.IntPoint;
import flixel.math.FlxRect;
import util.CardManager;
import flixel.input.mouse.FlxMouseEventManager;
import fx.WarningIndicator;
import util.MeteorManager;
import fx.Explosion;
import fx.Dust;
import objects.Meteor;
import flixel.util.FlxTimer;
import fx.MeteorTrail;
import fx.Spark;
import fx.Poof;
import objects.Projectile;
import objects.Bullet;
import zero.flixel.ec.ParticleEmitter;
import util.MonsterManager;
import objects.Gadget;
import objects.Turret;
import fx.Decal;
import objects.Wall;
import objects.Tilemap;
import openfl.Assets;
import util.WallManager;
import util.ConstructionManager;
import objects.GameObject;
import flixel.group.FlxGroup;
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

	// game stuff 
	public var score:Int = 0;
	public var field:FlxRect = FlxRect.get(GRID_OFFSET_X, GRID_OFFSET_Y, GRID_WIDTH * GRID_SIZE, GRID_HEIGHT * GRID_SIZE);
	public var placement_indicator:PlacementIndicator;

	override function create() {
		FlxG.plugins.add(new FlxMouseEventManager());
		FlxG.mouse.useSystemCursor = true;
		PLAYSTATE = this;
		add_layers();
		init_managers();
		init_stage();
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
		var level = OgmoUtils.parse_level_json(Assets.getText(Data.stage__json)).get_tile_layer('tiles');
		tile_layer.add(new Tilemap({ data: level.data2D, tile_width: 16, tile_height: 16, tiles: Images.tiles__png, flags: level.tileFlags2D }));

		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor(), TELEPORTER);
		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor() - 1, RADAR);
		new Gadget((GRID_WIDTH/2).floor(), (GRID_HEIGHT/2).floor() - 1, CARD_MACHINE);
		Gadget.get(CARD_MACHINE).util = 99;
		new objects.Card(TURRET);
	}

	override function update(e:Float) {
		super.update(e);
		object_layer.sort((i,o1,o2) -> o1.my < o2.my ? -1 : 1);
		FlxG.collide(monsters,monsters);
		FlxG.overlap(walls, projectiles, (w, p) -> p.kill());
		FlxG.overlap(monsters, projectiles, (m, p) -> {
			p.kill();
			m.hurt(p.power);
		});
		if (flash_layer.alpha > 0) flash_layer.color = [0xfffeb854, 0xffe8ea4a, 0xff58f5b1, 0xffcc68e4, 0xfffe626e].get_random();
	}

	public function px_to_gx(v:Float) return ((v - GRID_OFFSET_X)/GRID_SIZE).floor();
	public function py_to_gy(v:Float) return ((v - GRID_OFFSET_Y)/GRID_SIZE).floor();

	public function hitstop(ms:Int) {
		Timer.delay(() -> {
			FlxG.timeScale = 0;
			Timer.delay(() -> FlxG.timeScale = 1, ms);
		}, 17);
	}

	public function flash(t:Float, a:Float) {
		flash_layer.alpha = a;
		FlxTween.tween(flash_layer, { alpha: 0 }, t);
	}

}