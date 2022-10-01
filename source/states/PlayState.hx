package states;

import zero.flixel.states.State;

class PlayState extends State
{

	public static var instance:PlayState;

	public function new() {
		super();
		instance = this;
	}

	override function create() {
		
	}

	override function update(e:Float) {
		super.update(e);
	}

}