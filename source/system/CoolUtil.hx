package system;

import flixel.FlxG;
import openfl.Assets;

using StringTools;

class CoolUtil
{
	inline public static function arrayText(paths:String):Array<String>
	{
		return [
			for (i in Assets.getText(paths).trim().split('\n'))
				i.trim()
		];
	}

	inline public static function coolString(paths:String):String
	{
		return Assets.getText(paths).trim();
	}

	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}
}
