package net.colapsydo.game.controllers;

import openfl.events.KeyboardEvent;
import net.colapsydo.game.logic.gameCore.ActivePair;
import net.colapsydo.game.logic.gameCore.GameGrid;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 */
class CpuController extends Controller
{
	//data
	var _activePair:ActivePair;
	var _grid:GameGrid;
	
	//Logic
	var _bestSlavePos:SlavePosition;
	var _bestMasterX:Int;
	
	var _masterScoreDown:Vector<Float>;
	var _masterScoreUp:Vector<Float>;
	var _SlaveScoreDown:Vector<Float>;
	var _SlaveScoreUp:Vector<Float>;
	
	//Movement
	var _left:Bool;
	var _right:Bool;
	var _down:Bool;
	var _rotationT:Bool;
	var _rotationAT:Bool;
	var _sideTimer:Int;
	var _working:Bool;
	var _rotTtimer:Float;
	var _rotATtimer:Float;
	
	public function new(activePair:ActivePair, grid:GameGrid) {
		super();
		_activePair = activePair;
		_grid = grid;
	}
	
	//PRIVATE FUNCTIONS
	
	function selectPosition() {
		_bestSlavePos = LEFT;
		_bestMasterX = 2;
		
		var _bestScore:Float = 0.0;
		var _betterPos:Vector<SlavePosition> = new Vector<SlavePosition>();
		var _betterX:Vector<Int> = new Vector<Int>();
		
		var _masterScoreDown:Vector<Float> = new Vector<Float>();
		var _masterScoreUp:Vector<Float> = new Vector<Float>();
		var _SlaveScoreDown:Vector<Float> = new Vector<Float>();
		var _SlaveScoreUp:Vector<Float> = new Vector<Float>();
		var masterType:Int = _activePair.getMasterNote();
		var slaveType:Int = _activePair.getSlaveNote();
		var firstEmptyCell:Int;
		
		for (i in 1...7) {
			firstEmptyCell = _grid.getFirstEmptyCell(i);
			_masterScoreDown.push(scoring(firstEmptyCell*8+i, masterType));
			_masterScoreUp.push(scoring((firstEmptyCell+1)*8+i, masterType));
			_SlaveScoreDown.push(scoring(firstEmptyCell*8+i, slaveType));
			_SlaveScoreUp.push(scoring((firstEmptyCell+1)*8+i, slaveType));
		}
		
		trace(_masterScoreDown);
		
		var tempPos:SlavePosition = LEFT;
		var tempMasterPosX:Int = 2;
		//var temp
	}
	
	inline function scoring(index:Int, noteType:Int):Float{
		var score:Float = 0.0;
		var step:Int = 0;
		var value:Int;
		
		value = _grid.getValue(index - 9);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index - 8);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index - 7);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index - 1);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index + 1);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index + 7);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index + 8);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index + 9);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		
		step = step > 0?step:1;
		return(score / (noteType * step));
	}
	
	inline function cellSum(value:Int, noteType:Int):Float {
		var difference:Int;
		difference = noteType - value;
		difference *= difference > 0 ? 2 : -2;
		return(noteType - difference);
	}
	
	public override function keyboardDown(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				if (_left == false) {
					_left = true;
					_sideTimer = 10;
					if (_working == true) { 
						_activePair.horizontalMove( -1 ); 
						_activePair.upSpeed(false);
					}
				}
				
			case 39: //right
				if (_right == false) {
					_right = true;
					_sideTimer = 10;
					if (_working == true) { 
						_activePair.horizontalMove( 1 ); 
						_activePair.upSpeed(false);
					}
				}
				
			case 40: //down
				if (_down == false) {
					_down = true;
					if (_working == true) { _activePair.upSpeed(_down); }
				}
				
			case 87: //w
				if (_rotationT == false) {
					_rotationT = true;
					if (_working == true) { 
						if (_rotTtimer < 15) {
							_activePair.rotate(true,true); 
						}else {
							_activePair.rotate(true);
							_rotTtimer = 0;
						}
					}
				}
			case 38,88: //x
				if (_rotationAT == false) {
					_rotationAT = true;
					if (_working == true) { 
						if (_rotATtimer < 15) {
							_activePair.rotate(false,true);  
						}else {
							_activePair.rotate(false);
							_rotATtimer = 0;
						}
					}
				}
			default:
		}
	}
	
	public override function keyboardUp(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				_left = false;
				_activePair.upSpeed(_down);
			case 39: //right
				_right = false;
				_activePair.upSpeed(_down);
			case 40: //down
				_down = false;
				_activePair.upSpeed(_down);
			case 87: //w
				_rotationT = false;				
			case 38,88: //x
				_rotationAT = false;
			default:
		}
	}
	
	public override function working(working:Bool) {
		_working = working;
		if (_working == true) {
			selectPosition();
		}
	}
	
	public override function update():Void {
		_rotTtimer++;
		_rotATtimer++;
		if (_left == true || _right==true) {
			if (--_sideTimer == 0) {
				_sideTimer = 2;
				_activePair.upSpeed(_down);
				if (_left == true) { _activePair.horizontalMove( -1 ); }
				if (_right == true) { _activePair.horizontalMove( 1 ); }
			}
		}
	}
	
}