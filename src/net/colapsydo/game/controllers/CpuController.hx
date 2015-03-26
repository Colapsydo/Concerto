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
	var _bestScore:Float;
	
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
		
		_bestScore = Math.NEGATIVE_INFINITY;
		var betterPos:Vector<SlavePosition> = new Vector<SlavePosition>();
		var betterX:Vector<Int> = new Vector<Int>();
		
		var masterScoreDown:Vector<Float> = new Vector<Float>();
		var masterScoreUp:Vector<Float> = new Vector<Float>();
		var slaveScoreDown:Vector<Float> = new Vector<Float>();
		var slaveScoreUp:Vector<Float> = new Vector<Float>();
		var masterType:Int = _activePair.getMasterNote();
		var slaveType:Int = _activePair.getSlaveNote();
		var firstEmptyCell:Int;
		
		for (i in 1...7) {
			firstEmptyCell = _grid.getFirstEmptyCell(i);
			masterScoreDown.push(scoring(firstEmptyCell*8+i, masterType));
			masterScoreUp.push(scoring((firstEmptyCell+1)*8+i, masterType));
			slaveScoreDown.push(scoring(firstEmptyCell*8+i, slaveType));
			slaveScoreUp.push(scoring((firstEmptyCell+1)*8+i, slaveType));
		}
		
		//trace("");
		//trace("down");
		//trace(masterScoreDown);
		//trace(slaveScoreDown);
		//trace("up");
		//trace(masterScoreUp);
		//trace(slaveScoreUp);
		
		
		for (i in 0...6) {
			if (i > 0) {
				searchForBest(i, masterScoreDown[i] + slaveScoreDown[i - 1], LEFT, betterPos, betterX);
			}
			if (i < 5) {
				searchForBest(i, masterScoreDown[i] + slaveScoreDown[i + 1], RIGHT, betterPos, betterX);
			}
			searchForBest(i, masterScoreUp[i] + slaveScoreDown[i], BOTTOM, betterPos, betterX);
			searchForBest(i, masterScoreDown[i] + slaveScoreUp[i], TOP, betterPos, betterX);
		}
		
		//trace("best");
		//trace(betterPos);
		//trace(betterX);
		
		if (betterX.length > 0) {
			var index:Int = Std.int(betterX.length * Math.random());
			_bestSlavePos = betterPos[index];
			_bestMasterX = betterX[index];
		}
	}
	
	inline function scoring(index:Int, noteType:Int):Float{
		var score:Float = 0.0;
		var step:Int = 0;
		var value:Int;
		
		value = _grid.getValue(index - 9);
		if (value >0) {
			score += cellSum(value, noteType)*.5;
			step++;
		}
		value = _grid.getValue(index - 8);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index - 7);
		if (value >0) {
			score += cellSum(value, noteType)*.5;
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
			score += cellSum(value, noteType)*.5;
			step++;
		}
		value = _grid.getValue(index + 8);
		if (value >0) {
			score += cellSum(value, noteType);
			step++;
		}
		value = _grid.getValue(index + 9);
		if (value >0) {
			score += cellSum(value, noteType)*.5;
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
	
	inline function searchForBest(index:Int, score:Float, pos:SlavePosition, bestPos:Vector<SlavePosition>, bestX:Vector<Int>):Void {
		//trace(index, pos);
		//trace(score, _bestScore);
		if (score >= _bestScore) {
			if (score == _bestScore) {
				bestPos.push(pos);
				bestX.push(index+1);
			}else {
				_bestScore = score;
				bestPos.splice(0, bestPos.length);
				bestPos.push(pos);
				bestX.splice(0, bestX.length);
				bestX.push(index+1);
			}
		}
		//trace("besties");
		//trace(_bestScore);
		//trace(bestPos);
		//trace(bestX);
		
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
		}else {
			_activePair.upSpeed(false);
		}
	}
	
	public override function update():Void {
		var diffX:Int = _bestMasterX-_activePair.getMasterPosX();
		if (diffX != 0) {
			if (diffX > 0) {
				_activePair.horizontalMove( 1 );
			}else {
				_activePair.horizontalMove( -1 );
			}
		}
		if (_activePair.getSlavePos() != _bestSlavePos) {
			_activePair.rotate(true,true);
		}else {
			if (diffX == 0) {
				_activePair.upSpeed(true);
			}
		}
		
		
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