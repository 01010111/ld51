package states;

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

	// particles
	public var bullets:ParticleEmitter;
	public var poofs:ParticleEmitter;
	public var sparks:ParticleEmitter;
	public var trails:ParticleEmitter;
	public var dust:ParticleEmitter;
	public var explosions:ParticleEmitter;
	public var warn_ind:ParticleEmitter;

	// logical layers
	public var projectiles:FlxTypedGroup<Projectile> = new FlxTypedGroup();
	public var monsters:FlxGroup = new FlxGroup();
	public var walls:FlxGroup = new FlxGroup();

	override function create() {
		FlxG.mouse.useSystemCursor = true;
		PLAYSTATE = this;
		CONSTRUCTION_MNGR = new ConstructionManager();
		WALL_MNGR = new WallManager();
		MONSTERS = new MonsterManager();
		METEORS = new MeteorManager();
		Gadget.gadgets = [];
		add_layers();
		init_stage();
	}

	function add_layers() {
		add(tile_layer = new FlxGroup());
		add(decals_a = new FlxGroup());
		add(decals_b = new FlxGroup());
		add(bg_ui_layer = new FlxGroup());
		add(dust = new ParticleEmitter(() -> new Dust()));
		add(object_layer = new FlxTypedGroup());
		add(bullets = new ParticleEmitter(() -> new Bullet()));
		add(sparks = new ParticleEmitter(() -> new Spark()));
		add(poofs = new ParticleEmitter(() -> new Poof()));
		add(foreground_layer = new FlxGroup());
		add(trails = new ParticleEmitter(() -> new MeteorTrail()));
		add(explosions = new ParticleEmitter(() -> new Explosion()));
		add(warn_ind = new ParticleEmitter(() -> new WarningIndicator()));
		add(fg_ui_layer = new FlxGroup());
	}

	function init_stage() {
		var level = OgmoUtils.parse_level_json(Assets.getText(Data.stage__json));
		var tiles = new Tilemap({
			data: level.get_tile_layer('tiles').data2D,
			tile_width: 16,
			tile_height: 16,
			tiles: Images.tiles__png,
			flags: level.get_tile_layer('tiles').tileFlags2D,
		});
		tile_layer.add(tiles);

		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor(), TELEPORTER);
		new Gadget((GRID_WIDTH/2).floor() - 1, (GRID_HEIGHT/2).floor() - 1, RADAR);
		new Gadget((GRID_WIDTH/2).floor(), (GRID_HEIGHT/2).floor() - 1, CARD_MACHINE);

		new Wall(5, 4);
		new Wall(5, 5);
		new Wall(5, 6);
		new Wall(5, 7);
		new Wall(5, 8);
		new Wall(6, 8);

		new Wall(12, 3);
		new Wall(13, 3);
		new Wall(14, 3);
		new Wall(14, 4);
		new Wall(14, 5);
		new Wall(14, 6);
		new Wall(14, 7);
		new Wall(14, 8);

		new Turret(10, 7);
		new Turret(7, 5);
		new Turret(9, 8);
		new Turret(14, 2);
		new Turret(15, 10);
		new Turret(3, 4);
		new Turret(4, 8);

		for (i in 0...16) new Turret(GRID_WIDTH.get_random().floor(), GRID_HEIGHT.get_random().floor());
		for (i in 0...8) new Wall(GRID_WIDTH.get_random().floor(), GRID_HEIGHT.get_random().floor());

		MONSTERS.spawn();
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
	}

}