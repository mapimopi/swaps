package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import flash.text.Font;
import states.State;
import flash.net.SharedObject;

// Global variables
class G
{
    static public var purchased: Bool;

    static public var game: Main;

    static public var state: State;

    static public var names: Array<String>;
    static public var score: Int;

    static public var music: Bool;
    static public var sound: Bool;
    static public var vibro: Bool;

    static public var file: SharedObject;

    // delta time
    static public var dt: Float;

    // contains booleans for music, sound and colorblind mode
    static public var options: Dynamic;

    // stores loaded bitmap data
    static public var graphics: Dynamic;

    // stores loaded music and sounds
    static public var sounds: Dynamic;

    // Bariol_Bold
    static public var font: Font;

    static public var currentScheme: Int;
    static public var colorScheme: Array<Dynamic>;

    static public function scheme(): Dynamic
    {
        return G.colorScheme[G.currentScheme];
    }

    static public function getName(s: Int): String
    {
        var w: Int;
        var h: Int;
        for (i in 0...names.length) {
            w = Math.floor(game.infoState.sizeList[i] / 10);
            h = game.infoState.sizeList[i] % 10;
            if (w*h == s) return names[i];
        }
        return "???";
    }
}