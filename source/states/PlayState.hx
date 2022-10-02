package states;

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
	public var bg_ui_layer:FlxGroup;
	public var object_layer:FlxTypedGroup<GameObject>;
	public var fg_ui_layer:FlxGroup;

	override function create() {
		PLAYSTATE = this;
		CONSTRUCTION_MNGR = new ConstructionManager();
		WALL_MNGR = new WallManager();
		MONSTERS = new MonsterManager();
		Gadget.gadgets = [];
		add_layers();
		init_stage();
	}

	function add_layers() {
		add(tile_layer = new FlxGroup());
		add(bg_ui_layer = new FlxGroup());
		add(object_layer = new FlxTypedGroup());
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

		new Decal(CRATER, 192, 80);
		new Decal(BANG, 144, 248, 0.25, 360.get_random());
		new Decal(BANG, 128, 64, 0.25, 360.get_random());
		new Decal(BANG, 320, 128, 0.25, 360.get_random());
		new Decal(BLOOD_1, 240, 80, 0.25, 360.get_random());
		new Decal(BLOOD_2, 256, 96, 0.25, 360.get_random());

		MONSTERS.spawn();
	}

	override function update(e:Float) {
		super.update(e);
		object_layer.sort((i,o1,o2) -> o1.my < o2.my ? -1 : 1);
	}

}