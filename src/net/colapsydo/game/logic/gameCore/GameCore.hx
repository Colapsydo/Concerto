package net.colapsydo.game.logic.gameCore;

import flash.events.Event;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author Colapsydo
 * model of a complete gameboard, with distribution, grid management, game application
 */
enum GameState {
	PLAY;
	CHECK;
	CHAIN;
	GRAVITY;
}
 
class GameCore extends EventDispatcher
{
	var _player:Int;
	var _grid:GameGrid;
	var _distribution:Distribution;
	var _activePair:ActivePair;
	
	var _state:GameState;
	
	public function new(player:Int) {
		super();
		_player = player;
		init();
	}
	
	function init():Void{
		_grid = new GameGrid();
		_distribution = new Distribution();
		_activePair = new ActivePair(_grid, _distribution);
		_state = PLAY;
		
		_activePair.addEventListener(ActivePair.PLAYED, playedHandler);
	}
	
	//HANDLERS
	
	private function playedHandler(e:Event):Void {
		_state = GRAVITY;
	}
	
	public function update() {
		switch(_state) {
			case PLAY:
				_activePair.update();
			case CHECK:
			case CHAIN:
			case GRAVITY:			
		}
	}
	
	//GETTERS && SETTERS
	
	public function getGameGrid():GameGrid { return(_grid); }
	public function getActivePair():ActivePair { return(_activePair);}
	public function getGameState():GameState { return(_state); }
	
}