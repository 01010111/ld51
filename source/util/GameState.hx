package util;

import flixel.util.FlxSave;
import util.CardManager.Card;

var starter_cards:Array<Card>;
var player_deck:Array<Card>;
var vol_sound:Float;
var vol_music:Float;
var screenshake_amt:Float;

private var save:FlxSave = new FlxSave();

function load_game() {
	save.bind('planet-monster-2022');
	if (save.data.player_deck == null) return init_game();
	starter_cards = save.data.starter_cards;
	player_deck = save.data.player_deck;
	vol_sound = save.data.vol_sound;
	vol_music = save.data.vol_music;
	screenshake_amt = save.data.screenshake_amt;
}

function save_game() {
	save.data.player_deck = player_deck;
	save.data.starter_cards = starter_cards;
	save.data.vol_sound = vol_sound;
	save.data.vol_music = vol_music;
	save.data.screenshake_amt = screenshake_amt;
}

function reset_game() {
	starter_cards = [
		TELEPORTER,
		TURRET,
	];
	player_deck = [
		TURRET,
		TURRET,
		TURRET,
		TURRET,
		WALL,
		WALL,
		WALL,
		WALL,
		POWER_UP,
		RANGE_UP,
		RATE_UP,
	];
}

function unlock_all() {
	
}

function init_game() {
	reset_game();
	vol_sound = 0.75;
	vol_music = 0.66;
	screenshake_amt = 0.75;
	save_game();
}