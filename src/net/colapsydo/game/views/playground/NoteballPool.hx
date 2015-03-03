package net.colapsydo.game.views.playground;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 */
class NoteballPool
{
	var _pool:Vector<NoteBall>;
	var _used:Int;
	
	public function new() {
		init();
	}
	
	function init() {
		_pool = new Vector<NoteBall>();
		var note:NoteBall;
		for (i in 0...10) {
			note = new NoteBall(1);
			_pool.push(note);
		}
		//trace("init");
		//readpool();
	}
	
	public function readpool():Void {
		var result:String = "";
		for (i in 0..._pool.length) {
			result+=_pool[i].getType();
		}
		trace(result);
	}
	
	public function getNoteball():NoteBall {
		if (_used >= _pool.length) {
			var note = new NoteBall(1);
			_pool.push(note);
		}
		
		_used++;
		return(_pool[_used-1]);
	}
	
	public function discardNoteball(note:NoteBall):Void {
		//trace("used before",_used);
		//readpool();
		_pool.splice(_pool.lastIndexOf(note), 1);
		_pool.push(note);
		_used--;
		//trace("used after",_used);
		//readpool();
	}
	
}