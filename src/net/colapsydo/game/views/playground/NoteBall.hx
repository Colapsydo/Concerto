package net.colapsydo.game.views.playground;

import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
enum NoteState {
	IDLE;
	FALLING;
	BOUNCING;
}
 
class NoteBall extends Sprite
{
	var _indexX:Int;
	var _indexY:Int;
	var _posY:Float;
	var _targetY:Float;
	var _dir:Int = 1;
	
	var _type:Int;
	var _state:NoteState;
	
	static public inline var LANDED:String = "landed";
	static public inline var BOUNCED:String = "bounced";
	
	static var _size:Float;
	
	public function new(type:Int) {
		super();
		_type = type;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_posY = _targetY = 0;
		draw();
	}
	
	//HANDLERS
	
	private function fallingHandler(e:Event):Void {
		if (_posY >= _targetY) {
			_posY = _targetY;
			removeEventListener(Event.ENTER_FRAME, fallingHandler);
			dispatchEvent(new Event(NoteBall.LANDED));
		}else {
			_posY += _size * .3;
		}
		this.y = _posY;
	}
	
	private function bouncingHandler(e:Event):Void {
		var scaleY = this.scaleY;
		scaleY -= _dir * .08;
		this.scaleX += _dir * .04;
		if (scaleY <= 0.4) {
			scaleY = .4;
			_dir *= -1;
		}
		if (scaleY >= 1) {
			scaleY = 1;
			this.scaleX = 1;
			removeEventListener(Event.ENTER_FRAME, bouncingHandler);
			dispatchEvent(new Event(NoteBall.BOUNCED));
		}
		
		this.scaleY = scaleY;
	}
	
	//PRIVATE FUNCTIONS
	
	function draw(grid:Bool=false) {
		this.graphics.clear();
		switch(_type) {
			case 1:
				this.graphics.beginFill(0xFF0000);
			case 2:
				this.graphics.beginFill(0x00FF00);
			case 3:
				this.graphics.beginFill(0x0000FF);
		}
		if (grid == true) {
			this.graphics.drawCircle(0, -_size, _size);
		}else {
			this.graphics.drawCircle(0, 0, _size);
		}
		this.graphics.endFill();
		this.graphics.lineStyle(1, 0);
		if (grid == true) {
			this.graphics.moveTo(0, -_size);
			this.graphics.lineTo(0, -2*_size);
		}else {
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(0, -_size);
		}
	}
	
	//PUBLIC FUNCTIONS
	
	public function convert(type:Int, ?grid:Bool = false ):Void {
		//grid will change the position resp y to have the scale animation on y
		_type = type;
		draw(grid);
		_state = IDLE;
	}
	
	public function changeState(state:NoteState):Void {
		_state = state;
		switch(_state) {
			case IDLE:
			case FALLING:
				trace(_targetY, _posY);
				addEventListener(Event.ENTER_FRAME, fallingHandler);
			case BOUNCING:
				_dir = 1;
				addEventListener(Event.ENTER_FRAME, bouncingHandler);
		}
	}
	
	static public function setSize(step:Int):Void{
		_size = step *.5;
	}
	
	//GETTERS && SETTERS
	
	public function getType():Int { return(_type); }
	public function getIndexX():Int { return(_indexX); }
	public function getIndexY():Int { return(_indexY); }
	public function getPosY():Float{ return(_posY); }
	public function getTargetY():Float { return(_targetY); }
	
	public function setIndexX(indexX:Int):Void {
		_indexX = indexX;
		this.x = (_indexX + .5) * _size * 2;
	}
	public function setIndexY(indexY:Int):Void {
		_indexY = indexY;
		_targetY = (15 - indexY) * _size * 2;
	}
	public function setPosY(posY:Float):Void {
		_posY = (15.5-posY)*_size*2;
		this.y = _posY;
	}
}