package net.colapsydo.game.logic.gameCore;
import net.colapsydo.game.views.playground.ActivePairView;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Colapsydo
 * model of active pair
 */
enum SlavePosition{
	LEFT;
	TOP;
	RIGHT;
	BOTTOM;
}
 
class ActivePair extends EventDispatcher
{
	var _grid:GameGrid;
	var _distrib:Distribution;
	
	var _masterNote:Int; 
	var _masterAbsPosX:Int; 
	var _masterPosY:Float;
	var _masterAbsPosY:Int;
	var _masterFinalPos:Int; //Lign index of the final position
	
	var _slaveNote:Int;
	var _slavePos:SlavePosition;
	var _slaveAbsPosX:Int;
	var _slaveFinalPos:Int; //Lign index of the final position
	
	var _descentVelocity:Float;
	var _trigo:Int;
	
	var _leftSideLimit:Int;
	var _rightSideLimit:Int;
	var _blocked:Bool;
	
	var _freeTime:Float;
	
	static public inline var ROTATION:String = "rotation";
	static public inline var FINALPOSCHANGE:String = "finalposchange";
	static public inline var PLAYED:String = "played";
	
	public function new(grid:GameGrid, distrib:Distribution){
		super();
		_grid = grid;
		_distrib = distrib;
		init();
	}
	
	function init():Void {
		_masterAbsPosX = 2;
		_descentVelocity = 0.025;
		_masterPosY=15.5;
		_slavePos = TOP;
		_blocked = false;
		//newPair();
	}
	
	function defineFinalPos():Void{
		_masterFinalPos = _grid.getFirstEmptyCell(_masterAbsPosX);
		switch(_slavePos) {
			case LEFT:
				_slaveFinalPos = _grid.getFirstEmptyCell(_masterAbsPosX - 1);
				_slaveAbsPosX = _masterAbsPosX -1;
			case TOP:
				_slaveFinalPos = _masterFinalPos + 1;
				_slaveAbsPosX = _masterAbsPosX ;
			case RIGHT:
				_slaveFinalPos = _grid.getFirstEmptyCell(_masterAbsPosX +1);
				_slaveAbsPosX = _masterAbsPosX + 1;
			case BOTTOM:
				_slaveFinalPos = _masterFinalPos;
				_masterFinalPos = _slaveFinalPos + 1;
				_slaveAbsPosX = _masterAbsPosX ;
		}
		
		_grid.preScan(_masterFinalPos * 8 + _masterAbsPosX, _masterNote, _slaveFinalPos * 8 + _slaveAbsPosX, _slaveNote);
		
		dispatchEvent(new Event(ActivePair.FINALPOSCHANGE));
	}
	
	function checkFinalPosCrossed() {
		var masterLanded:Bool = _masterPosY < _masterFinalPos + .5;
		switch(_slavePos) {
			case LEFT,RIGHT:
				if (masterLanded == true || _masterPosY < _slaveFinalPos + .5) {
					_freeTime-= _descentVelocity;
					_masterPosY = masterLanded==true ? _masterFinalPos + .5 : _slaveFinalPos+.5;
				}
			case TOP:
				if (masterLanded == true) {
					_freeTime-= _descentVelocity;
					_masterPosY = _masterFinalPos + .5;
				}
			case BOTTOM:
				if (_masterPosY-1 < _slaveFinalPos + .5) {
					_freeTime-= _descentVelocity;
					_masterPosY = _slaveFinalPos+1.5;
				}	
		}
		_masterAbsPosY = Std.int(_masterPosY - .5);
		if (_freeTime < 0) {
			//End of PLAY
			switch(_slavePos) {
				case LEFT:
					_slaveAbsPosX = _masterAbsPosX -1;
				case TOP,BOTTOM:
					_slaveAbsPosX = _masterAbsPosX ;
				case RIGHT:
					_slaveAbsPosX = _masterAbsPosX + 1;
			}
			
			_grid.addNote(_masterNote, _masterAbsPosX, _masterFinalPos);
			_grid.addNote(_slaveNote, _slaveAbsPosX, _slaveFinalPos);
			
			dispatchEvent(new Event(ActivePair.PLAYED));
		}
	}

	function defineSideLimits():Void{
	//get limit from grid
		var controlY:Int = _slavePos == BOTTOM ? _masterAbsPosY - 1 : _masterAbsPosY;
		_leftSideLimit = _grid.getLeftLimit(_masterAbsPosX,controlY);
		_rightSideLimit = _grid.getRightLimit(_masterAbsPosX, controlY);
		
		//In case of floating objects, if TOP/BOTTOM, take the lowest limit for both side	
	
	//Define if monocolumn free space (vertical blocked pair)	
		if (_rightSideLimit - _leftSideLimit <= 2) {
			controlY = _slavePos == BOTTOM ? _masterAbsPosY : _masterAbsPosY+1;
			_blocked = _grid.getRightLimit(_masterAbsPosX, controlY) - _grid.getLeftLimit(_masterAbsPosX, controlY) <= 2;
			if (_blocked == false) {
				if (_grid.getFirstEmptyCell(_leftSideLimit) > _grid.getFirstEmptyCell(_rightSideLimit)) {
					if (_slavePos == LEFT) {
						_leftSideLimit ++;
						_rightSideLimit += _rightSideLimit < 7 ? 1 : 0 ;
					}
				}else {
					if (_slavePos == RIGHT) {
						_leftSideLimit -=  _leftSideLimit>0 ? 1 : 0 ;
						_rightSideLimit --;
					}					
				}
			}else {
				//update offset resp slave pos	
				_leftSideLimit += _slavePos == LEFT ? 1 : 0;
				_rightSideLimit += _slavePos == RIGHT ? -1 : 0;
			}
		}else {
			//update offset resp slave pos	
			_leftSideLimit += _slavePos == LEFT ? 1 : 0;
			_rightSideLimit += _slavePos == RIGHT ? -1 : 0;
		}
	}
	
	//PUBLIC FUNCTIONS
	
	public function newPair():Void {
		_masterNote = _distrib.getNewNote();
		_slaveNote =  _distrib.getNewNote();
		
		//new pair out of screen
		_masterAbsPosY = 15;
		_masterPosY = 15.5;
		
		//Static pair up part screen
		//_masterAbsPosY = 12;
		//_masterPosY = 12.5;
		
		_slavePos = TOP;
		
		defineFinalPos();
		defineSideLimits();
		_blocked = false;
		_freeTime = 1;
	}
	
	public function update():Void {
		_masterPosY -= _descentVelocity;
		
		//each time _masterAbsPosY change need recalculate L/R side limit
		//si masterPos est inférieur ou égale à 12.5 alors on check en dessous de 11
		if (_masterPosY <= _masterAbsPosY + .5) { //change of lign
			checkFinalPosCrossed();
			defineSideLimits();
		}
	}
	
	public function rotate(trigo:Bool, double:Bool=false):Void{
		if (_blocked == false || double == true) {
		//rotation
			_trigo = trigo == true ? -1 : 1;
		//futur destination	
			switch(_slavePos) {
				case LEFT:
					_slavePos = trigo == true ? BOTTOM : TOP;
				case TOP:
					if (_blocked == true) {
						_trigo *= 2;
						_slavePos = BOTTOM;
					}else {
						_slavePos = trigo == true ? LEFT : RIGHT;
					}
				case RIGHT:
					_slavePos = trigo == true ? TOP : BOTTOM;
				case BOTTOM:
					if (_blocked == true) {
						_trigo *= 2;
						_slavePos = TOP;
					}else {
						_slavePos = trigo == true ? RIGHT : LEFT;	
					}
					
			}
		//define new sideLimits
			defineSideLimits();
			
		//check if limit are violated
			if (_masterAbsPosX <= _leftSideLimit) { _masterAbsPosX = _leftSideLimit + 1; }
			if (_masterAbsPosX >= _rightSideLimit) { _masterAbsPosX = _rightSideLimit - 1; }
			
		//Redefine FinalPos and Check for conflict	
			defineFinalPos();
			checkFinalPosCrossed();
			
			dispatchEvent(new Event(ActivePair.ROTATION));
		}	
	}
	
	public function horizontalMove(direction:Int):Void{
		var posXtest:Int = _masterAbsPosX + direction;
	//test if new position possible then movement
		if (posXtest > _leftSideLimit && posXtest < _rightSideLimit) {
			_masterAbsPosX = posXtest;
		}
		
		defineFinalPos();
	}
	
	public function upSpeed(down:Bool):Void {
		if (down == true) {
			_descentVelocity = 0.5;
		}else {
			_descentVelocity = 0.025;
		}
	}
	
	//GETTERS && SETTERS
	
	public function getMasterNote():Int {return(_masterNote);}
	public function getMasterPosX():Int { return (_masterAbsPosX);}
	public function getMasterPosY():Float { return (_masterPosY); }
	//public function getMasterAbsPosY():Float { return (_masterAbsPosY); }
	public function getMasterFinalPos():Int { return(_masterFinalPos); }
	public function getSlaveNote():Int { return(_slaveNote); }
	public function getSlavePos():SlavePosition { return(_slavePos); }
	public function getSlavePosX():Int { return (_slaveAbsPosX);}
	public function getSlaveFinalPos():Int { return(_slaveFinalPos); }
	public function getTrigo():Int { return(_trigo);}
	
	
}