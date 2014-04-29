package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import objects.game.*;
import objects.Background;

class GameState extends State
{
    public var map: Board;

    // block index under the cursor
    private var mi: Int;
    private var mj: Int;

    private var controlable: Bool;

    public var turn: Int;

    public var selected: Bool;
    public var selectX: Int;
    public var selectY: Int;


    public function new()
    {
        super();

        name = "GameState";
    }

    override private function begin()
    {
        selected = false;

        controlable = true;

        turn = 0;

        addChild(new Background(G.scheme().bg));

        map = new Board();
        addChild(map);

        addChild(new Bitmap(new BitmapData(768, Math.floor(map.y)*2, false, G.scheme().bg))).y = -Math.floor(map.y);
    }

    override public function update()
    {
        if (controlable) {
            if (IO.pressed) {

            }

            if (IO.down) {
                onDown();
            }

            if (IO.released) {
                onRelease();
            }
        }

        map.update();
    }

    private function onDown()
    {
        if (IO.y > map.y) {
            mi = Math.floor(IO.x / 128);
            mj = Math.floor((IO.y - map.y) / 128);
            map.resetScale();
            map.setScale(mi, mj, 1.4);
            if (selected) map.setScale(selectX, selectY, 0.8);
        }
    }

    private function onRelease()
    {
        if (map.block[mi][mj].color == -1) return;
        map.resetScale();
        if (map.block[mi][mj].squared) {
            pop();
        } else {
            if (selected) {
                swap();
            } else {
                select();
            }
        }
    }

    private function select()
    {
        selectX = mi;
        selectY = mj;
        map.setScale(selectX, selectY, 0.8);
        selected = true;
    }

    private function swap()
    {
        if ((mi != selectX || mj != selectY)
          && map.block[mi][mj].color != map.block[selectX][selectY].color) {
            map.makeBackup();

            map.swap(selectX, selectY, mi, mj);
            turn++;
            
            // check if backup doesn't change with current map
            // map.block[0][0].bmp.x = 200;
            // trace(map.old[0][0].bmp.x);
        }

        var squared = false;
        if (map.checkSquares(mi, mj)) squared = true;
        if (map.checkSquares(selectX, selectY)) squared = true;

        if (!squared) map.useBackup();

        selected = false;
    }

    private function pop()
    {
        map.pop(mi, mj);
        selected = false;
    }
}