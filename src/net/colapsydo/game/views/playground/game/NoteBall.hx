package net.colapsydo.game.views.playground.game;

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
	BLINKING;
	EXPLODING;
	TRANSFORMING;
}
 
class NoteBall extends Sprite
{
	var _indexX:Int; //final X Index in Datagrid
	var _indexY:Int; //final Y index in Datagrid
	var _posY:Float; //Actual Pos Y on grid view
	var _targetY:Float;  //Target Pos Y on grid view
	var _dir:Float = 1;
	
	var _fallingVel:Float;
	var _bouncingCoeff:Float;
	var _bounceLimit:Float; 
	
	var _type:Int;
	var _state:NoteState;
	
	var _noteballTarget:NoteBall;
	var _incomingLights:Int;
	
	static var _blinkValue:Float;
	static var _blinkDir:Int;
	static var _size:Float;
	static var _gridHeight:Int;
	
	static public inline var LANDED:String = "landed";
	static public inline var BOUNCED:String = "bounced";
	static public inline var DESTROYED:String = "destroyed";
	static public inline var TRANSFORMED:String = "transformed";
	
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
			_posY += _size * _fallingVel;
			_fallingVel += _fallingVel < .5 ? 0.03 : 0;
		}
		this.y = _posY;
	}
	
	private function bouncingHandler(e:Event):Void {
		var scaleY = this.scaleY;
		scaleY -= _dir * .11*_bouncingCoeff;
		this.scaleX += _dir * .06*_bouncingCoeff;
		this.y += _indexY==1 ? 0 : _dir*_bouncingCoeff ;
		if (scaleY <= _bounceLimit) {
			scaleY = _bounceLimit;
			_dir *= -1;
		}
		if (scaleY >= 1) {
			scaleY = 1;
			this.scaleX = 1;
			this.y = _posY;
			_fallingVel = 0;
			_state = IDLE;
			removeEventListener(Event.ENTER_FRAME, bouncingHandler);
			dispatchEvent(new Event(NoteBall.BOUNCED));
		}
		
		this.scaleY = scaleY;
	}
	
	private function explodingHandler(e:Event):Void {
		var scale:Float = this.scaleX;
		scale += 0.05 * _dir;
		if (scale > 1.2) {
			scale = 1.2;
			_dir *= -1.5;
		}
		if (scale < 0.3) {
			scale = 0.3;
			removeEventListener(Event.ENTER_FRAME, explodingHandler);
			dispatchEvent(new Event(NoteBall.DESTROYED));
		}
		this.scaleX = this.scaleY = scale;
	}
	
	private function transformingHandler(e:Event):Void {
		//var color:Float = this.
	}
	
	private function lightOffHandler(e:Event):Void {
		
	}
	
	private function blinkingHandler(e:Event):Void {
		this.alpha = _blinkValue;
	}
	
	static private function blinkHandler(e:Event):Void {
		_blinkValue+= _blinkDir * .025;
		if (_blinkValue < .5 || _blinkValue>1) {
			_blinkValue = _blinkValue < .5 ? .5 : 1;
			_blinkDir *= -1;
		}
	}
	
	//PRIVATE FUNCTIONS
	
	function draw(grid:Bool=false) {
		var size:Float = 1 * _size;
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
		if (_type > 0) {
			if (grid == true) {
			this.graphics.drawCircle(0, -size, size);
			}else {
				this.graphics.drawCircle(0, 0, size);
			}
			this.graphics.endFill();
			this.graphics.lineStyle(1, 0);
			if (grid == true) {
				this.graphics.moveTo(0, -size);
				this.graphics.lineTo(0, -2*size);
			}else {
				this.graphics.moveTo(0, 0);
				this.graphics.lineTo(0, -size);
			}
		}else {
			var step:Int = -_type;
			var offSize:Float = size / step;
			this.graphics.beginFill(0xEFEFEF - step * 0x333333);
			this.graphics.lineStyle(2, 0);
			this.graphics.drawRect( -size, -2 * size, 2 * size, 2 * size);
			//this.graphics.drawCircle(0, -size, size);
			this.graphics.endFill();
		}
		
	}
	
	//PUBLIC FUNCTIONS
	
	public function convert(type:Int, ?grid:Bool = false ):Void {
		//grid will change the position resp y to have the scale animation on y
		_type = type;
		draw(grid);
		this.scaleX = this.scaleY = 1;
		_state = IDLE;
	}
	
	public function changeState(state:NoteState):Void {
		_state = state;
		switch(_state) {
			case IDLE:
				removeEventListener(Event.ENTER_FRAME, blinkingHandler);
				this.alpha = 1;				
			case FALLING:
				_fallingVel = _fallingVel == 0 ? 0.05 : _fallingVel;
				addEventListener(Event.ENTER_FRAME, fallingHandler);
			case BOUNCING:
				_dir = 1;
				_bouncingCoeff = _fallingVel * 2;
				_bounceLimit = 1 - (.6 * _bouncingCoeff);
				addEventListener(Event.ENTER_FRAME, bouncingHandler);
			case BLINKING:
				if (this.alpha == 1) {
					this.alpha = _blinkValue;
					addEventListener(Event.ENTER_FRAME, blinkingHandler);
				}
			case EXPLODING:
				_dir = 1;
				addEventListener(Event.ENTER_FRAME, explodingHandler);
			case TRANSFORMING:	
				//addEventListener(Event.ENTER_FRAME, transformingHandler);
		}
	}
	
	public function startBlinking():Void {
		_blinkValue = 1;
		_blinkDir = 1;
		addEventListener(Event.ENTER_FRAME, blinkHandler);
	}
	
	public function stopBlinking():Void{
		removeEventListener(Event.ENTER_FRAME, blinkHandler);
	}
	
	public function incoming():Void {
		_incomingLights++;
	}
	
	public function arrived():Void {
		_incomingLights--;
		if (_incomingLights == 0) {
			convert(_type, true);
			//addEventListener(Event.ENTER_FRAME, lightOffHandler);
			dispatchEvent(new Event(NoteBall.TRANSFORMED));
		}
	}
	
	static public function setSize(step:Int):Void{_size = step * .5; }
	static public function setGridSize(gridHeight:Int):Void{_gridHeight = gridHeight; }
	
	//GETTERS && SETTERS
	
	public function getType():Int { return(_type); }
	public function getIndexX():Int { return(_indexX); }
	public function getIndexY():Int { return(_indexY); }
	public function getPosY():Float{ return(_posY); }
	public function getTargetY():Float { return(_targetY); }
	public function getState():NoteState { return(_state); }
	public function getVel():Float { return(_fallingVel); }
	public function getTarget():NoteBall { return(_noteballTarget); }
	
	public function setType(value:Int):Void {
		_type = value;
	}
	public function setIndexX(indexX:Int):Void {
		_indexX = indexX;
		this.x = (_indexX + .5) * _size * 2;
	}
	public function setIndexY(indexY:Int):Void {
		_indexY = indexY;
		_targetY = (_gridHeight - indexY) * _size * 2;
	}
	public function setPosY(posY:Float):Void {
		_posY = (_gridHeight+.5-posY)*_size*2;
		this.y = _posY;
	}
	public function setVel(vel:Float):Void{
		_fallingVel = vel;
	}
	public function setTarget(target:NoteBall):Void {
		_noteballTarget = target;
	}
	
}