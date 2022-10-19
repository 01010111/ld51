package ui;

import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.FlxSprite;
import flixel.text.FlxText;

@:structInit()
class MenuItem extends FlxGroup {
	
	public var x:Float;
	public var y:Float;

	var label:String;
	var type:MenuItemType;
	var on_change:Float -> Void = (v) -> {};
	var on_press:Void -> Void = () -> {};
	var on_select:Bool -> Void = (v) -> {};
	var interact:Bool = false;
	var subtitle:FlxText;
	var subtitle_values:Array<String> = [''];
	var init_value:Float = 0;
	var init_bool:Bool = false;

	// multiple uses
	var slider_handle:FlxSprite;
	
	// slider vars
	var value:Float;

	// toggle vars
	var tog_yes:FlxSprite;
	var tog_no:FlxSprite;

	// button vars
	var bg_white:FlxSprite;

	public function new(
		x:Float,
		y:Float,
		label:String,
		type:MenuItemType,
		?init_value:Float,
		?init_bool:Bool,
		?subtitle_values:Array<String>,
		?on_change:Float -> Void,
		?on_press:Void -> Void,
		?on_select: Bool -> Void
	) {
		super();
		this.label = label;
		this.type = type;
		this.init_value = init_value;
		this.init_bool = init_bool;
		this.on_change = on_change;
		this.on_press = on_press;
		this.on_select = on_select;
		this.subtitle_values = subtitle_values;
	}

	public function init() {
		make_label();
		make_subtitle();
		switch type {
			case SLIDER:make_slider();
			case TOGGLE:make_toggle();
			case BUTTON:make_button();
		}
		return this;
	}

	function make_label() {
		var label = new FlxText(x, y, 128 * 4, label, 10 * 4);
		label.setFormat('Intro Demo Black CAPS', 10*4);
		label.origin.set(0,0);
		label.scale.set(0.25, 0.25);
		add(label);
	}

	function make_subtitle() {
		subtitle = new FlxText(x + 244, y, 80 * 4, '', 10 * 4);
		subtitle.setFormat('Intro Demo Black CAPS', 10*4);
		subtitle.origin.set(0,0);
		subtitle.scale.set(0.25, 0.25);
		add(subtitle);
	}

	function make_slider() {
		var slider_bg = new FlxSprite(x + 112, y, Images.slider_bg__png);
		add(slider_bg);

		slider_handle = new FlxSprite(x + 112, y + 6, Images.slider_handle__png);
		slider_handle.make_and_center_hitbox(0,0);
		slider_handle.scale.set(0.25, 0.25);
		add(slider_handle);

		FlxMouseEvent.add(slider_bg, s -> {
			interact = true;
		}, null, null, null, false, true, false);

		slider_handle.x = init_value.map(0, 1, x + 112, x + 112 + 100);
		value = init_value;
		subtitle.text = subtitle_values[(init_value * (subtitle_values.length - 1)).floor()];
	}

	function make_toggle() {
		//48x16 48+6
		tog_no = new FlxSprite(x + 112, y - 2);
		tog_no.loadGraphic(Images.toggle_btns__png, true, 48*4, 16*4);
		tog_no.origin.set(0,0);
		tog_no.scale.set(0.25, 0.25);
		add(tog_no);

		tog_yes = new FlxSprite(x + 112 + 48 + 6, y - 2);
		tog_yes.loadGraphic(Images.toggle_btns__png, true, 48*4, 16*4);
		tog_yes.origin.set(0,0);
		tog_yes.scale.set(0.25, 0.25);
		add(tog_yes);

		var set_bool = (b:Bool) -> {
			on_select(b);
			tog_no.animation.frameIndex = b ? 0 : 1;
			tog_yes.animation.frameIndex = b ? 3 : 2;	
		}

		FlxMouseEvent.add(tog_no, s -> set_bool(false), null, null, null, false, true, false);
		FlxMouseEvent.add(tog_yes, s -> set_bool(true), null, null, null, false, true, false);
		set_bool(init_bool);
	}

	function make_button() {

	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (!FlxG.mouse.pressed) interact = false;
		switch type {
			case SLIDER:update_slider(elapsed);
			case TOGGLE:update_toggle(elapsed);
			case BUTTON:update_button(elapsed);
		}
	}

	function update_slider(e) if (interact) {
		slider_handle.x = (FlxG.mouse.x).clamp(x + 112, x + 112 + 100);
		var v = slider_handle.x.map(x + 112, x + 112 + 100, 0, 1);
		if (v == value) return;
		on_change(v);
		value = v;
		subtitle.text = subtitle_values[(v * (subtitle_values.length - 1)).floor()];
	}

	function update_toggle(e) {

	}

	function update_button(e) {

	}

}

enum MenuItemType {
	SLIDER;
	TOGGLE;
	BUTTON;
}