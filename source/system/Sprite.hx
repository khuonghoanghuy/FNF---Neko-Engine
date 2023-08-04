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

	public function addPrefix(stringAnimation:String, xmlCode:String, fps:Int = 24, loop:Bool = false, ifFlipX:Bool = false, ifFlipY:Bool = false)
	{
		return animation.addByPrefix(stringAnimation, xmlCode, fps, loop, ifFlipX, ifFlipY);
	}

	public function addIndices(stringAnimation:String, xmlCode:String, arrayInt:Array<Int>, postfix:String = "", fps:Int = 24, loop:Bool = false,
			ifFlipX:Bool = false, ifFlipY = false)
	{
		return animation.addByIndices(stringAnimation, xmlCode, arrayInt, postfix, fps, loop, ifFlipX, ifFlipY);
	}

	public function playAnim(stringAnimation:String, force:Bool = false, reversed:Bool = false, frame:Int = 0)
	{
		return animation.play(stringAnimation, force, reversed, frame);
	}
}
