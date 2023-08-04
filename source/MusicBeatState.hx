package;

import flixel.FlxG;
import flixel.FlxState;
import states.PlayState;
import system.Conductor;
import system.ControlArray;
#if debug
import flixel.addons.studio.FlxStudio;
#end

// on curBeat and other thing, im using v1.1.0 version to using
class MusicBeatState extends FlxState
{
	var getFocusFPS:Int;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var totalBeats:Int = 0;
	private var totalSteps:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	override public function create()
	{
		super.create();
		#if debug
		FlxStudio.create();
		#end

		getFocusFPS = 60; // focus lost fps

		FlxG.game.focusLostFramerate = getFocusFPS;
	}

	override function update(elapsed:Float)
	{
		everyStep();

		updateCurStep();
		curBeat = Math.round(curStep / 4);

		/*#if debug
			if (ControlArray.justPress([ENTER]))
			{
				switchState(new PlayState());
			}
			#end */

		super.update(elapsed);
	}

	private function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
			}
		}
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;
	}

	function switchState(state:FlxState)
	{
		return FlxG.switchState(getState(state));
	}

	function getState(state:FlxState):FlxState
	{
		return state;
	}
}
