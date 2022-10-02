package objects;

import zero.flixel.ec.Entity;

class GameObject extends Entity {
	public var mx(get, never):Float;
	public var my(get, never):Float;
	function get_mx() return x + width/2;
	function get_my() return y + height/2;

	public var gx(get, never):Int;
	public var gy(get, never):Int;
	function get_gx() return ((x - GRID_OFFSET_X)/GRID_SIZE).floor();
	function get_gy() return ((y - GRID_OFFSET_Y)/GRID_SIZE).floor();

	public var wx(get, never):Int;
	public var wy(get, never):Int;
	function get_wx() return (x/GRID_SIZE).floor();
	function get_wy() return (y/GRID_SIZE).floor();

	public function new(?options:EntityOptions) {
		super(options);
		PLAYSTATE.object_layer.add(this);
	}
}