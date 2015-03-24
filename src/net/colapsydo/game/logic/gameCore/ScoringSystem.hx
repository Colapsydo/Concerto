package net.colapsydo.game.logic.gameCore;

import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 */

 class ScoringSystem
{
	var _grid:GameGrid;
	var _totalScore:Int;
	var _attackScore:Int;
	var _hitScore:Int;
	var _hitMultiplier:Int;
	var _chains:Int;
	
	static var _colorWeight:Vector<Int> = Vector.ofArray([1, 2, 3, 4, 5, 6]);
	static var _lengthWeight:Vector<Int> = Vector.ofArray([0, 1, 2, 3, 4, 5,6,7]);
	static var _chainCoeff:Vector<Int> = Vector.ofArray([1,2,4,8,16,32,64,128,256,512,1024]);
	
	public function new(grid:GameGrid):Void {
		_grid = grid;
		init();
	}
	
	function init() {
		_totalScore = 0;
		_attackScore = 0;
		_chains = 0;
	}
	
	//PUBLIC FUNCTIONS
	
	public function newAttack():Void{
		_chains = 0;
		addHit();
	}
	
	public function addHit():Void {
		var solutions:Vector<Vector<Int>> = _grid.getSolutions();
		
		// add activation Bonus
		
		_hitScore = 0;
		_hitMultiplier = solutions.length; //number of groups
		var groupMultiplier:Int = 0;
		
		for (i in 0..._hitMultiplier) {
			var groupSize = solutions[i].length;
			
			_hitScore += _colorWeight[_grid.getValue(solutions[i][0]) - 1] * groupSize * 10;
			
			groupSize = groupSize > 11 ? 11 : groupSize;
			groupSize -= 4;
			groupMultiplier+= _lengthWeight[groupSize];
		}
		
		_hitMultiplier--;
		_hitMultiplier += groupMultiplier;
		_chains = _chains > 10?10:_chains;
		_hitMultiplier += _chainCoeff[_chains];
		_chains++;
		
		_totalScore += _hitScore * _hitMultiplier;
		_attackScore += _hitScore * _hitMultiplier;
		
		trace("new hit : ", _hitScore, " x ", _hitMultiplier);
		trace("total score: ",_totalScore);
	}
	
	public function activationBonus(actiType:Int) {
		_totalScore += _colorWeight[actiType-1] * 1000 * _hitMultiplier;
		_attackScore += _colorWeight[actiType-1] * 1000 * _hitMultiplier;
		trace("activation Bonus", _colorWeight[actiType-1] * 1000, _hitMultiplier); 
	}
	
	//GETTERS && SETTERS
	
	public function getHitScore():Int { return(_hitScore); }
	public function getHitMultiplier():Int { return(_hitMultiplier); }
	public function getTotalScore():Int { return(_totalScore); }
	
}