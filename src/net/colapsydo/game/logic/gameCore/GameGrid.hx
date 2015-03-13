package net.colapsydo.game.logic.gameCore;
import haxe.Constraints.Function;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * model of a game grid
 */
class GameGrid
{
	var _rules:GameRules;
	var _distribution:Distribution;
	
	var _grid:Vector<Int>;
	var _checked:Vector<Bool>;
	var _fusion:Vector<Int>;
	var _solutions:Vector<Vector<Int>>;
	var _firstEmptyCells:Vector<Int>;
	
	var _gridHeight:Int;
	var _cleanFunction:Dynamic;
	
	public function new(rules:GameRules, distribution:Distribution) {
		_rules = rules;
		_distribution = distribution;
		init();
	}
	
	function init():Void{
		//Set Clean function resp Gameplay option
		if (_rules.getEvolution() == true) {
			_cleanFunction = cleanEvo;
		}else {
			_cleanFunction = cleanPuy;
		}
		
		_gridHeight = _rules.getGridHeight();
		
		_grid = new Vector<Int>();
		for (i in 0..._gridHeight*8) {
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
		_firstEmptyCells[0] = _gridHeight-1;
		_firstEmptyCells[7] = _gridHeight-1;
		
		_checked = new Vector<Bool>();
		_checked.length = _grid.length;
		
		readGrid();
	}
	
	//PRIVATE FUNCTIONS
	
	function cleanEvo() {
		for (i in 0..._solutions.length) {
			_grid[_solutions[i][0]] = _distribution.transform(_grid[_solutions[i][0]]);
			for (j in 1..._solutions[i].length) {
				_grid[_solutions[i][j]]= 0;
			}
		}
	}
	
	function cleanPuy() {
		for (i in 0..._solutions.length) {
			for (j in 0..._solutions[i].length) {
				_grid[_solutions[i][j]]= 0;
			}
		}
	}
	
	function readGrid():Void {
		for (i in 0..._gridHeight) {
			var gridMin:Int = _gridHeight - 1;
			trace(_grid[(gridMin - i) * 8], _grid[(gridMin - i) * 8 + 1], _grid[(gridMin - i) * 8 + 2], _grid[(gridMin - i) * 8 + 3], _grid[(gridMin - i) * 8 + 4], _grid[(gridMin - i) * 8 + 5], _grid[(gridMin - i) * 8 + 6], _grid[(gridMin - i) * 8 + 7]);
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
			for (j in 1..._gridHeight) {
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
			for (j in 1..._gridHeight) {
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
		_cleanFunction();
		
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
	
	public function checkGameLimit():Bool {
		var start:Int = (_gridHeight - 3) * 8;
		for (i in 1...7) {
			if (_grid[start + i] != 0) {return(true);}
		}
		return(false);
	}
	
	//GETTERS && SETTERS
	
	public function getGrid():Vector<Int> { return(_grid); }
	public function getGridHeight():Int { return(_gridHeight);}
	public function getValue(index:Int):Int { return(_grid[index]); }
	public function getSolutions():Vector<Vector<Int>> { return(_solutions); }
	public function getFirstEmptyCell(col:Int):Int { return(_firstEmptyCells[col]); }
	
}