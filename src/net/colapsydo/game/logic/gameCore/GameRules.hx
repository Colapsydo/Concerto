package net.colapsydo.game.logic.gameCore;

/**
 * ...
 * @author Colapsydo
 */
class GameRules
{
	var _evolution:Bool;
	var _gridHeight:Int;
	var _playerNum:Int;
	var _colorNumStart:Int;
	
	public function new() {
		init();
	}
	
	//PRIVATE FUNCTIONS
	
	function init() {
		_evolution = true;
		_gridHeight = 16;
		_colorNumStart = 3;
		_playerNum = 1;
	}
	
	//PUBLIC FUNCTIONS
	
	public function puyoGame(color:Int = 4, grid:Int = 16) {
		_evolution = false;
		_colorNumStart = color;
		_gridHeight = grid;
	}
	
	public function musicGame(color:Int = 3, grid:Int = 16) {
		_evolution = true;
		_colorNumStart = color;
		_gridHeight = grid;
	}
	
	//GETTERS && SETTERS
	
	public function getEvolution():Bool { return(_evolution); }
	public function getGridHeight():Int { return(_gridHeight); }
	public function getPlayerNum():Int { return(_playerNum); }
	public function getcolorNumStart():Int { return(_colorNumStart); }
	
	public function setEvolution (evolutionMode:Bool):Void {_evolution = evolutionMode;}
	public function setGridHeight (gridHeight:Int):Void {_gridHeight = gridHeight;}
	public function setPlayerNum (playerNum:Int):Void {_playerNum = playerNum;}
	public function setColorNumStart (colorNum:Int):Void {_colorNumStart = colorNum;}
}