package system;

import flixel.FlxG;
import flixel.sound.FlxSound;

class Sound extends FlxSound
{
	public function new()
	{
		super();
	}

	inline public static function playMusic(paths:String, loud:Float)
	{
		return FlxG.sound.playMusic(paths, loud);
	}

	inline public static function playSound(paths:String, loud:Float)
	{
		return FlxG.sound.play(paths, loud);
	}

	inline public static function stopSound()
	{
		return FlxG.sound.music.stop();
	}
}
