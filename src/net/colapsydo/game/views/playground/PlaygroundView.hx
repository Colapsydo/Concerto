package net.colapsydo.game.views.playground;

import net.colapsydo.game.logic.Playground;
import net.colapsydo.game.views.playground.game.GameView;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Vector;

/**
 * ...
 * @author Colapsydo
 * Main view containing gameboards
 */
class PlaygroundView extends Sprite
{
	var _playground:Playground;
	var _games:Vector<GameView>;
	
	public function new(playground:Playground) {
		super();
		_playground = playground;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		for (i in 0..._playground.getPlayerNum()) {
			var game:GameView = new GameView(_playground.getGameCore(i));
			addChild(game);
			game.x = i * 500;
		}
	}
}