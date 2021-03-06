package net.colapsydo.game.views.playground.game;

import net.colapsydo.game.logic.gameCore.GameCore;
import net.colapsydo.game.logic.gameCore.GameGrid;
import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Vector;
import net.colapsydo.game.views.playground.game.NoteBall.NoteState;
import net.colapsydo.game.logic.Playground;

/**
 * ...
 * @author Colapsydo
 */
class GridView extends Sprite
{
	
	var _gameCore:GameCore;
	var _gridData:GameGrid;
	var _gridHeight:Int;
	var _grid:Vector<Int>;
	var _activePair:ActivePair;
	var _solutions:Vector<Vector<Int>>;
	var _blocks:Vector<Int>;
	
	var _noteballPool:NoteballPool;
	var _lightBallPool:LightBallPool;
	var _gridNote:Vector<Vector<NoteBall>>;
	var _gravityNum:Int;
	var _destructionNum:Int;
	
	var _background:Shape;
	var _noteBallsContainer:Sprite;
	var _activePairView:ActivePairView;
	var _mask:Shape;
	var _lightBallsContainer:Sprite;
	
	var _reading:Bool;

	var _cleanFunction:Dynamic;
	
	static var _step:Int;
	
	public function new(gameCore:GameCore) {
		super();
		_gameCore = gameCore;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_gridData = _gameCore.getGameGrid();
		_grid = _gridData.getGrid();
		_gridHeight = _gridData.getGridHeight()-1;
		_activePair = _gameCore.getActivePair();
		
		if (_step == 0) {
			//_step = Std.int(stage.stageHeight * .95 / _gridHeight);
			_step = 40;
			//_step = Std.int(stage.stageHeight * .95 / _gridHeight);
			NoteBall.setSize(GridView.getStep());
			NoteBall.setGridSize(_gridHeight);
		}
		
		_noteballPool = new NoteballPool();
		
		_gridNote = new Vector<Vector<NoteBall>>();
		var column:Vector<NoteBall>;
		for (i in 0...6) {
			column =  new Vector<NoteBall>();
			_gridNote.push(column);
		}
		
		_background = new Shape();
		_background.graphics.beginFill(0xEFEFEF);
		_background.graphics.drawRect(0, 0, 8 * _step, _gridHeight * _step);
		_background.graphics.beginFill(0x555555);
		_background.graphics.drawRect(0, 0, _step, (_gridHeight-1) * _step);
		_background.graphics.drawRect(7*_step, 0, _step, (_gridHeight-1) * _step);
		_background.graphics.drawRect(0, (_gridHeight-1) * _step, 8 * _step, _step);
		_background.graphics.endFill();
		_background.graphics.lineStyle(1, 0);
		//for (i in 0...15) {
			//if (i < 9) {
				//_background.graphics.moveTo(i * _step, 0);
				//_background.graphics.lineTo(i * _step, _gridHeight*_step);
			//}
			//_background.graphics.moveTo(0, i*_step);
			//_background.graphics.lineTo(8 * _step, i*_step);
		//}
		_background.graphics.lineStyle(3, 0xFF0000);
		_background.graphics.moveTo(0, 2*_step);
		_background.graphics.lineTo(8 * _step, 2*_step);
		addChild(_background);
		
		_mask = new Shape();
		_mask.graphics.beginFill(0xFF0000);
		_mask.graphics.drawRect(_step, 0, 6 * _step, (_gridHeight-1) * _step);
		_mask.graphics.endFill();
		addChild(_mask);
		
		_noteBallsContainer = new Sprite();
		addChild(_noteBallsContainer);
		_noteBallsContainer.mask = _mask;
		_noteBallsContainer.addEventListener(NoteBall.LANDED, landedHandler, true);
		_noteBallsContainer.addEventListener(NoteBall.BOUNCED, bouncedHandler, true);
		_noteBallsContainer.addEventListener(NoteBall.DESTROYED, destructionHandler, true);		
		_noteBallsContainer.addEventListener(NoteBall.TRANSFORMED, transformationHandler, true);		
		
		_activePairView = new ActivePairView(_activePair);
		addChild(_activePairView);
		_activePairView.mask = _mask;
		_activePairView.addEventListener(ActivePair.PLAYED, playedHandler);
		_activePair.addEventListener(ActivePair.FINALPOSCHANGE, finalPosChangeHandler);
		
		if (_gameCore.getRules().getEvolution() == true) {
			_cleanFunction = cleanEvo;
			_lightBallPool = new LightBallPool();
			_lightBallsContainer = new Sprite();
			addChild(_lightBallsContainer);
			_lightBallsContainer.addEventListener(LightBall.ARRIVAL, arrivalHandler, true);
			LightBall.setSize(GridView.getStep());
		}else {
			_cleanFunction = cleanPuy;
		}
		
		readGrid();
	}
	
	//HANDLERS
	
	private function playedHandler(e:Event):Void {
		var slavePosY:Float;
		switch(_activePair.getSlavePos()) {
			case LEFT, RIGHT:
				slavePosY = _activePair.getMasterPosY();
			case TOP:
				slavePosY = _activePair.getMasterPosY()+1;
			case BOTTOM:
				slavePosY = _activePair.getMasterPosY()-1;
		}
		if (_activePair.getMasterFinalPos() < _activePair.getSlaveFinalPos()) {
			//insert master first
			addNoteToGridView(_activePair.getMasterNote(), _activePair.getMasterPosX(), _activePair.getMasterFinalPos(), _activePair.getMasterPosY(),_activePair.getDownVel());
			addNoteToGridView(_activePair.getSlaveNote(), _activePair.getSlavePosX(), _activePair.getSlaveFinalPos(), slavePosY,_activePair.getDownVel());
		}else {
			//insert slave first
			addNoteToGridView(_activePair.getSlaveNote(), _activePair.getSlavePosX(), _activePair.getSlaveFinalPos(), slavePosY,_activePair.getDownVel());
			addNoteToGridView(_activePair.getMasterNote(), _activePair.getMasterPosX(), _activePair.getMasterFinalPos(), _activePair.getMasterPosY(),_activePair.getDownVel());
		}
		gridIdle();	
	}
	
	private function finalPosChangeHandler(e:Event):Void {
		gridIdle();
		//check for solutions
		_solutions = _gridData.getSolutions();
		//light solutions notes
		var indexX:Int;
		var indexY:Int;
		for (i in 0..._solutions.length) {
			for (j in 0..._solutions[i].length) {
				indexX = _solutions[i][j];
				indexY = Std.int(indexX / 8)-1;
				indexX %= 8;
				indexX--;
				if (_gridNote[indexX].length > indexY) {
					_gridNote[indexX][indexY].changeState(BLINKING);
				}
			}
		}
	}
	
	private function landedHandler(e:Event):Void {
		if (Std.is(e.target, NoteBall) == true) {
			var noteball:NoteBall = cast(e.target, NoteBall);
			noteball.changeState(BOUNCING);
			var indexY:Int = noteball.getIndexY()-1;
			if (indexY > 0) {
				var vel:Float = noteball.getVel();
				var indexX:Int = noteball.getIndexX()-1;
				while (indexY>0 && vel > 0.15) {
					indexY--;
					vel *= .6;
					if (_gridNote[indexX][indexY].getState() == IDLE) {
						_gridNote[indexX][indexY].setVel(vel);
						_gridNote[indexX][indexY].changeState(BOUNCING);
						_gravityNum++;
					}					
				}
			}
		}
	}
	
	private function bouncedHandler(e:Event):Void {
		_gravityNum--;
		//trace(_gravityNum, " notes to fall");
		if (_gravityNum == 0) {
			if (_reading == false) {
				_gameCore.allLanded();
			}else {
				_reading = false;
			}
		}
	}
	
	private function destructionHandler(e:Event):Void {
		//use of noteballPool
		var noteball:NoteBall = cast(e.target, NoteBall);
		
		//creation of lightballs
		if (noteball.getTarget() != null) {
			var type:Int = noteball.getType();
			var light:LightBall;
			for (i in 0...type) {
				light = _lightBallPool.getLightBall();
				light.convert(type, noteball.x, noteball.y, noteball.getTarget());
				_lightBallsContainer.addChild(light);
			}
		}		
		
		var indexX:Int = noteball.getIndexX()-1;
		var indexY:Int = _gridNote[indexX].lastIndexOf(noteball);
		_noteBallsContainer.removeChild(noteball);
		_noteballPool.discardNoteball(_gridNote[indexX].splice(indexY, 1)[0]);
		
		_destructionNum--;
		if (_destructionNum == 0) {
			_gameCore.destructionComplete();
		}
	}
	
	private function transformationHandler(e:Event):Void {
		_destructionNum--;
		if (_destructionNum == 0) {
			_gameCore.destructionComplete();
		}
	}
	
	private function arrivalHandler(e:Event):Void {
		var lightBall:LightBall = cast(e.target, LightBall);
		_lightBallPool.discardLightBall(lightBall);
		_lightBallsContainer.removeChild(lightBall);
	}
	
	//PRIVATE FUNCTION
	
	function cleanEvo():Void {
		var indexX:Int;
		var indexY:Int;
		var targetX:Int;
		var targetY:Int;
		for (i in 0..._solutions.length) {
			//TRANSFORMATION WITHOUT ANIMATION
			var value:Int = _gridData.getValue(_solutions[i][0]);
			indexX = _solutions[i][0];
			indexY = Std.int(indexX / 8)-1;
			indexX %= 8;
			indexX--;
			if (value != 0) {
				targetX = indexX;
				targetY = indexY;
				_gridNote[indexX][indexY].changeState(TRANSFORMING);
				_gridNote[indexX][indexY].setType(value);
				_destructionNum++;
			}else {
				targetX = targetY = -1;
				_gridNote[indexX][indexY].setTarget(null); 
				_gridNote[indexX][indexY].changeState(EXPLODING);
				_destructionNum++;
			}
						
			for (j in 1..._solutions[i].length) {
				indexX = _solutions[i][j];
				indexY = Std.int(indexX / 8)-1;
				indexX %= 8;
				indexX--;
				if (targetX <0) { 
					_gridNote[indexX][indexY].setTarget(null); 
				}else {
					_gridNote[indexX][indexY].setTarget(_gridNote[targetX][targetY]); 
				}
				_gridNote[indexX][indexY].changeState(EXPLODING);
				_destructionNum++;
			}
		}
		
		for (i in 0..._blocks.length) {
			indexX = _blocks[i];
			var value:Int = _gridData.getValue(indexX);
			indexY = Std.int(indexX / 8)-1;
			indexX %= 8;
			indexX--;
			if (value != 0) {
				targetX = indexX;
				targetY = indexY;
				_gridNote[indexX][indexY].changeState(TRANSFORMING);
				_gridNote[indexX][indexY].setType(value);
				_destructionNum++;
				_gridNote[indexX][indexY].incoming();
				_gridNote[indexX][indexY].arrived();
			}else {
				_gridNote[indexX][indexY].setTarget(null); 
				_gridNote[indexX][indexY].changeState(EXPLODING);
				_destructionNum++;
			}
		}
	}
	
	function cleanPuy():Void {
		var indexX:Int;
		var indexY:Int;
		for (i in 0..._solutions.length) {
			for (j in 0..._solutions[i].length) {
				indexX = _solutions[i][j];
				indexY = Std.int(indexX / 8)-1;
				indexX %= 8;
				indexX--;
				_gridNote[indexX][indexY].changeState(EXPLODING);
				_destructionNum++;
			}
		}
	}
	
	function readGrid():Void {
		_reading = true;
		for (i in 8..._grid.length) {
			if (i % 8 > 0 && i % 8 < 7) {
				if (_grid[i] != 0) {
					addNoteToGridView(_grid[i], i % 8, Std.int(i / 8), Std.int(i / 8), 0);
				}
			}
		}
	}
	
	function addNoteToGridView(type:Int, indexX:Int, indexY:Int, absY:Float, vel:Float):Void {
		var noteBall:NoteBall = _noteballPool.getNoteball();
		noteBall.alpha = 1;
		_noteBallsContainer.addChild(noteBall);
		noteBall.convert(type,true);
		noteBall.setIndexX(indexX);
		noteBall.setIndexY(indexY);
		noteBall.setPosY(absY);
		noteBall.setVel(vel);
		_gridNote[indexX - 1].push(noteBall);
		
		noteBall.changeState(FALLING);
		_gravityNum++;
	}
	
	function gridIdle():Void{		
		for (i in 0..._gridNote.length) {
			for (j in 0..._gridNote[i].length) {
				_gridNote[i][j].changeState(IDLE);
			}
		}
	}
	
	//PUBLIC FUNCTIONS
	
	public function newTurn() {
		_activePairView.newPair();
	}
	
	public function update() {
		_activePairView.update();
	}
	
	public function applyGravity():Void {
		for (i in 0..._gridNote.length) {
			for (j in 0..._gridNote[i].length) {
				if (_gridNote[i][j].getIndexY() != j + 1) { //if noteball not at its position
					_gridNote[i][j].setIndexY(j + 1);
					_gridNote[i][j].changeState(FALLING);
					_gravityNum++;
				}
			}
		}
		if (_gravityNum == 0) {
			_gameCore.allLanded();
		}
	}
	
	public function removeSolutions():Void{
		_solutions = _gridData.getSolutions();
		_blocks = _gridData.getBlocks();
		_cleanFunction();
	}
	
	//GETTERS && SETTERS
	
	static public function getStep():Int { return(_step);}
	
	
}