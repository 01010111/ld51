package util;

class Conversions {
	
	public static function px_to_gx(v:Float):Int return ((v - GRID_OFFSET_X)/GRID_SIZE).floor();
	public static function py_to_gy(v:Float):Int return ((v - GRID_OFFSET_Y)/GRID_SIZE).floor();

	public static function gx_to_wx(v:Int):Int return v + (GRID_OFFSET_X/GRID_SIZE).floor();
	public static function gy_to_wy(v:Int):Int return v + (GRID_OFFSET_Y/GRID_SIZE).floor();

}