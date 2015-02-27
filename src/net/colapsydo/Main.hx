package net.colapsydo;

import net.colapsydo.game.Game;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Colapsydo
 */

class Main extends Sprite 
{
	var _game:Game;
	
	public function new() 
	{
		super();
		
		_game = new Game();
		addChild(_game);
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
	}
}
