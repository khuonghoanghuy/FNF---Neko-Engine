package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import obj.Note;
import system.Conductor;
import system.ControlArray;
import system.Section.SwagSection;
import system.Song;
import system.Sound;
import system.Sprite;
import system.SwagCamera;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curLevel:String = 'Tutorial';

	// characters
	var dad:Sprite;
	var gf:Sprite;
	var bf:Sprite;

	// cam stuff
	var camFollow:FlxObject;
	var camHUD:FlxCamera;
	var camGame:SwagCamera;
	var camZooming:Bool = false;

	// song stuff
	public static var SONG:SwagSong;

	var curSong:String = "";

	// note stuff
	private var notes:FlxTypedGroup<Note>;
	var strumLine:Sprite;
	var strumLineNotes:FlxTypedGroup<Sprite>;
	var playerStrums:FlxTypedGroup<Sprite>;
	private var unspawnNotes:Array<Note> = [];

	// sound & music stuff
	private var vocals:Sound;
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	// create
	override public function create()
	{
		camGame = new SwagCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		if (SONG == null)
			SONG = Song.loadFromJson(curLevel);

		Conductor.changeBPM(SONG.bpm);

		super.create();

		getStage("stage");
		addCharacters();

		Conductor.songPosition = -5000;

		strumLine = new Sprite(0, 50);
		strumLine.makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<Sprite>();
		playerStrums = new FlxTypedGroup<Sprite>();
		add(strumLineNotes);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = 1.05;

		strumLineNotes.cameras = [camHUD];

		startCountdown();
	}

	var startTimer:FlxTimer;
	var startedCountdown:Bool = false;

	function startCountdown():Void
	{
		generateStaticArrows(0);
		generateStaticArrows(1);

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			switch (swagCounter)
			{
				case 0:
					Sound.playSound(Paths.sound("intro3"), 0.6);
				case 1:
					var ready:Sprite = new Sprite(0, 0, Paths.image("ui/ready"));
					ready.scrollFactor.set();
					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					Sound.playSound(Paths.sound("intro2"), 0.6);
				case 2:
					var set:Sprite = new Sprite(0, 0, Paths.image("ui/set"));
					set.scrollFactor.set();
					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					Sound.playSound(Paths.sound("intro1"), 0.6);
				case 3:
					var go:Sprite = new Sprite(0, 0, Paths.image("ui/go"));
					go.scrollFactor.set();
					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					Sound.playSound(Paths.sound("introGo"), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		startingSong = false;
		FlxG.sound.playMusic(Paths.inst(SONG.song.toLowerCase()), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			FlxG.log.add(i);
			var babyArrow:Sprite = new Sprite(0, strumLine.y);
			babyArrow.frames = Paths.getSparrowAtlas("ui/NOTE_assets");
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			babyArrow.scrollFactor.set();
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			babyArrow.updateHitbox();
			babyArrow.antialiasing = true;

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			switch (Math.abs(i))
			{
				case 2:
					babyArrow.x += Note.swagWidth * 2;
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.x += Note.swagWidth * 3;
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				case 1:
					babyArrow.x += Note.swagWidth * 1;
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 0:
					babyArrow.x += Note.swagWidth * 0;
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			vocals = new Sound();
			vocals.loadEmbedded(Paths.voices(SONG.song.toLowerCase()));
		}
		else
			vocals = new Sound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function addCharacters()
	{
		dad = new Sprite(0, 0);
		dad.frames = Paths.getSparrowAtlas("characters/DADDY_DEAREST");
		dad.addPrefix("idle", "Dad idle dance");
		dad.addPrefix("left", "Dad Sing Note LEFT");
		dad.addPrefix("right", "Dad Sing Note RIGHT");
		dad.addPrefix("down", "Dad Sing Note DOWN");
		dad.addPrefix("up", "Dad Sing Note UP");
		add(dad);

		bf = new Sprite(0, 0);
		bf.frames = Paths.getSparrowAtlas("characters/BOYFRIEND");
		bf.addPrefix('idle', 'BF idle dance', 24, false);
		bf.addPrefix('singUP', 'BF NOTE UP0', 24, false);
		bf.addPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
		bf.addPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
		bf.addPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
		bf.addPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
		bf.addPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
		bf.addPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		bf.addPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
		bf.addPrefix('hey', 'BF HEY', 24, false);
		bf.addPrefix('firstDeath', "BF dies", 24, false);
		bf.addPrefix('deathLoop', "BF Dead Loop", 24, true);
		bf.addPrefix('deathConfirm', "BF Dead confirm", 24, false);
		bf.playAnim('idle');
		add(bf);
	}

	function getStage(name:String)
	{
		switch (name)
		{
			default:
				var bg:Sprite = new Sprite(-600, -200);
				bg.loadGraphic(Paths.image("stage/week1/stageback"));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:Sprite = new Sprite(-650, 600);
				stageFront.loadGraphic(Paths.image("stage/week1/stagefront"));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:Sprite = new Sprite(-500, -300);
				stageCurtains.loadGraphic(Paths.image("stage/week1/stagecurtains"));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				add(stageCurtains);
		}
	}

	// update
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (ControlArray.justPress([UP]))
		{
			dad.playAnim("up");
		}
		else
		{
			dad.playAnim("idle");
		}
	}

	function endSong():Void
	{
		FlxG.switchState(new FreeplayState());
	}

	override function beatHit()
	{
		super.beatHit();
		dad.playAnim("idle");
		// gf.playAnim("idlea");
		bf.playAnim('idle');
	}
}
