package net.colapsydo.game.views.playground;

import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class NoteBall extends Sprite
{
	var _posX:Float;
	var _posY:Float;
	var _targetX:Float;
	var _targetY:Float;
	
	var _type:Int;
	
	static var _size:Float;
	
	public function new(type:Int) {
		super();
		_type = type;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_posX = _posY = _targetX = _targetY = 0;
		draw();
	}
	
	//HANDLERS
	
	//PRIVATE FUNCTIONS
	
	function draw() {
		this.graphics.clear();
		switch(_type) {
			case 0:
				this.graphics.beginFill(0xFF0000);
			case 1:
				this.graphics.beginFill(0x00FF00);
			case 2:
				this.graphics.beginFill(0x0000FF);
		}
		this.graphics.drawCircle(0, 0, _size);
		this.graphics.endFill();
		this.graphics.lineStyle(1, 0);
		this.graphics.moveTo(0, 0);
		this.graphics.lineTo(0, -_size);
	}
	
	//PUBLIC FUNCTIONS
	
	public function convert(type:Int):Void {
		_type = type;
		draw();
	}
	
	static public function setSize(step:Int):Void{
		_size = step *.5;
	}
	
	//GETTERS && SETTERS
	
}