package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.gameCore.GameCore;
import net.colapsydo.game.logic.gameCore.GameGrid;
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
	
	var _background:Shape;
	var _activePair:ActivePairView;
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
		
		if (_step == 0) {
			_step = Std.int(stage.stageHeight * .95 / 15);
			NoteBall.setSize(GridView.getStep());
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
		
		_mask = new Shape();
		_mask.graphics.beginFill(0xFFFFFF);
		_mask.graphics.drawRect(_step, 0, 6 * _step, 14 * _step);
		_mask.graphics.endFill();
		addChild(_mask);
		
		_activePair = new ActivePairView(_gameCore.getActivePair());
		addChild(_activePair);
		_activePair.mask = _mask;
	}
	
	//PUBLIC FUNCTIONS
	
	public function update() {
		_activePair.update();
	}
	
	//GETTERS && SETTERS
	
	static public function getStep():Int { return(_step);}
	
	
	
}