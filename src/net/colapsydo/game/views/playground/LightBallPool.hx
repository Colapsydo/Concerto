package net.colapsydo.game.views.playground;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 */
class LightBallPool
{
	var _pool:Vector<LightBall>;
	var _used:Int;
	
	
	public function new() {
		init();
	}
	
	function init() {
		_pool = new Vector<LightBall>();
		var light:LightBall;
		for (i in 0...20) {
			light = new LightBall();
			_pool.push(light);
		}
	}
	
	//PUBLIC FUNCTIONS
	
	public function getLightBall():LightBall {
		if (_used >= _pool.length) {
			var light:LightBall = new LightBall();
			_pool.push(light);
		}		
		_used++;
		return(_pool[_used-1]);
	}
	
	public function discardLightBall(light:LightBall):Void {
		_pool.splice(_pool.lastIndexOf(light), 1);
		_pool.push(light);
		_used--;
	}
	
	public function getUsed():Int { return(_used); }
	
}