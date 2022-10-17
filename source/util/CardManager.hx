package util;

import objects.constructions.Construction;

class CardManager {

	public var deck:Array<Card>;

	public function load_deck(arr:Array<Card>) deck = arr;
	public function shuffle() deck.shuffle();
	public function next():Card {
		deck.push(deck.shift());
		return deck.last();
	}

	public function new() {
		load_deck([
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			WALL,
			TURRET,
			TURRET,
			TURRET,
			TURRET,
			TURRET,
			TURRET,
			TURRET,
			TURRET,
			PROXY,
			PROXY,
			DIGGER,
			TIME_DILATOR,
			RATE_UP,
			RATE_UP,
			RATE_UP,
			RANGE_UP,
			RANGE_UP,
			RANGE_UP,
			POWER_UP,
			POWER_UP,
			POWER_UP,
			BOOBYTRAP,
			BOOBYTRAP,
		]);
		shuffle();
	}

	public var hand:Array<ui.Card> = [];

	public function add(card:ui.Card) {
		hand.push(card);
	}

	public function remove(card:ui.Card) {
		hand.remove(card);
	}

	public function get_indicator_radius(card:Card, ?c:Construction) {
		return switch card {
			case TURRET:2;
			case PROXY:1;
			case RANGE_UP:c == null ? 0 : c.range + 1;
			default: 0;
		}
	}

}

enum abstract Card(Int) {
	var WALL = 0;
	var TURRET = 1;
	var PROXY = 2;
	var DIGGER = 3;
	var TIME_DILATOR = 4;
	var RADAR = 7;
	var CARD_BOX = 8;
	var TELEPORTER = 9;
	var RATE_UP = 10;
	var RANGE_UP = 11;
	var POWER_UP = 12;
	var BOOBYTRAP = 13;
	var SHIELD = 14;
}