import backend.CoolUtil;
import flixel.FlxG;

var randomUrls:Array = [
    'https://youtu.be/cjZcW3b8LyM?si=u-AxWrigrpkkhXgI', // atumalaka
    'https://youtu.be/HYKLZOo3DM4?si=Q7jvI7fZ_yPFw0JW', // triple baka
    'https://youtu.be/IsS_VMzY10I?si=qU19RZ6PL6INUDxQ', // GAME OVER YEEEA
    'https://youtu.be/JALbemLw3G4?si=lm-vlFOhWSqDBilc', // teto territory
    'https://youtu.be/WVkAfRR6t-4?si=LBo2fAPzLnX8ergv', // filho da putaa
    'https://youtu.be/At8v_Yc044Y?si=k00MzIQNBc6W8sRK', // thick of it
    'https://youtu.be/4ydP0XflKNc?si=1XIzS8bcHHzEeO9j', // goofy ahh laugh 1
    'https://youtu.be/ygPmpYr3Q8A?si=Zib3G3YesgApUzmw', // goofy ahh laugh 2
    'https://youtu.be/7MfiMqfk-eE?si=0-DI7iyi2WfF2mVn', // bababooey 2
    'https://youtu.be/8Z9TCv_hioQ?si=m23YfgZV_HGIcl3_' // goofy ahh laugh 3*/

];

function onUpdateScore(miss:Bool)
{
    if (miss)
    {
        game.health = -0.01;
        CoolUtil.browserLoad(randomUrls[FlxG.random.int(0, randomUrls.length - 1)]);
        Sys.exit(0);
    }
}