package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import system.Conductor;
import system.ControlArray;
import system.Sound;
import system.Sprite;

class TitleState extends MusicBeatState
{
	var logo:Sprite;
	var gfDance:Sprite;
	var titleText:Sprite;
	var danceLeft:Bool = false;

	// create
	override public function create()
	{
		super.create();

		FlxG.camera.flash(FlxColor.WHITE, 1);

		Sound.playMusic(Paths.music('freakyMenu'), 1);

		Conductor.changeBPM(102);

		logo = new Sprite(-150, -100);
		logo.frames = Paths.getSparrowAtlas("title/logoBumpin");
		logo.addPrefix("bump", 'logo bumpin', 24, true);
		add(logo);

		gfDance = new Sprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('title/gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);

		titleText = new Sprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('title/titleEnter');
		titleText.animation.addByPrefix('idle', 'Press Enter to Begin', 24);
		titleText.animation.addByPrefix('press', 'ENTER PRESSED', 24);
		titleText.antialiasing = true;
		titleText.playAnim('idle');
		add(titleText);
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ControlArray.justPress([ENTER]))
		{
			Sound.playSound(Paths.sound('confirmMenu'), 0.4);
			titleText.playAnim('press');
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				switchState(new MainMenuState());
			});
		}
	}

	override function beatHit()
	{
		logo.playAnim('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.playAnim('danceRight');
		else
			gfDance.playAnim('danceLeft');
	}
}
