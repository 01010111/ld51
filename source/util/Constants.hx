package util;

import ui.GoldCount;
import ui.MonsterCount;
import states.PlayState;

var PLAYSTATE:PlayState;
var CONSTRUCTION_MNGR:ConstructionManager;
var WALL_MNGR:WallManager;
var MONSTERS:MonsterManager;
var METEORS:MeteorManager;
var CARDS:CardManager;
var GOLD_COUNT:GoldCount;
var MONSTER_COUNT:MonsterCount;

var GRID_OFFSET_X:Float = 112;
var GRID_OFFSET_Y:Float = 32;
var GRID_SIZE:Float = 16;
var GRID_WIDTH:Int = 18;
var GRID_HEIGHT:Int = 14;
var MONSTER_TIMER:Int = 12;