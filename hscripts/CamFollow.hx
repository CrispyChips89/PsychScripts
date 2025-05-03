import PlayState;

var mustHitSection:Bool = true;

var shiftCamIntensity:Float = 20;
var boyfriendCamPos:Array<Float, Float>;
var dadCamPos:Array<Float, Float>;
var curSection:Int = 0;

var curAnim:String;
var charCamPos:Array<Float, Float>;

function onCreatePost()
{
    // cam positions (x, y)
    dadCamPos = [
        (game.dad.getMidpoint().x + 150) + game.dad.cameraPosition[0] + game.opponentCameraOffset[0],
        (game.dad.getMidpoint().y - 100) + game.dad.cameraPosition[1] + game.opponentCameraOffset[1]
    ];

    boyfriendCamPos = [
        (game.boyfriend.getMidpoint().x - 100) - game.dad.cameraPosition[0] + game.boyfriendCameraOffset[0],
        (game.boyfriend.getMidpoint().y - 100) + game.dad.cameraPosition[1] + game.boyfriendCameraOffset[1],
    ];

    charCamPos = boyfriendCamPos;
}

function onSectionHit()
{
    curSection += 1;
    mustHitSection = PlayState.SONG.notes[curSection].mustHitSection;
    //debugPrint(mustHitSection);

    charCamPos = mustHitSection ? boyfriendCamPos : dadCamPos;
    game.isCameraOnForcedPos = false;
}

function onUpdate()
{
    // follow
    curAnim = mustHitSection ? game.boyfriend.animation.curAnim.name : game.dad.animation.curAnim.name;
    switch (curAnim)
    {
        case 'singLEFT':
            game.camFollow.x = charCamPos[0] - shiftCamIntensity;
        case 'singRIGHT':
            game.camFollow.x = charCamPos[0] + shiftCamIntensity;
        case 'singUP':
            game.camFollow.y = charCamPos[1] - shiftCamIntensity;
        case 'singDOWN':
            game.camFollow.y = charCamPos[1] + shiftCamIntensity;
        default:
            game.camFollow.x = charCamPos[0];
            game.camFollow.y = charCamPos[1];
    }
}
