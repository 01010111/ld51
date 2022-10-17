package objects.constructions;

class Digger extends Construction {
	
	var gold_timer:Float = 30;
	var do_give:Bool = false;
	var ref_gold:Gold;

	public function new(x:Int, y:Int) {
		super(x, y);
		loadGraphic(Images.digger__png, true, 16, 32);
		this.make_anchored_hitbox(16, 16);
		animation.add('play', [0,1,2,3,4,5,6,7,7,8,8,8,8,9,10,11],16);
		animation.play('play');

		rate = 1;
		max_rate = 3;

		allowed_special_properties = [
			EXPLOSIVE,
			KAMIKAZE,
		];

		animation.callback = anim_callback;
	}

	function anim_callback(s:String, i:Int, f:Int) {
		if (f == 10) {
			for (i in 0...6) PLAYSTATE.dust.fire({
				position: getMidpoint(), 
				velocity: (360/6*i * 45.get_random_gaussian(-45))
					.vector_from_angle(200.get_random(100))
					.to_flxpoint()
			});
			if (do_give && (ref_gold == null || !ref_gold.alive)) {
				do_give = false;
				PLAYSTATE.object_layer.add(ref_gold = new Gold(mx - 6, my));
				PLAYSTATE.stars.fire({ position: getMidpoint() });
				var tele = Gadget.get(TELEPORTER);
				var cons = CONSTRUCTION_MNGR.get_obj_at_coord(gx, gy + 1);
				if (tele != null && tele == cons) ref_gold.get(20);
			}
		}
	}

	override function update(dt:Float) {
		super.update(dt);
		animation.curAnim.frameRate = switch rate {
			case 1: 16;
			case 2: 24;
			case 3: 32;
			default: 16;
		}
		if ((gold_timer -= dt) <= 0) {
			do_give = true;
			gold_timer = switch rate {
				case 1:30;
				case 2:20;
				case 3:10;
				default:30;
			}
		}
	}

}