package net.colapsydo.game;

import net.colapsydo.game.logic.Playground;
import net.colapsydo.game.views.playground.PlaygroundView;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Colapsydo
 */
class Game extends Sprite
{
	var _playground:Playground;
	var _playgroundView:PlaygroundView;
	
	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		//_playground = new Playground(true); // Musicalchemy
		_playground = new Playground(false); //Puyo
		addChild(_playground);
		_playgroundView = new PlaygroundView(_playground);
		addChild(_playgroundView);
	}
	
}