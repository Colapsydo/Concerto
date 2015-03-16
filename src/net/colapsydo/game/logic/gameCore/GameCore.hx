package net.colapsydo.game.logic.gameCore;

import flash.events.Event;
import haxe.Constraints.Function;
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
	LOOSE;
}
 
class GameCore extends Sprite
{
	var _player:Int;
	var _rules:GameRules;
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
		_rules = new GameRules();
		//_rules.puyoGame();
		_rules.musicGame();
		
		_distribution = new Distribution(_rules.getcolorNumStart());
		_grid = new GameGrid(_rules, _distribution);
		_activePair = new ActivePair(_grid, _distribution);
		_state = DISTRIBUTION;
	}
	
	//HANDLERS
	
	private function efHandler(e:Event):Void {
		_activePair.update();
	}
	
	private function playedHandler(e:Event):Void {	
		//Send event to views for gravity
		removeEventListener(Event.ENTER_FRAME, efHandler);
		_activePair.removeEventListener(ActivePair.PLAYED, playedHandler);
		
		_grid.lookForSolutions();
		_state = GRAVITY;
		
		dispatchEvent(new Event(GameCore.UPDATE));
	}
	
	//PUBLIC FUNCTIONS
	
	public function startGame():Void {
		_activePair.newPair();
		_state = DISTRIBUTION;
		dispatchEvent(new Event(GameCore.UPDATE));
	}
	
	public function play():Void{
		_state = PLAY;
		dispatchEvent(new Event(GameCore.UPDATE));	
		_activePair.addEventListener(ActivePair.PLAYED, playedHandler);
		addEventListener(Event.ENTER_FRAME, efHandler);
	}
	
	public function allLanded():Void {
		if (_grid.hasSolutions() == true) {
			_grid.cleanSolutions();
			_state = CHAIN;
		}else {
			//check here for gameover
			if (_grid.checkGameLimit() == false) {
				_grid.defineEmptyCells();
				_activePair.newPair();
				_state = DISTRIBUTION;
			}else {
				trace("you loose");
				_state = LOOSE;
			}
		}
		dispatchEvent(new Event(GameCore.UPDATE));	
	}
	
	public function destructionComplete():Void{
		_grid.lookForSolutions();
		_state = GRAVITY;
		dispatchEvent(new Event(GameCore.UPDATE));
	}
	
	//GETTERS && SETTERS
	
	public function getRules():GameRules { return(_rules); }
	public function getGameGrid():GameGrid { return(_grid); }
	public function getDistribution():Distribution { return(_distribution); }
	public function getActivePair():ActivePair { return(_activePair);}
	public function getGameState():GameState { return(_state); }
}