package net.colapsydo.game.logic.gameCore;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * model of a game grid
 */
class GameGrid
{
	var _grid:Vector<Int>;
	var _firstEmptyCells:Vector<Int>;
	
	public function new() {
		init();
	}
	
	function init():Void{
		_grid = new Vector<Int>();
		for (i in 0...128) {
			if (i % 8 == 0 || (i + 1) % 8 == 0 || i < 8) {
				_grid.push( -1);
			}else {
				_grid.push(0);
			}
		}
		
		_firstEmptyCells = new Vector<Int>();
		for (i in 0...8) {
			_firstEmptyCells.push(1);
		}
		
		readGrid();
	}
	
	//PRIVATE FUNCTIONS
	
	function readGrid():Void {
		for (i in 0...16) {
			trace(_grid[(15 - i) * 8], _grid[(15 - i) * 8 + 1], _grid[(15 - i) * 8 + 2], _grid[(15 - i) * 8 + 3], _grid[(15 - i) * 8 + 4], _grid[(15 - i) * 8 + 5], _grid[(15 - i) * 8 + 6], _grid[(15 - i) * 8 + 7]);
		}
	}
	
	//PUBLIC FUNCTIONS
	
	public function getLeftLimit(controlIndex:Int):Int{
		return(0);
	}
	
	public function getRightLimit(controlIndex:Int):Int{
		return(7);
	}
	
	//GETTERS && SETTERS
	
	public function getGrid():Vector<Int> { return(_grid); }
	public function getFirstEmptyCell(col:Int):Int { return(_firstEmptyCells[col]); }
	
	
}