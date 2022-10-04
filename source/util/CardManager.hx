package util;

import objects.Construction;

class CardManager {

	var deck:Array<Card>;

	public function load_deck(arr:Array<Card>) deck = arr;
	public function shuffle() deck.shuffle();
	public function next():Card {
		deck.push(deck.shift());
		return deck.last();
	}

	public function new() {
		load_deck([WALL, WALL, WALL, TURRET, TURRET, TURRET, RATE_UP, RANGE_UP, POWER_UP]);
		shuffle();
	}

	public var hand:Array<objects.Card> = [];

	public function add(card:objects.Card) {
		hand.push(card);
	}

	public function remove(card:objects.Card) {
		hand.remove(card);
	}

	public function get_indicator_radius(card:Card, ?c:Construction) {
		return switch card {
			case WALL:0;
			case TURRET:2;
			case PROXY:1;
			case RATE_UP:c.rate + 1;
			case RANGE_UP:c.range + 1;
			case POWER_UP:c.power + 1;
			case BOOBYTRAP:0;
			case SHIELD:0;
		}
	}

}

enum abstract Card(Int) {
	var WALL = 0;
	var TURRET = 1;
	var PROXY = 2;
	var RATE_UP = 3;
	var RANGE_UP = 4;
	var POWER_UP = 5;
	var BOOBYTRAP = 6;
	var SHIELD = 7;
}