package;


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import openfl.Assets;
import flash.net.SharedObject;

import states.*;


class Main extends Sprite {
	
	private var state: State;

	public var zoom: Float;

	var firstStart: Bool;
	var previousTime: Float;

	public function new () {
		
		super();

		load();

		begin();
		
		stage.addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(Event.RESIZE, resize);
	}

	public function setState(newState: Dynamic)
	{
		if (state != null) {
			removeChild(state);
		}

		state = newState;
		addChild(state);

		resize();

		G.state = state;
	}

	// load assets and options into the memory
	private function load()
	{
		G.graphics = {};
		G.graphics.block = Assets.getBitmapData("assets/img/block.png");

		G.font = Assets.getFont("assets/Bariol_Bold.otf");


		G.colorScheme = [];
		G.colorScheme[0] = {bg: 0xffffff,
							color: [0xf50c5d, 0x8ffe3b, 0x455eff],
							text: 0x232323};
		G.currentScheme = 0;


		var file = SharedObject.getLocal("options");
		var needSave: Bool = false;

		file.close();
	}

	// game's entry point
	private function begin()
	{
		G.game = this;

		setState(new GameState());

		IO.set();

		previousTime = Lib.getTimer();
	}

	private function resize(?e: Event)
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.quality = flash.display.StageQuality.BEST;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		var ratioX = Lib.current.stage.stageWidth / 768;
		var ratioY = Lib.current.stage.stageHeight / 1280;
		zoom = Math.min(ratioX, ratioY);

		state.scaleX = zoom;
		state.scaleY = zoom;

		state.x = Lib.current.stage.stageWidth / 2 - 768 * zoom / 2;
		state.y = Lib.current.stage.stageHeight / 2 - 1280 * zoom / 2;

		IO.setZoom(zoom, state.x, state.y);
	}

	private function update(e: Event)
	{
		var currentTime = Lib.getTimer();
		var deltaTime = currentTime - previousTime;
		previousTime = currentTime;

		G.dt = deltaTime * 0.001 * 60;

		IO.update();
		
		state.update();
	}

	// debug
	private function generate()
	{
		var map: Array<Array<String>>;
		
		map = [];
		for (i in 0...9) {
			map[i] = [];
			for (j in 0...9) {
				map[i][j] = newLetter();
			}
		}

		for (i in 0...9) {
			for (j in 0...9) {
				map[i][j] = checkForThrees(map, i, j);
			}
		}
		
		var res = "";

		for (i in 0...9) {
			res += "\n";
			for (j in 0...9) {
				res += " " + map[i][j];
			}
		}

		trace(res);
	}

	private function checkForThrees(map: Array<Array<String>>, i: Int, j: Int): String
	{
		var con: Int;
		var letter = map[i][j];
		do {
			con = 0;
			if (i > 0 && letter == map[i-1][j]) con++;
			if (i <8 && letter == map[i+1][j]) con++;
			if (j > 0 && letter == map[i][j-1]) con++;
			if (j <8 && letter == map[i][j+1]) con++;
			if (con >= 2) {
				do {
					letter = newLetter();
				} while (letter == map[i][j]);
			}
		} while (con >= 2);
		return letter;
	}

	private function newLetter(max = 7): String
	{
		var res = "";
		var rand = Std.random(max);
		switch (rand) {
			case 0: res = 'a';
			case 1: res = 'b';
			case 2: res = 'c';
			case 3: res = 'd';
			case 4: res = 'e';
			case 5: res = 'f';
			case 6: res = 'g';
		}
		return res;
	}
	
	
}