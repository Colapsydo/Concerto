package net.colapsydo.game.views.playground;

import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class DistributionPair extends Sprite
{
	var _noteball1:NoteBall;
	var _noteball2:NoteBall;
	
	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		_noteball1 = new NoteBall(1);
		addChild(_noteball1);
		_noteball1.y = -_noteball1.height * .5;
		
		_noteball2 = new NoteBall(1);
		addChild(_noteball2);
		_noteball2.y = _noteball2.height * .5;
	}
	
	public function convertPair(masterType:Int, slaveType:Int):Void {
		_noteball2.convert(masterType);
		_noteball1.convert(slaveType);
	}
	
	public function getMasterType():Int { return(_noteball2.getType());}
	public function getSlaveType():Int { return(_noteball1.getType());}	
}