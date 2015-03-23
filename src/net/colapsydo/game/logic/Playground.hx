package net.colapsydo.game.logic;

import net.colapsydo.game.logic.gameCore.GameCore;
import openfl.display.Sprite;
import openfl.events.Event;
import net.colapsydo.game.logic.gameCore.Distribution;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * Model with data on the type of game, number of player, dealing with intergame mechanics
 */
class Playground extends Sprite
{
	var _playerNum:Int;
	var _players:Vector<GameCore>;
	
	public function new(playerNum:Int) {
		super();
		_playerNum = playerNum;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(e:Event):Void{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_players = new Vector<GameCore>();
		
		var gameCore:GameCore = new GameCore(0);
		addChild(gameCore);
		_players.push(gameCore);
		gameCore.addEventListener(Distribution.ACTIVATION, activationHandler);
		
		if (_playerNum == 2) {
			var gameCore:GameCore = new GameCore(1);
			addChild(gameCore);
			_players.push(gameCore);
			gameCore.addEventListener(Distribution.ACTIVATION, activationHandler);
		}
	}
	
	//HANDLERS
	
	private function activationHandler(e:Event):Void {
		var actiNum:Int=0;
		var othNum:Int=0;
		var actiType:Int=0;
		
		if (_playerNum == 2) {
			if (e.target == _players[0]) {
				actiNum = _players[0].getActiNum();
				actiType = _players[0].getActiType();
				othNum = _players[1].getActiNum();
			}else {
				actiNum = _players[1].getActiNum();
				actiType = _players[1].getActiType();
				othNum = _players[0].getActiNum();
			}
		}else {
			actiNum = _players[0].getActiNum();
			actiType = _players[0].getActiType();
		}
		
		actiNum = actiNum > othNum ? actiNum : othNum;
		
		for (x in _players) {
			x.schedule(actiType, actiNum);
		}
	}
	
	//GETTERS && SETTERS
	
	public function getGameCore(player:Int = 0):GameCore {
		return(_players[player]);
	}
}