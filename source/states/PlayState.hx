package states;

import util.ConstructionManager;
import objects.GameObject;
import flixel.group.FlxGroup;
import zero.flixel.states.State;

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
		add_layers();
	}

	function add_layers() {
		add(tile_layer = new FlxGroup());
		add(bg_ui_layer = new FlxGroup());
		add(object_layer = new FlxTypedGroup());
		add(fg_ui_layer = new FlxGroup());
	}

	override function update(e:Float) {
		super.update(e);
		object_layer.sort((i,o1,o2) -> o1.mp_y < o2.mp_y ? -1 : 1);
	}

}