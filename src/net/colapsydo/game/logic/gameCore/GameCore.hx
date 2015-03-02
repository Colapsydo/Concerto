package net.colapsydo.game.logic.gameCore;

import flash.events.Event;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Colapsydo
 * model of a complete gameboard, with distribution, grid management, game application
 */
enum GameState {
	DISTRIBUTION;
	PLAY;
	GRAVITY;
	CHAIN;
}
 
class GameCore extends Sprite
{
	var _player:Int;
	var _grid:GameGrid;
	var _distribution:Distribution;
	var _activePair:ActivePair;
	
	var _state:GameState;
	
	static public inline var UPDATE:String = "update";
	
	public function new(player:Int) {
		super();
		_player = player;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(e:Event):Void{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_grid = new GameGrid();
		_distribution = new Distribution();
		_activePair = new ActivePair(_grid, _distribution);
		_state = PLAY;
		
		addEventListener(Event.ENTER_FRAME, efHandler);
		_activePair.addEventListener(ActivePair.PLAYED, playedHandler);
	}
	
	//HANDLERS
	
	private function efHandler(e:Event):Void {
		switch(_state) {
			case DISTRIBUTION:
			case PLAY:
				_activePair.update();
			case GRAVITY:
			case CHAIN:			
		}
	}
	
	private function playedHandler(e:Event):Void {
		//Send event to views for gravity
		_activePair.removeEventListener(ActivePair.PLAYED, playedHandler);
		_state = GRAVITY;
		dispatchEvent(new Event(GameCore.UPDATE));
	}
	
	//GETTERS && SETTERS
	
	public function getGameGrid():GameGrid { return(_grid); }
	public function getActivePair():ActivePair { return(_activePair);}
	public function getGameState():GameState { return(_state); }
	
}