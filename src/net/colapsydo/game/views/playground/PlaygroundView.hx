package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.Playground;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 * Main view containing gameboards
 */
class PlaygroundView extends Sprite
{
	var _playground:Playground;
	var _game:GameView;
	
	public function new(playground:Playground) {
		super();
		_playground = playground;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		_game = new GameView(_playground.getGameCore());
		addChild(_game);
		
		_playground.addEventListener(Playground.UPDATE, updateHandler);
	}
	
	private function updateHandler(e:Event):Void {
		_game.update();
	}
	
}