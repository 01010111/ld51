package objects;

import zero.flixel.ec.Entity;

class GameObject extends Entity {
	public var mp_x(get, never):Float;
	public var mp_y(get, never):Float;
	function get_mp_x() return x + width/2;
	function get_mp_y() return y + height/2;

	public var gx(get, never):Int;
	public var gy(get, never):Int;
	function get_gx() return ((x - GRID_OFFSET_X)/GRID_SIZE).floor();
	function get_gy() return ((y - GRID_OFFSET_Y)/GRID_SIZE).floor();
}