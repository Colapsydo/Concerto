package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.gameCore.Distribution;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class DistributionView extends Sprite
{
	var _player:Int;
	var _distribution:Distribution;
	
	var _pairSprite:Sprite;
	var _pair1:DistributionPair;
	var _pair2:DistributionPair;
	var _pair3:DistributionPair;
	
	var _mask:Shape;
	
	static public inline var SWITCHED:String = "switched";
	
	public function new(distribution:Distribution, player:Int) {
		super();
		_distribution = distribution;
		_player = player;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_pairSprite = new Sprite();
		_pairSprite.graphics.beginFill(0x9999EF);
		_pairSprite.graphics.drawRect(0, 0, 80, 200);
		_pairSprite.graphics.endFill();
		addChild(_pairSprite);
		
		_mask = new Shape();
		_mask.graphics.beginFill(0xFFFFFF);
		_mask.graphics.drawRect(0, 0, 80, 200);
		_mask.graphics.endFill();
		addChild(_mask);
		
		_pairSprite.mask = _mask;
		
		_pair1 = new DistributionPair();
		_pairSprite.addChild(_pair1);
		_pair2 = new DistributionPair();
		_pairSprite.addChild(_pair2);
		_pair3 = new DistributionPair();
		_pairSprite.addChild(_pair3);
		moveback();
		
		_pair1.convertPair(_distribution.getNote(0), _distribution.getNote(1));
		_pair2.convertPair(_distribution.getNote(2), _distribution.getNote(3));
	}
	
	//HANDLERS
	
	private function nextHandler(e:Event):Void {
		_pair1.x -=2;
		_pair1.y -= 10;
		_pair2.x -= 2; // from 50 to 30 /20
		_pair2.y -= 10; // from 150 to 50 /100
		_pair3.x -= 2; 
		_pair3.y -= 10;
		
		if (_pair2.y <= 50) {
			_pair1.convertPair(_pair2.getMasterType(), _pair2.getSlaveType());
			_pair2.convertPair(_pair3.getMasterType(), _pair3.getSlaveType());
			moveback();
			removeEventListener(Event.ENTER_FRAME, nextHandler);
			dispatchEvent(new Event(DistributionView.SWITCHED));
		}
	}
	
	//PRIVATE FUNCTIONS
	
	inline function moveback():Void {
		_pair1.x = 30;
		_pair1.y = 50;
		_pair2.x = 50;
		_pair2.y = 150;
		_pair3.x = 70;
		_pair3.y = 250;
	}
	
	//PUBLIC FUNCTIONS
	
	public function next():Void {
		_pair3.convertPair(_distribution.getNote(2), _distribution.getNote(3));
		addEventListener(Event.ENTER_FRAME, nextHandler);
	}
	
}