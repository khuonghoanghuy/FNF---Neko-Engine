package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.TitleState;
#if debug
import flixel.addons.studio.FlxStudio;
#end

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));
		#if debug
		FlxStudio.create();
		#end
	}
}
