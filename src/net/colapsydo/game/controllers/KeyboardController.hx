package net.colapsydo.game.controllers;

import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Colapsydo
 */
class KeyboardController
{
	var _activePair:ActivePair;
	var _left:Bool;
	var _right:Bool;
	var _down:Bool;
	var _rotationT:Bool;
	var _rotationAT:Bool;
	var _sideTimer:Int;
	
	
	public function new(activePair:ActivePair) {
		_activePair = activePair;
	}
	
	public function keyboardDown(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				if (_left == false) {
					_left = true;
					_sideTimer = 15;
					_activePair.horizontalMove( -1 );
				}
				
			case 39: //right
				if (_right == false) {
					_right = true;
					_sideTimer = 15;
					_activePair.horizontalMove( 1 );
				}
				
			case 40: //down
				if (_down == false) {
					_down = true;
					_activePair.upSpeed(_down);
				}
				
			case 87: //w
				if (_rotationT == false) {
					_rotationT = true;
					_activePair.rotate(true);
				}
			case 88: //x
				if (_rotationAT == false) {
					_rotationAT = true;
					_activePair.rotate(false);
				}
			default:
		}
	}
	
	public function keyboardUp(e:KeyboardEvent):Void {
		switch(Std.int(e.keyCode)) {
			case 37: //left
				_left = false;
			case 39: //right
				_right = false;
			case 40: //down
				_down = false;
				_activePair.upSpeed(_down);
			case 87: //w
				_rotationT = false;
			case 88: //x
				_rotationAT = false;
			default:
		}
	}
	
	public function update():Void {
		if (_left == true || _right==true) {
			if (--_sideTimer == 0) {
				_sideTimer = 2;
				if (_left == true) { _activePair.horizontalMove( -1 ); }
				if (_right == true) { _activePair.horizontalMove( 1 ); }
			}
		}
	}
	
}