package substates;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import system.ControlArray;
import system.Sprite;

class WarmSubState extends FlxSubState
{
	// create
	public function new(text:String, ifNeedBackgroundColor:Bool, ?color:FlxColor, ?alphaNeed:Float)
	{
		super();

		var bg:Sprite = new Sprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, color);
		bg.alpha = alphaNeed;

		var textStr:FlxText = new FlxText(0, 0, 0, text, 16, false);
		textStr.color = FlxColor.BLACK;
		textStr.screenCenter();
		textStr.alignment = CENTER;

		if (ifNeedBackgroundColor)
		{
			add(bg);
			add(textStr);
		}
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ControlArray.justPress([ANY]))
		{
			close();
		}
	}
}
