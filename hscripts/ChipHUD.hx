import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Difficulty;
import PlayState;

var songData;

var scoreBar:FlxText;
var songTimeDisplay:FlxText;

var scoreDisplay:String = 'fnf supremacy';
var ranking:String = 'sail te amo';
var songTimeTxt:String = 'casa cmg tbm';
var scoreLerp:Int = 0;

var showComboBreaks:Bool = true;
var showRanking:Bool = true;
var highlightRanking:Bool = true;

var highlightFormat:FlxTextFormat;
var highlightSongName:FlxTextFormat;

var rankingMap:Array<Dynamic> = [
    ['F',   0.2],
	['E',   0.4],
	['D',   0.5],
	['C',   0.7],
	['B',   0.8],
	['A',   0.9],
	['S',     1],
	['S+',    1]
];

var rankingColors:Map<String, FlxColor> = [
    'S+'    => FlxColor.fromString('#F8D482'),
	'S'     => FlxColor.CYAN,
	'A'     => FlxColor.LIME,
	'B'     => FlxColor.GREEN,
	'C'     => FlxColor.BROWN,
	'D'     => FlxColor.PINK,
	'E'     => FlxColor.ORANGE,
	'F'     => FlxColor.RED,
    '?'     => FlxColor.fromString('#2F2935')
];

var scoreDivider:String = ' • ';
var markupDivider:String = (highlightRanking) ? '°' : '';
var displayAl = 0.725;

function onCreate()
{
    var displayScoreY = (!ClientPrefs.data.downScroll) ? FlxG.height * 0.875 : 64;
    var displayTimeY = (!ClientPrefs.data.downScroll) ? 16 : FlxG.height - (0.875 * 32);
    //debugPrint((0.875 * 32));

    songTimeDisplay = new FlxText(0, displayTimeY, FlxG.width, songTimeTxt);
    songTimeDisplay.alignment = 'center';
	songTimeDisplay.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE);
	songTimeDisplay.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    songTimeDisplay.visible = !ClientPrefs.data.hideHud || !ClientPrefs.data.timeBarType == 'DISABLED';
    songTimeDisplay.alpha = displayAl;
    songTimeDisplay.cameras = [game.camHUD];
	game.add(songTimeDisplay);

    scoreBar = new FlxText(0, displayScoreY + 50, FlxG.width, scoreDisplay);
    scoreBar.alignment = 'center';
	scoreBar.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE);
	scoreBar.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    scoreBar.visible = !ClientPrefs.data.hideHud;
    scoreBar.alpha = displayAl;
    scoreBar.cameras = [game.camHUD];
	game.add(scoreBar);
    
    songData = PlayState.SONG;
}

function onCreatePost()
{
    songTimeDisplay.alpha = 0;
    game.scoreTxt.visible = false;
    game.timeTxt.visible = false;
    game.timeBar.visible = false;
}

function onSongStart()
{
    FlxTween.tween(songTimeDisplay, {alpha: displayAl}, 1.5 / game.playbackRate,
        {ease: FlxEase.expoInOut});
}

function onUpdate()
{    
    // song time display uauau
    var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset);
    var songCalc:Float = game.songLength - curTime;

    if (ClientPrefs.data.timeBarType == 'Time Elapsed') songCalc = curTime;
    var secondsTotal:Int = Math.floor(songCalc / 1000);
    
    songTimeDisplay.text = ((ClientPrefs.data.timeBarType != 'Song Name') ? '§' + songData.song + '§ ' + FlxStringUtil.formatTime(secondsTotal, false) : '§' + songData.song + '§') + ' ' + Difficulty.getString().toUpperCase();
    highlightSongName = new FlxTextFormat(FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]), true);
    songTimeDisplay.applyMarkup(songTimeDisplay.text, [new FlxTextFormatMarkerPair(highlightSongName, '§')]);

    // score uau
    var tempScore:String = '';
    scoreLerp = Math.floor(FlxMath.lerp(scoreLerp, game.songScore, 0.2 / (ClientPrefs.data.framerate / 60)));

    if (totalPlayed != 0)
    {
        ranking = rankingMap[rankingMap.length - 1][0];
        if (game.ratingPercent < 1)
        {
            for (i in 0...rankingMap.length - 1)
            {
                if (game.ratingPercent < rankingMap[i][1])
                {
                    ranking = rankingMap[i][0];
                    break;
                }
            }
        }
    }

    if (showComboBreaks)
        tempScore += 'Combo Breaks: ' + game.songMisses + scoreDivider;

    tempScore += 'Score: ' + scoreLerp;

    if (showRanking)
        tempScore += scoreDivider + 'Rating: ' + markupDivider + ((totalPlayed != 0) ? ranking : '?') + markupDivider;

    scoreBar.text = (!game.cpuControlled) ? tempScore : 'BOTPLAY';
    highlightFormat = new FlxTextFormat(rankingColors.get(ranking), true);
    scoreBar.applyMarkup(scoreBar.text, [new FlxTextFormatMarkerPair(highlightFormat, markupDivider)]);
}