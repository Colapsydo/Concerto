package net.colapsydo.game.views.playground;

import lime.math.Vector2;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class LightBall extends Sprite
{
	var _type:Int;
	var _target:NoteBall;
	var _velocity:Vector2;
	var _posX:Float;
	var _posY:Float;
	
	static var _size:Float;
	
	static public inline var ARRIVAL:String = "arrival";
	
	public function new() {
		super();
		_velocity = new Vector2();
	}
	
	//HANDLERS
	
	private function toTargetHandler(e:Event):Void {
		_posX += _velocity.x;
		_posY += _velocity.y;
		
		var diffX:Float = _target.x - _posX;
		var diffY:Float = _target.y-15 - _posY;
		
		var velTarget:Vector2 = new Vector2(diffX, diffY);
		velTarget.normalize(10);
		
		_velocity.x += (velTarget.x - _velocity.x) * .1;
		_velocity.y += (velTarget.y - _velocity.y) * .1;
		
		diffX *= diffX > 0?1: -1;
		diffY *= diffY > 0?1: -1;
		var diffVel:Float = _velocity.x > 0 ? _velocity.x : -_velocity.x;
		diffVel += _velocity.y > 0 ? _velocity.y : - _velocity.y;
		
		if (diffX+diffY<1 && diffVel<10) {
			removeEventListener(Event.ENTER_FRAME, toTargetHandler);
			_target.arrived();
			dispatchEvent(new Event(LightBall.ARRIVAL));
		}
		
		this.x = _posX;
		this.y = _posY;
	}
	
	//PRIVATE FUNCTIONS
	
	function draw():Void {
		this.graphics.clear();
		this.graphics.lineStyle(2, 0x232323);
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
				this.graphics.beginFill(0x9132C5);
			case 6:
				this.graphics.beginFill(0xFF800E);
		}
		this.graphics.drawCircle(0, -_size, _size);
	}
	
	//PUBLIC FUNCTIONS
	
	public function convert(type:Int, posX:Float, posY:Float, target:NoteBall):Void {
		_type = type;
		draw();
		_posX = posX;
		_posY = posY;
		_target = target;
		_target.incoming();
		
		this.x = _posX;
		this.y = _posY;
		_velocity.x = -5 + Math.random() * 10;
		_velocity.y = -5 + Math.random() * 10;
		_velocity.normalize(15);
		
		addEventListener(Event.ENTER_FRAME, toTargetHandler);
	}
	
	static public function setSize(size:Int) {
		_size = size * .15;
	}
	
	//GETTERS && SETTERS
	
}