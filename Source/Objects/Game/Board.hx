package objects.game;

import flash.display.Sprite;

class Board extends Sprite
{
    public var block: Array<Array<Block>>;

    public var square: Array<Square>;
    
    public function new()
    {
        super();

        y = 340;

        block = [];
        for (i in 0...6) {
            block[i] = [];
            for (j in 0...6) {
                block[i][j] = new Block(i, j, i*128, j*128);
                addChild(block[i][j]);
            }
        }

        removeSquares();
    }

    private function removeSquares()
    {
        var done = true;

        for (i in 0...5) {
            for (j in 0...5) {
                if (block[i][j].color == block[i+1][j].color &&
                    block[i][j].color == block[i][j+1].color &&
                    block[i][j].color == block[i+1][j+1].color) {
                    done = false;
                    setColor(i + Std.random(2), j + Std.random(2), H.randomNot(3, block[i][j].color));
                }
            }
        }

        if (!done) {
            removeSquares();
        }
    }

    public function setSquares(mi: Int, mj: Int, ni: Int, nj: Int): Bool
    {
        var found = false;

        // merging ->
        //   find squares, check its border [i-1], [j-1], [i+w+1], [j+h+1]
        // new squares ->
        //   check 8 neighbour blocks of two swapped blocks (if they aren't squared yet)

        // merging old
        for (i in 0...5) {
            for (j in 0...5) {
                if (block[i][j].squared) {

                    for (k in 0...block[i][j].squareInfo.w) {
                        if (!block[i+k][j-1].squared && block[i+k][j-1].color == block[i][j].color) {
                            if (k == block[i][j].squareInfo.w - 1) {
                                // merge!
                            }
                        } else {
                            break;
                        }
                    }

                    for (l in 0...block[i][j].squareInfo.h) {

                    }
                }
            }
        }

        // new squares
        for (i in 0...5) {
            for (j in 0...5) {
                if (!block[i][j].squared && !block[i+1][j].squared &&
                    !block[i][j+1].squared && !block[i+1][j+1].squared &&
                    block[i][j].color == block[i+1][j].color &&
                    block[i][j].color == block[i][j+1].color &&
                    block[i][j].color == block[i+1][j+1].color) {
                    
                    found = true;

                    placeSquare(i, j);
                }
            }
        }

        return found;
    }

    public function placeSquare(i: Int, j: Int)
    {
        var w = 2;
        var h = 2;

        // find size
        var k = 2;
        var l = 2;

        var stop = false;
        while(!stop) {
            stop = true;

        }

        // set blocks (frames, scales if mi and mj or ni and nj are inside of this square)
        // for (k in 0...w) {
        //     for (l in 0...h) {
        //         block[i+k][j+l];
        //     }
        // }
    }

    public function setColor(i: Int, j: Int, color: Int)
    {
        block[i][j].setColor(color);
    }

    public function setScale(mi: Int, mj: Int, scale: Float)
    {
        if (!block[mi][mj].inSquare)
            block[mi][mj].targetScale = scale;
    }

    public function resetScale()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].targetScale = 1;
    }

    public function swap(sx: Int, sy: Int, ex: Int, ey: Int)
    {
        var col = block[sx][sy].color;
        setColor(sx, sy, block[ex][ey].color);
        setColor(ex, ey, col);

        block[sx][sy].bmp.scaleX = block[sx][sy].bmp.scaleY = 0;
        block[ex][ey].bmp.scaleX = block[ex][ey].bmp.scaleY = 0;

        setScale(sx, sy, 1);
        setScale(ex, ey, 1);
    }

    public function pop(i: Int, j: Int)
    {

    }

    public function update()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].update();
    }
}