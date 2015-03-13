package net.colapsydo.game.logic;

import net.colapsydo.game.logic.gameCore.GameCore;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 * Model with data on the type of game, number of player, dealing with intergame mechanics
 */
class Playground extends Sprite
{
	var _gameCore:GameCore;
	
	static var _evolution:Bool;
	
	public function new(evolution:Bool=true) {
		super();
		_evolution = evolution;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(e:Event):Void{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_gameCore = new GameCore(0);
		addChild(_gameCore);
	}
	
	//GETTERS && SETTERS
	
	public function getGameCore(player:Int = 0):GameCore {
		//return(_gameCoreList[player]);
		return(_gameCore);
	}
	
	static public function getEvolution():Bool { return(_evolution);}
}