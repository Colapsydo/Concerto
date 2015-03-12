package net.colapsydo.game.logic.gameCore;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * model of a game grid
 */
class GameGrid
{
	var _distribution:Distribution;
	
	var _grid:Vector<Int>;
	var _checked:Vector<Bool>;
	var _fusion:Vector<Int>;
	var _solutions:Vector<Vector<Int>>;
	var _firstEmptyCells:Vector<Int>;
	
	public function new(distribution:Distribution) {
		_distribution = distribution;
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
		_firstEmptyCells[0] = 15;
		_firstEmptyCells[7] = 15;
		
		_checked = new Vector<Bool>();
		_checked.length = _grid.length;
		
		readGrid();
	}
	
	//PRIVATE FUNCTIONS
	
	function readGrid():Void {
		for (i in 0...16) {
			trace(_grid[(15 - i) * 8], _grid[(15 - i) * 8 + 1], _grid[(15 - i) * 8 + 2], _grid[(15 - i) * 8 + 3], _grid[(15 - i) * 8 + 4], _grid[(15 - i) * 8 + 5], _grid[(15 - i) * 8 + 6], _grid[(15 - i) * 8 + 7]);
		}
	}
	
	//Recurrence function of BFS undirected connectivity
	function searchGroup(index:Int, color:Int, group:Vector<Int>):Void {
		//set the node to explored
		_checked[index] = true;
		//add the node to the group
		group.push(index);
		//scan neighbours
		if (_grid[index - 1] == color && _checked[index - 1] == false) {
			searchGroup(index - 1, color, group); 
			//_fusion[index] += ;
		}
		if (_grid[index + 8] == color && _checked[index + 8] == false) {
			searchGroup(index + 8, color, group);
		}
		if (_grid[index + 1] == color && _checked[index + 1] == false) {
			searchGroup(index + 1, color, group);
		}
		if (_grid[index - 8] == color && _checked[index - 8] == false) {
			searchGroup(index - 8, color, group);
			
		}
	}
	
	function scanGrid():Void {
		//reset solutions
		_solutions = new Vector<Vector<Int>>();
		
		//reset node explored status
		_checked = new Vector<Bool>();
		_fusion = new Vector<Int>();
		_checked.length = _fusion.length = _grid.length;
		
		for (i in 8..._grid.length-8) {
			//if node not explored
			if (_checked[i] == false) {
				var color = _grid[i];
				var group = new Vector<Int>();
				//if cell is a noteball
				if (color > 0) {
					searchGroup(i, color, group);
					//if search group is valid set in solutions
					if (group.length > 3) {
						_solutions.push(group);
					}
				}else {
					_checked[i] = true;
				}
			}
		}
	}
	
	function applyGravity():Void{
		var stepper:Int;
		var index:Int; 
		for (i in 1...7) {
			stepper = 1;
			for (j in 1...16) {
				index = i + j * 8;
				if (_grid[index] != 0) {
					if (j != stepper) {
						gridSwap(index, i + stepper * 8);	
					}
					stepper++;
				}
			}
		}
	}
	
	function gridSwap(index1:Int, index2:Int):Void {
		var value1:Int = _grid[index1];
		var value2:Int = _grid[index2];
		_grid[index2] = value1;
		_grid[index1] = value2;
	}
	
	//PUBLIC FUNCTIONS
	
	public function defineEmptyCells():Void{
		for (i in 1...7) {
			for (j in 1...16) {
				if (_grid[j * 8 + i] == 0) {
					_firstEmptyCells[i] = j;
					break;
				}
			}
		}
	}
	
	public function preScan(index1:Int, color1:Int, index2:Int, color2:Int):Void {
		//reset solutions
		_solutions = new Vector<Vector<Int>>();
		
		//reset node explored status
		_checked = new Vector<Bool>();
		_checked.length = _grid.length;
		
		//in order to consider the case where a double notes make connection between two preexisting groups 
		//we need to change temporarily the value of the grid cells
		_grid[index1] = color1;
		_grid[index2] = color2;
		
		//if node not explored
		if (_checked[index1] == false) {
			var group = new Vector<Int>();
			searchGroup(index1, color1, group);
			//if search group is valid set in solutions
			if (group.length > 3) {
				_solutions.push(group);
			}
		}
		if (_checked[index2] == false) {
			var group = new Vector<Int>();
			searchGroup(index2, color2, group);
			//if search group is valid set in solutions
			if (group.length > 3) {
				_solutions.push(group);
			}
		}
		
		//reset the value of the grid cells
		_grid[index1] = 0;
		_grid[index2] = 0;
	}
	
	public function lookForSolutions():Void {
		applyGravity();
		scanGrid();
	}
	
	public function cleanSolutions():Void{
		//calculate Score here
		
		//scan solutions and remove them from grid
		for (i in 0..._solutions.length) {
			_grid[_solutions[i][0]] = _distribution.transform(_grid[_solutions[i][0]]);
			for (j in 1..._solutions[i].length) {
				_grid[_solutions[i][j]]= 0;
			}
		}
	}
	
	public function hasSolutions():Bool { return(_solutions.length > 0);}
	
	public function addNote(type:Int, posX:Int, posY:Int) {
		_grid[posY * 8 + posX] = type;
	}
	
	public function getLeftLimit(controlX:Int,controlY:Int):Int{
		for (i in 1...controlX) {
			if (_grid[controlY * 8 + (controlX - i)] != 0) {
				return(controlX - i);
			}
		}
		return(0);
	}
	
	public function getRightLimit(controlX:Int, controlY:Int):Int{
		for (i in controlX+1...7) {
			if (_grid[controlY * 8 + i] != 0) {
				return(i);
			}
		}
		return(7);
	}
	
	//GETTERS && SETTERS
	
	public function getGrid():Vector<Int> { return(_grid); }
	public function getValue(index:Int):Int { return(_grid[index]); }
	public function getSolutions():Vector<Vector<Int>> { return(_solutions); }
	public function getFirstEmptyCell(col:Int):Int { return(_firstEmptyCells[col]); }
	
}