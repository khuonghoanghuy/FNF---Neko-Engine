package states;

import system.Sprite;

class MainMenuState extends MusicBeatState
{
	var bg:Sprite;

	// create
	override public function create()
	{
		super.create();

		bg = new Sprite(0, 0, Paths.image('menuBG'));
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
