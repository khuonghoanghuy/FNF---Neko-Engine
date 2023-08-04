package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import substates.WarmSubState;
import system.ControlArray;
import system.Sound;
import system.Sprite;

class MainMenuState extends MusicBeatState
{
	var bg:Sprite;

	// all button:
	var storyMode:Sprite;
	var freeplayMode:Sprite;
	var optionsMode:Sprite;

	// create
	override public function create()
	{
		super.create();

		if (FlxG.sound.playMusic == null)
		{
			Sound.playMusic(Paths.music('freakyMenu'), 1);
		}

		bg = new Sprite(0, 0, Paths.image('menuBG'));
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);

		addButton();

		var text:FlxText = new FlxText(5, FlxG.height - 18, 0, "VERSION: " + Application.current.meta.get("version"), 12);
		text.scrollFactor.set();
		text.alignment = LEFT;
		text.borderColor = FlxColor.BLACK;
		add(text);
	}

	function addButton()
	{
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		storyMode = new Sprite(319, 104);
		storyMode.frames = tex;
		storyMode.addPrefix('idle', 'story mode basic');
		storyMode.addPrefix('select', 'story mode white');
		storyMode.playAnim('idle');
		storyMode.scrollFactor.set();
		add(storyMode);

		freeplayMode = new Sprite(83, 295);
		freeplayMode.frames = tex;
		freeplayMode.addPrefix('idle', 'freeplay basic');
		freeplayMode.addPrefix('select', 'freeplay white');
		freeplayMode.playAnim('idle');
		freeplayMode.scrollFactor.set();
		add(freeplayMode);

		optionsMode = new Sprite(597, 467);
		optionsMode.frames = tex;
		optionsMode.addPrefix('idle', 'options basic');
		optionsMode.addPrefix('select', 'options white');
		optionsMode.playAnim('idle');
		optionsMode.scrollFactor.set();
		add(optionsMode);
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		checkOverlap();
	}

	function checkOverlap()
	{
		if (FlxG.mouse.overlaps(storyMode))
		{
			storyMode.playAnim("select");
			if (FlxG.mouse.justPressed)
			{
				openSubState(new WarmSubState("THAT FEATURE IS NOT WORKING YET!", true, FlxColor.WHITE, 0.6));
			}
		}
		else
		{
			storyMode.playAnim('idle');
		}

		if (FlxG.mouse.overlaps(freeplayMode))
		{
			freeplayMode.playAnim("select");
			if (FlxG.mouse.justPressed)
			{
				Sound.playSound(Paths.sound("confirmMenu"), 0.4);
				switchState(new FreeplayState());
			}
		}
		else
		{
			freeplayMode.playAnim('idle');
		}

		if (FlxG.mouse.overlaps(optionsMode))
		{
			optionsMode.playAnim("select");
			if (FlxG.mouse.justPressed)
			{
				openSubState(new WarmSubState("THAT FEATURE IS NOT WORKING YET!", true, FlxColor.WHITE, 0.6));
			}
		}
		else
		{
			optionsMode.playAnim('idle');
		}
	}

	override function beatHit()
	{
		storyMode.playAnim('idle');
		freeplayMode.playAnim('idle');
		optionsMode.playAnim('idle');
	}
}
