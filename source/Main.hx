package;

import shaders.Hq2x;
import states.*;
import shaders.Grain;
import openfl.display.Sprite;
import flixel.FlxGame;
import zero.utilities.ECS;
import zero.utilities.Timer;
import zero.utilities.SyncedSin;
import zero.flixel.input.FamiController;
#if PIXEL_PERFECT
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
#end

class Main extends Sprite
{
	static var WIDTH:Int = 512;
	static var HEIGHT:Int = 288;
	
	var grain:Grain;

	public function new()
	{
		super();
		addChild(new FlxGame(WIDTH, HEIGHT, Title, 60, 60, true));
		((?dt:Dynamic) -> {
			Timer.update(dt);
			SyncedSin.update(dt);
			grain.update(dt);
		}).listen('preupdate');
		FlxG.game.setFilters([
			new ShaderFilter(new Hq2x()),
			new ShaderFilter(grain = new Grain(0.01)),
		]);

		FlxG.mouse.useSystemCursor = true;
	}
}