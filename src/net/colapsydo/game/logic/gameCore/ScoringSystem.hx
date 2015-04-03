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
	var _hitScore:Int;
	var _hitMultiplier:Int;
	var _chains:Int;
	
	var _attackScore:Int;
	var _attackHit:Int;
	var _attackLevel:Int;
	var _attackNum:Int;
	var _attackPos:Float;
	var _attack:Vector<Int>;
	var _attackReady:Bool;
	
	static var _colorWeight:Vector<Int> = Vector.ofArray([1, 2, 3, 4, 5, 6]);
	static var _lengthWeight:Vector<Int> = Vector.ofArray([0, 1, 2, 3, 4, 5,6,7]);
	static var _chainCoeff:Vector<Int> = Vector.ofArray([1,2,4,8,16,32,64,128,256,512,1024]);
	static var _attackStep:Vector<Int> = Vector.ofArray([100,600,4200,29400]);
	
	public function new(grid:GameGrid):Void {
		_grid = grid;
		init();
	}
	
	function init() {
		_totalScore = 0;
		_chains = 0;
		
		_attackScore = 0;
		_attackHit = 0;
		_attackLevel = 0;
		_attackNum = 0;
		_attackPos = 0.0;
		_attack = new Vector<Int>();
		_attack.length = 6;
		_attack.fixed = true;
		
		attackCounter();
	}
	
	//PRIVATE FUNCTIONS
	
	function attackCounter():Void {
		var step:Int = _attackStep[_attackLevel];
		
		_attackPos = 0;
		
		while (_attackHit >= step) {
			_attackNum += 1;
			_attackHit -= step;
			if (_attackNum == 6) {
				_attackNum = 0;
				_attackLevel += 1;
				_attackPos += 6;
				step = _attackStep[_attackLevel];
			}
		}
		_attackPos += _attackHit / step;
		_attackPos += _attackNum;
	}
	
	//PUBLIC FUNCTIONS
	
	public function newAttack():Void{
		_chains = 0;
		_attackReady = false;
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
		
		_hitScore *= _hitMultiplier;
		
		_totalScore += _hitScore;
		_attackScore += _hitScore;
		_attackHit += _hitScore;
		
		attackCounter();
		
		//trace("new hit : ", _hitScore, " x ", _hitMultiplier);
		//trace("total score: ",_totalScore);
	}
	
	public function activationBonus(actiType:Int) {
		_totalScore += _colorWeight[actiType-1] * 1000 * _hitMultiplier;
		_attackScore += _colorWeight[actiType-1] * 1000 * _hitMultiplier;
		attackCounter();
		
		//trace("activation Bonus", _colorWeight[actiType-1] * 1000, _hitMultiplier); 
	}
	
	//GETTERS && SETTERS
	
	public function getHitScore():Int { return(_hitScore); }
	public function getHitMultiplier():Int { return(_hitMultiplier); }
	public function getTotalScore():Int { return(_totalScore); }
	public function getAttackPos():Float { return(_attackPos / 6); }
	
}