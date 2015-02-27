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
	
	static public inline var UPDATE:String = "update";
	
	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(e:Event):Void{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_gameCore = new GameCore(0);
		addEventListener(Event.ENTER_FRAME, updateHandler);
	}
	
	private function updateHandler(e:Event):Void {
		_gameCore.update();
		dispatchEvent(new Event(Playground.UPDATE));
	}
	
	//GETTERS && SETTERS
	
	public function getGameCore(player:Int = 0):GameCore {
		//return(_gameCoreList[player]);
		return(_gameCore);
	}
	
}