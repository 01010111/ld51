package objects;

class Gadget extends Construction {
	
	public static var gadgets:Array<Gadget> = [];

	public function new(x:Int, y:Int, type:GadgetType) {
		super(x, y, false);
		loadGraphic(Images.gadgets__png, true, 16, 32);
		animation.frameIndex = switch type {
			case TELEPORTER:0;
			case RADAR:1;
			case CARD_MACHINE:2;
		}
		this.make_anchored_hitbox(16, 16);
		gadgets.push(this);
	}

}

enum GadgetType {
	TELEPORTER;
	RADAR;
	CARD_MACHINE;
}