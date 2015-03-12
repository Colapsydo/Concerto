package net.colapsydo.game.logic.gameCore;
import net.colapsydo.utils.mt.Rand;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * model of distribution
 */
class Distribution
{
	var _gameSeed:Int;
	var _randomGenerator:Rand;
	
	var _maxType:Int;
	var _limitType:Int;
	var _nextPairs:Vector<Int>;
	
	static var _noteNum:Int;
	
	public function new() {
		init();
	}
	
	function init():Void{
		_noteNum = 0;
		
		_gameSeed = 726854171;
		_randomGenerator = new Rand(_gameSeed);
		
		_maxType = 3;
		_limitType = 6;
		_nextPairs = new Vector<Int>();
		for (i in 0...4) {
			_nextPairs.push(uniformDistribution());
		}
		
		trace(_nextPairs);
	}
	
	//PRIVATE FUNCTIONS
	
	function uniformDistribution():Int {
		return(_randomGenerator.random(_maxType)+1);
	}
	
	//PUBLIC FUNCTIONS
	
	public function getNewNote():Int {
		var note:Int = _nextPairs[0];
		for (i in 0...3) {
			_nextPairs[i] = _nextPairs[i + 1];
		}
		_nextPairs[3] = uniformDistribution();
		_noteNum++;
		//trace(_nextPairs);
		if (_noteNum % 2 == 0) {
			//dispatchEvent
		}
		return(note);
	}
	
	public function transform(color:Int):Int {
		if (color < _limitType) {
			color++;
			_maxType = color > _maxType?color:_maxType;
			return(color);
		}else {
			return(0);
		}
	}
	
	//GETTERS && SETTERS
	
	public function getSeed():Int { return(_gameSeed); }
	public function getNote(index:Int):Int { return(_nextPairs[index]);}
	
}