package states;

import system.Sprite;

class TitleState extends MusicBeatState
{
	var logo:Sprite;

	// create
	override public function create()
	{
		super.create();

		logo = new Sprite(-110, -95);
		logo.frames = Paths.getSparrowAtlas("title/logoBumpin");
		logo.animation.addByPrefix("bump", "logo bumpin", 24, true);
		logo.animation.play('bump');
		add(logo);
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
