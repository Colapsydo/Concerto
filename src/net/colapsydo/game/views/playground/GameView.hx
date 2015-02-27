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
	var _activePair:ActivePairView;
	
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
		_grid.x = (stage.stageWidth - _grid.width) * .5;
		_grid.y = (stage.stageHeight - _grid.height) * .5;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	//HANDLERS
	
	private function keyDownHandler(e:KeyboardEvent):Void {
		_controller.keyboardDown(e);
	}
	
	private function keyUpHandler(e:KeyboardEvent):Void {
		_controller.keyboardUp(e);
	}
	
	public function update():Void {
		//switch(_gameCore.getGameState()) {
			//
		//}
		_grid.update();
		_controller.update();
	}
	
}