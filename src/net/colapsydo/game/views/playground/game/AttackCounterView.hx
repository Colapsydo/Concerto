package net.colapsydo.game.views.playground.game;

import net.colapsydo.game.logic.gameCore.ScoringSystem;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class AttackCounterView extends Sprite
{
	var _scoreSystem:ScoringSystem;
	
	var _targetValue:Float;
	var _actualValue:Float;
	
	var _background:Shape;
	var _step:Shape;
	var _mask:Shape;
	var _level:Shape;
	
	public function new(score:ScoringSystem) {
		super();
		_scoreSystem = score;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_background = new Shape();
		_background.graphics.beginFill(0x9999EF);
		_background.graphics.drawRoundRect(0, 0, 30, 200, 20, 20);
		_background.graphics.endFill();
		addChild(_background);
		
		_mask = new Shape();
		_mask.graphics.beginFill(0xFF0000);
		_mask.graphics.drawRoundRect(5, 10, 20, 180, 20, 20);
		_mask.graphics.endFill();
		addChild(_mask);
		
		_level = new Shape();
		_level.graphics.beginFill(0x2345EF);
		_level.graphics.drawRect(0, 0, 30, -180);
		_level.graphics.endFill();
		addChild(_level);
		_level.y = 190;
		_level.mask = _mask;
		
		_step = new Shape();
		_step.graphics.lineStyle(2, 0);
		for (i in 1...6) {
			_step.graphics.moveTo(2, 10+i * 30);
			_step.graphics.lineTo(28, 10+i * 30);
		}
		addChild(_step);
		
		_actualValue = 0;
		_level.scaleY = _actualValue;
	}
	
	//HANDLERS
	
	private function rescaleHandler(e:Event):Void {
		var diff = _targetValue > 1 ? 1 - _actualValue : _targetValue-_actualValue;
		_actualValue += diff * .1;
		diff *= diff > 0 ? 1 : -1;
		if (diff < 0.01) {
			if (_targetValue > 1) {
				_actualValue = 0 ;
				_targetValue -= 1;
				//Start Update Level Animation
			}else {
				_actualValue = _targetValue;
				removeEventListener(Event.ENTER_FRAME, rescaleHandler);
			}
		}
		_level.scaleY = _actualValue;
	}
	
	//PUBLIC FUNCTIONS
	
	public function updateCounter() {
		_targetValue = _scoreSystem.getAttackPos();
		addEventListener(Event.ENTER_FRAME, rescaleHandler);
	}
	
}