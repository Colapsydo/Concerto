package net.colapsydo.game.controllers;

import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Colapsydo
 */
class KeyboardController extends Controller
{
	var _activePair:ActivePair;
	var _left:Bool;
	var _right:Bool;
	var _down:Bool;
	var _rotationT:Bool;
	var _rotationAT:Bool;
	var _sideTimer:Int;
	var _working:Bool;
	var _rotTtimer:Float;
	var _rotATtimer:Float;
	
	
	public function new(activePair:ActivePair) {
		super();
		_activePair = activePair;
	}
	
	public override function keyboardDown(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				if (_left == false) {
					_left = true;
					_sideTimer = 10;
					if (_working == true) { 
						_activePair.horizontalMove( -1 ); 
						_activePair.upSpeed(false);
					}
				}
				
			case 39: //right
				if (_right == false) {
					_right = true;
					_sideTimer = 10;
					if (_working == true) { 
						_activePair.horizontalMove( 1 ); 
						_activePair.upSpeed(false);
					}
				}
				
			case 40: //down
				if (_down == false) {
					_down = true;
					if (_working == true) { _activePair.upSpeed(_down); }
				}
				
			case 87: //w
				if (_rotationT == false) {
					_rotationT = true;
					if (_working == true) { 
						if (_rotTtimer < 15) {
							_activePair.rotate(true,true); 
						}else {
							_activePair.rotate(true);
							_rotTtimer = 0;
						}
					}
				}
			case 38,88: //x
				if (_rotationAT == false) {
					_rotationAT = true;
					if (_working == true) { 
						if (_rotATtimer < 15) {
							_activePair.rotate(false,true);  
						}else {
							_activePair.rotate(false);
							_rotATtimer = 0;
						}
					}
				}
			default:
		}
	}
	
	public override function keyboardUp(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				_left = false;
				_activePair.upSpeed(_down);
			case 39: //right
				_right = false;
				_activePair.upSpeed(_down);
			case 40: //down
				_down = false;
				_activePair.upSpeed(_down);
			case 87: //w
				_rotationT = false;				
			case 38,88: //x
				_rotationAT = false;
			default:
		}
	}
	
	public override function working(working:Bool) {
		_working = working;
	}
	
	public override function update():Void {
		_rotTtimer++;
		_rotATtimer++;
		if (_left == true || _right==true) {
			if (--_sideTimer == 0) {
				_sideTimer = 2;
				_activePair.upSpeed(_down);
				if (_left == true) { _activePair.horizontalMove( -1 ); }
				if (_right == true) { _activePair.horizontalMove( 1 ); }
			}
		}
	}
}