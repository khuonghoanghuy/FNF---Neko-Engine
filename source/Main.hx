package;

import flixel.FlxGame;
import openfl.display.FPS;
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
		addChild(new FPS(0, 0, 0xFFFFFF));
		#if debug
		FlxStudio.create();
		#end
	}
}
