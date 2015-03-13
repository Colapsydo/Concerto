package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.gameCore.GameCore;
import net.colapsydo.game.logic.gameCore.GameGrid;
import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Vector;
import net.colapsydo.game.views.playground.NoteBall.NoteState;
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
	
	var _noteballPool:NoteballPool;
	var _gridNote:Vector<Vector<NoteBall>>;
	var _gravityNum:Int;
	var _destructionNum:Int;
	
	var _background:Shape;
	var _noteBallsContainer:Sprite;
	var _activePairView:ActivePairView;
	var _mask:Shape;
	
	var _cleanFunction:Dynamic;
	
	static var _step:Int;
	
	public function new(gameCore:GameCore) {
		super();
		_gameCore = gameCore;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		if (_gameCore.getRules().getEvolution() == true) {
			_cleanFunction = cleanEvo;
		}else {
			_cleanFunction = cleanPuy;
		}
		
		_gridData = _gameCore.getGameGrid();
		_grid = _gridData.getGrid();
		_gridHeight = _gridData.getGridHeight()-1;
		_activePair = _gameCore.getActivePair();
		
		if (_step == 0) {
			_step = Std.int(stage.stageHeight * .95 / _gridHeight);
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
		
		_activePairView = new ActivePairView(_activePair);
		addChild(_activePairView);
		_activePairView.mask = _mask;
		_activePairView.addEventListener(ActivePair.PLAYED, playedHandler);
		_activePair.addEventListener(ActivePair.FINALPOSCHANGE, finalPosChangeHandler);
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
			_gameCore.allLanded();
		}
	}
	
	private function destructionHandler(e:Event):Void {
		//use of noteballPool
		var noteball:NoteBall = cast(e.target, NoteBall);
		var indexX:Int = noteball.getIndexX()-1;
		var indexY:Int = _gridNote[indexX].lastIndexOf(noteball);
		_noteBallsContainer.removeChild(noteball);
		_noteballPool.discardNoteball(_gridNote[indexX].splice(indexY, 1)[0]);
		
		_destructionNum--;
		
		if (_destructionNum == 0) {
			_gameCore.destructionComplete();
		}
	}
	
	//PRIVATE FUNCTION
	
	function cleanEvo():Void {
		var indexX:Int;
		var indexY:Int;
		//var targetX:Int; //for transformation animations
		//var targetY:Int;
		for (i in 0..._solutions.length) {
			//TRANSFORMATION WITHOUT ANIMATION
			var value:Int = _gridData.getValue(_solutions[i][0]);
			indexX = _solutions[i][0];
			indexY = Std.int(indexX / 8)-1;
			indexX %= 8;
			indexX--;
			if (value != 0) {
				//targetX = _gridNote[indexX][indexY].getIndexX();
				//targetY = _gridNote[indexX][indexY].getIndexY();
				//_gridNote[indexX][indexY].changeState(TRANSFORMING);
				_gridNote[indexX][indexY].convert(value, true);
			}else {
				_gridNote[indexX][indexY].changeState(EXPLODING);
				_destructionNum++;
			}
						
			for (j in 1..._solutions[i].length) {
				indexX = _solutions[i][j];
				indexY = Std.int(indexX / 8)-1;
				indexX %= 8;
				indexX--;
				//_gridNote[indexX][indexY].setTarget(targetX, targetY);
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
		_cleanFunction();
	}
	
	//GETTERS && SETTERS
	
	static public function getStep():Int { return(_step);}
	
	
}