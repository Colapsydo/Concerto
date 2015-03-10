package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.gameCore.ActivePair;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class ActivePairView extends Sprite
{
	var _activePair:ActivePair;
	
	var _pairSprite:Sprite;
	var _masterNote:NoteBall;
	var _slaveContainer:Sprite;
	var _slaveNote:NoteBall;
	
	var _targetRotation:Int;
	var _actualRotation:Int;
	var _rotationInProgress:Bool;
	var _trigo:Int;
	
	var _masterPreview:NotePreview;
	var _slavePreview:NotePreview;
	
	var _ray:Int;
	
	public function new(activePair:ActivePair) {
		super();
		_activePair = activePair;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_masterPreview = new NotePreview(1);
		addChild(_masterPreview);
		_slavePreview = new NotePreview(1);
		addChild(_slavePreview);
		
		_pairSprite = new Sprite();
		addChild(_pairSprite);
		
		_ray = GridView.getStep();
		
		_masterNote = new NoteBall(1);
		_pairSprite.addChild(_masterNote);
		_masterNote.startBlinking();
		_slaveContainer = new Sprite();
		_pairSprite.addChild(_slaveContainer);
		_slaveNote = new NoteBall(1);
		_slaveContainer.addChild(_slaveNote);
		_slaveNote.x = _ray;
		
		_masterPreview.visible = false;
		_slavePreview.visible = false;
		_pairSprite.visible = false;
		
		_activePair.addEventListener(ActivePair.ROTATION, startRotationHandler);
		_activePair.addEventListener(ActivePair.FINALPOSCHANGE, finalPosChangeHandler);
		_activePair.addEventListener(ActivePair.PLAYED, playedHandler);
	}
	
	//HANDLERS
	
	private function finalPosChangeHandler(e:Event):Void {
		previewPosChange();
	}
	
	private function playedHandler(e:Event):Void {
		_masterPreview.visible = false;
		_slavePreview.visible = false;
		_pairSprite.visible = false;
		dispatchEvent(e);
	}
	
	private function startRotationHandler(e:Event):Void {
		_trigo = _activePair.getTrigo();
		_targetRotation +=  _trigo * 90;
		
		if (_rotationInProgress == false) {
			_rotationInProgress = true;
			addEventListener(Event.ENTER_FRAME, rotationHandler);
		}
		
		if (_actualRotation == _targetRotation) {
			_targetRotation = _actualRotation = _actualRotation % 360;
			_rotationInProgress = false;
			removeEventListener(Event.ENTER_FRAME, rotationHandler);
		}
	}
	
	private function rotationHandler(e:Event):Void {
		//_actualRotation += _trigo < 0? -15:15;
		_actualRotation += _trigo*15;
		if (_targetRotation ==_actualRotation) {
			_targetRotation = _actualRotation = _actualRotation % 360;
			_rotationInProgress = false;
			removeEventListener(Event.ENTER_FRAME, rotationHandler);
		}
		_slaveContainer.rotation = _actualRotation;
		_slaveNote.rotation = -_slaveContainer.rotation;
	}
	
	function previewPosChange() {
		_masterPreview.x = (_activePair.getMasterPosX()+.5) * _ray;
		_masterPreview.y = (14.5 - _activePair.getMasterFinalPos()) * _ray;
		
		switch(_activePair.getSlavePos()) {
			case LEFT:
				_slavePreview.x = _masterPreview.x - _ray;
			case RIGHT:
				_slavePreview.x = _masterPreview.x + _ray;
			case TOP, BOTTOM:
				_slavePreview.x = _masterPreview.x ;
		}
		_slavePreview.y = (14.5 - _activePair.getSlaveFinalPos()) * _ray;
	}
	
	//PUBLIC FUNCTIONS
	
	public function newPair():Void {
		_masterPreview.visible = true;
		_slavePreview.visible = true;
		_pairSprite.visible = true;
		
		var type:Int = _activePair.getMasterNote();
		_masterNote.convert(type);
		_masterPreview.convert(type);
		type = _activePair.getSlaveNote();
		_slaveNote.convert(type);
		_slavePreview.convert(type);
		
		_slaveContainer.rotation = 270;
		_targetRotation = _actualRotation = Std.int(_slaveContainer.rotation);
		_slaveNote.rotation = -_slaveContainer.rotation;
		_pairSprite.x = (_activePair.getMasterPosX()+.5) * _ray;
		_pairSprite.y = (15 - _activePair.getMasterPosY()) * _ray;
		
		previewPosChange();
	}
	
	public function update():Void {
		_pairSprite.x = (_activePair.getMasterPosX()+.5) * _ray;
		_pairSprite.y = (15 - _activePair.getMasterPosY()) * _ray;
		
		//if (_rotationInProgress == false && _activePair.getRotationOccured() == true) {
			////_actualRotation = Std.int(_slaveContainer.rotation);
			//_trigo = _activePair.getTrigo();
			//_targetRotation +=  _trigo * 90;
			//trace(_slaveContainer.rotation, _actualRotation, _targetRotation);
			//_rotationInProgress = true;
			//addEventListener(Event.ENTER_FRAME, rotationHandler);
		//}
	}
	
	//DISPOSE
	private function dispose():Void {
		//YOU HAVE TO KILL THE ENTER FRAME EVENTLISTENER FOR BLINKING
		_masterNote.stopBlinking();
	}
	
}