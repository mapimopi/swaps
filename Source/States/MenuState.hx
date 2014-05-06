package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var score: TextField;

    private var playBtn: Button;
    
    private var aboutIco: Icon;
    private var settingsIco: Icon;
    private var messagesIco: Icon;

    public function new()
    {
        super();

        name = "MenuState";
    }

    override private function begin()
    {
        score = H.newTextField(0, 540, 768, 92, G.scheme().fg, "center", Std.string(G.score));
        addChild(score);

        addChild(playBtn = new Button(128, 900, "PLAY", G.scheme().color[0], G.scheme().fg));

        addChild(settingsIco = new Icon(48, 0, "settings"));
        addChild(aboutIco = new Icon(288, 0, "about"));
        addChild(messagesIco = new Icon(528, 0, "messages"));
    }

    override public function update()
    {
        playBtn.update();

        settingsIco.update();
        aboutIco.update();
        messagesIco.update();

        if (playBtn.isDown()) {
            G.game.setState("game");
            G.game.settingsState.reset();
        }

        if (aboutIco.isDown()) {
            trace('about');
        }

        if (settingsIco.isDown()) {
            G.game.setState("settings");
        }

        if (messagesIco.isDown()) {
            trace('messages');
        }
    }

    public function set()
    {
        score.text = Std.string(G.score);
    }
}