package;

import flixel.FlxG;
import flixel.FlxState;
#if debug
import flixel.addons.studio.FlxStudio;
#end

class MusicBeatState extends FlxState
{
	var getFocusFPS:Int;

	override public function create()
	{
		super.create();
		#if debug
		FlxStudio.create();
		#end

		getFocusFPS = 60; // focus lost fps

		FlxG.game.focusLostFramerate = getFocusFPS;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.log.add(elapsed * 1000);
	}
}
