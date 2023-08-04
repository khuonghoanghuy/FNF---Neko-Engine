package states;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import system.ControlArray;
import system.CoolUtil;
import system.Song;
import system.Sound;
import system.Sprite;

class FreeplayState extends MusicBeatState
{
	var songArray:Array<String>;
	var songList:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;

	var bg:Sprite;

	// create
	override public function create()
	{
		super.create();

		bg = new Sprite(0, 0, Paths.image('menuBGBlue'));
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);

		songArray = CoolUtil.arrayText(Paths.txt("songList"));

		songList = new FlxTypedGroup<Alphabet>();
		add(songList);

		for (i in 0...songArray.length)
		{
			var list:Alphabet = new Alphabet(0, (70 * i), songArray[i], true, false);
			list.ID = i;
			list.isMenuItem = true;
			list.targetY = i;
			songList.add(list);
		}

		changeSelection();
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ControlArray.justPress([ESCAPE]))
		{
			Sound.playSound("cancelMenu", 0.4);
			switchState(new MainMenuState());
		}

		if (ControlArray.justPress([DOWN, S]))
		{
			changeSelection(1);
		}

		if (ControlArray.justPress([UP, W]))
		{
			changeSelection(-1);
		}

		if (ControlArray.justPress([ENTER]))
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);
			PlayState.SONG = Song.loadFromJson(songArray[curSelected].toLowerCase(), songArray[curSelected].toLowerCase());
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				Sound.stopSound();
				switchState(new PlayState());
			});
		}
	}

	function changeSelection(change:Int = 0)
	{
		Sound.playSound(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songList.length - 1;
		if (curSelected >= songList.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in songList.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
