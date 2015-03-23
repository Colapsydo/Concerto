package net.colapsydo.game.logic.gameCore;

import net.colapsydo.utils.mt.Rand;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * model of distribution
 */
class Distribution extends EventDispatcher
{
	var _gameSeed:Int;
	var _randomGenerator:Rand;
	
	var _maxType:Int;
	var _limitType:Int;
	var _nextPairs:Vector<Int>;
	
	var _transfoSchedule:Vector<Int>;
	
	static var _noteNum:Int;
	
	static public inline var ACTIVATION:String = "activation";
	
	public function new(colorNum:Int) {
		super();
		_maxType = colorNum;
		init();
	}
	
	function init():Void{
		_noteNum = 0;
		
		_gameSeed = 726854171;
		_randomGenerator = new Rand(_gameSeed);
		
		_transfoSchedule = new Vector<Int>();
		
		_limitType = 6;
		_nextPairs = new Vector<Int>();
		for (i in 0...4) {
			_nextPairs.push(uniformDistribution());
		}
	}
	
	//PRIVATE FUNCTIONS
	
	function uniformDistribution():Int {
		return(_maxType - Std.int(Math.sqrt(_randomGenerator.rand())*_maxType));
		//return(_randomGenerator.random(_maxType)+1);
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
		//if (_noteNum % 2 == 0) {
			//dispatchEvent
		//}
		return(note);
	}
	
	public function transform(color:Int):Int {
		if (color < _limitType) {
			color++;
			if (color > _maxType) {
				if (_transfoSchedule.length>0) {
					if (color == _transfoSchedule[0] && _noteNum == _transfoSchedule[1]) {
						_maxType = color;
						_transfoSchedule.splice(0, 2);
					}
				}else {
					dispatchEvent(new Event(Distribution.ACTIVATION));
				}
			}
			return(color);
		}else {
			return(0);
		}
	}
	
	public function schedule(type:Int, num:Int) {
		if (_noteNum == num) {
			_maxType = type+1;
		}else {
			_transfoSchedule.push(type);
			_transfoSchedule.push(num);
		}
	}
	
	//GETTERS && SETTERS
	
	public function getSeed():Int { return(_gameSeed); }
	public function getMaxType():Int { return(_maxType); }
	public function getNoteNum():Int { return(_noteNum); }
	public function getNote(index:Int):Int { return(_nextPairs[index]);}
	
}