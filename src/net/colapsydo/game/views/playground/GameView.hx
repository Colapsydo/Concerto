package net.colapsydo.game.views.playground;

import net.colapsydo.game.controllers.KeyboardController;
import net.colapsydo.game.logic.gameCore.GameCore;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Colapsydo
 */
class GameView extends Sprite
{
	var _gameCore:GameCore;
	var _controller:KeyboardController;
	
	var _grid:GridView;
	var _distribution:DistributionView;
	
	public function new(gameCore:GameCore) {
		super();
		_gameCore = gameCore;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_controller = new KeyboardController(_gameCore.getActivePair());
		
		_grid = new GridView(_gameCore);
		addChild(_grid);
		_grid.y = 20;
		
		_distribution = new DistributionView(_gameCore.getDistribution(), _gameCore.getPlayer());
		addChild(_distribution);
		_distribution.y = 20;
		
		if (_gameCore.getPlayer() == 0) {
			_grid.x = 20;
			_distribution.x = _grid.x + _grid.width + 10;
		}else {
			_distribution.x = 20;
			_grid.x = _distribution.x + _distribution.width + 10;			
		}
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		updateHandler();
		_gameCore.addEventListener(GameCore.UPDATE, updateHandler);
		
		_gameCore.startGame();
	}
	
	//HANDLERS
	
	private function updateHandler(e:Event=null):Void {
		switch(_gameCore.getGameState()) {
			case DISTRIBUTION:
				_distribution.next();
				_distribution.addEventListener(DistributionView.SWITCHED, distribHandler);
			case PLAY:
				_grid.newTurn();
				_controller.working(true);
				addEventListener(Event.ENTER_FRAME, playHandler);
			case GRAVITY:
				_controller.working(false);
				removeEventListener(Event.ENTER_FRAME, playHandler);
				_grid.applyGravity();
			case CHAIN:
				_grid.removeSolutions();
			case LOOSE:
			
		}
	}
	
	private function distribHandler(e:Event):Void {
		_distribution.addEventListener(DistributionView.SWITCHED, distribHandler);
		_gameCore.play();
	}
	
	private function playHandler(e:Event):Void {
		_grid.update();
		_controller.update();
	}
	
	private function keyDownHandler(e:KeyboardEvent):Void {
		_controller.keyboardDown(e);
	}
	
	private function keyUpHandler(e:KeyboardEvent):Void {
		_controller.keyboardUp(e);
	}
}