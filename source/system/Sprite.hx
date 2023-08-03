package system;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Sprite extends FlxSprite
{
	// new
	public function new(x:Float, y:Float, ?graphic:Null<FlxGraphicAsset>)
	{
		super(x, y, graphic);
	}

	// update
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
