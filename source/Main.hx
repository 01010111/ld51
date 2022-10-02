package;

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
	static var WIDTH:Int = 0;
	static var HEIGHT:Int = 0;

	public function new()
	{
		super();
		addChild(new FlxGame(WIDTH, HEIGHT, states.PlayState, 60, 60, true));
		((?dt:Dynamic) -> {
			Timer.update(dt);
			SyncedSin.update(dt);
		}).listen('preupdate');
		#if PIXEL_PERFECT
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		#end
	}
}