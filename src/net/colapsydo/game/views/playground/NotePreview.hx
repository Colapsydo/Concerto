package net.colapsydo.game.views.playground;

import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class NotePreview extends Sprite
{
	var _type:Int;
	
	public function new(type:Int) {
		super();
		_type = type;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		draw();
	}
	
	//HANDLERS
	
	//PRIVATE FUNCTIONS
	
	function draw() {
		this.graphics.clear();
		this.graphics.lineStyle(2, 0);
		switch(_type) {
			case 1:
				this.graphics.beginFill(0xFF0000);
			case 2:
				this.graphics.beginFill(0x00FF00);
			case 3:
				this.graphics.beginFill(0x0000FF);
			case 4:
				this.graphics.beginFill(0xFFFF00);
			case 5:
				this.graphics.beginFill(0xFF00FF);
			case 6:
				this.graphics.beginFill(0x00FFFF);
		}
		this.graphics.drawCircle(0, 0, 5);
		this.graphics.endFill();
	}
	
	//PUBLIC FUNCTIONS
	
	public function convert(type:Int):Void {
		_type = type;
		draw();
	}
	
	//GETTERS && SETTERS

	
}