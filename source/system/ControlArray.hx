package system;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class ControlArray
{
	inline public static function press(key:Array<FlxKey>)
	{
		return FlxG.keys.anyPressed(key);
	}

	inline public static function justPress(key:Array<FlxKey>)
	{
		return FlxG.keys.anyJustPressed(key);
	}

	inline public static function justRelease(key:Array<FlxKey>)
	{
		return FlxG.keys.anyJustReleased(key);
	}
}
