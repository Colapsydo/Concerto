package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.gameCore.GameCore;
import net.colapsydo.game.logic.gameCore.GameGrid;
import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 */
class GridView extends Sprite
{
	var _gameCore:GameCore;
	var _gridData:GameGrid;
	var _grid:Vector<Int>;
	var _activePair:ActivePair;
	
	var _noteballPool:NoteballPool;
	var _gridNote:Vector<Vector<NoteBall>>;
	var _gravityNum:Int;
	
	var _background:Shape;
	var _noteBallsContainer:Sprite;
	var _activePairView:ActivePairView;
	var _mask:Shape;
	
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
		_activePair = _gameCore.getActivePair();
		
		if (_step == 0) {
			_step = Std.int(stage.stageHeight * .95 / 15);
			NoteBall.setSize(GridView.getStep());
		}
		
		_noteballPool = new NoteballPool();
		
		_gridNote = new Vector<Vector<NoteBall>>();
		var column:Vector<NoteBall>;
		for (i in 0...6) {
			column =  new Vector<NoteBall>();
			_gridNote.push(column);
		}
		
		_background = new Shape();
		_background.graphics.beginFill(0xefefef);
		_background.graphics.drawRect(0, 0, 8 * _step, 15 * _step);
		_background.graphics.beginFill(0x555555);
		_background.graphics.drawRect(0, 0, _step, 14 * _step);
		_background.graphics.drawRect(7*_step, 0, _step, 14 * _step);
		_background.graphics.drawRect(0, 14 * _step, 8 * _step, _step);
		_background.graphics.endFill();
		_background.graphics.lineStyle(1, 0);
		for (i in 0...15) {
			if (i < 9) {
				_background.graphics.moveTo(i * _step, 0);
				_background.graphics.lineTo(i * _step, 15*_step);
			}
			_background.graphics.moveTo(0, i*_step);
			_background.graphics.lineTo(8 * _step, i*_step);
		}
		_background.graphics.lineStyle(3, 0xFF0000);
		_background.graphics.moveTo(0, 2*_step);
		_background.graphics.lineTo(8 * _step, 2*_step);
		addChild(_background);
		
		_noteBallsContainer = new Sprite();
		addChild(_noteBallsContainer);
		_noteBallsContainer.addEventListener(NoteBall.LANDED, landedHandler, true);
		_noteBallsContainer.addEventListener(NoteBall.BOUNCED, bouncedHandler, true);
		
		_mask = new Shape();
		_mask.graphics.beginFill(0xFFFFFF);
		_mask.graphics.drawRect(_step, 0, 6 * _step, 14 * _step);
		_mask.graphics.endFill();
		addChild(_mask);
		
		_activePairView = new ActivePairView(_activePair);
		addChild(_activePairView);
		_activePairView.mask = _mask;
		_activePairView.addEventListener(ActivePair.PLAYED, playedHandler);
	}
	
	//HANDLERS
	
	private function playedHandler(e:Event):Void {
		//insert master
		addNoteToGridView(_activePair.getMasterNote(), _activePair.getMasterPosX(), _activePair.getMasterFinalPos(), _activePair.getMasterPosY());
		var slavePosY:Float;
		switch(_activePair.getSlavePos()) {
			case LEFT, RIGHT:
				slavePosY = _activePair.getMasterPosY();
			case TOP:
				slavePosY = _activePair.getMasterPosY()+1;
			case BOTTOM:
				slavePosY = _activePair.getMasterPosY()-1;
		}
		addNoteToGridView(_activePair.getSlaveNote(), _activePair.getSlavePosX(), _activePair.getSlaveFinalPos(), slavePosY);
	}
	
	private function landedHandler(e:Event):Void {
		if (Std.is(e.target, NoteBall) == true) {
			cast(e.target, NoteBall).changeState(BOUNCING);
			//if indexY>1 bounce under if under are idle
		}
	}
	
	private function bouncedHandler(e:Event):Void {
		_gravityNum--;
		trace(_gravityNum);
		if (_gravityNum == 0) {
			_gameCore.allLanded();
		}
	}
	
	//PRIVATE FUNCTION
	
	function addNoteToGridView(type:Int, indexX:Int, indexY:Int, absY:Float):Void {
		var noteBall:NoteBall = _noteballPool.getNoteball();
		_noteBallsContainer.addChild(noteBall);
		noteBall.convert(type,true);
		noteBall.setIndexX(indexX);
		noteBall.setIndexY(indexY);
		noteBall.setPosY(absY);
		_gridNote[indexX - 1].push(noteBall);
		noteBall.changeState(FALLING);
		_gravityNum++;
	}
	
	//use of noteballPool
		//var noteball:NoteBall = _noteballPool.getNoteball();
		//noteball.convert(2);
		//_gridNote[0].push(noteball);
		//_noteballPool.discardNoteball(_gridNote[0].splice(0, 1)[0]);
	
	//PUBLIC FUNCTIONS
	
	public function newTurn() {
		_activePairView.newPair();
	}
	
	public function update() {
		_activePairView.update();
	}
	
	//GETTERS && SETTERS
	
	static public function getStep():Int { return(_step);}
	
	
	
	
}