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

		stage.addEventListener(Event.ENTER_FRAME, start);
	}

	private function start(e: Event) {
		stage.removeEventListener(Event.ENTER_FRAME, start);

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

		G.graphics.square = [];
		for (i in 0...9)
			G.graphics.square[i] = Assets.getBitmapData("assets/img/square" + i + ".png");

		G.graphics.face = Assets.getBitmapData("assets/img/fdeb.png");

		G.graphics.infoRound = Assets.getBitmapData("assets/img/bar-rounder.png");
		
		G.graphics.pause = Assets.getBitmapData("assets/img/pause.png");

		// G.graphics.infoCover = Assets.getBitmapData("assets/img/info-cover.png");
		// G.graphics.infoBlock = Assets.getBitmapData("assets/img/blockbar.png");
		// G.graphics.infoStar = Assets.getBitmapData("assets/img/star.png");

		G.font = Assets.getFont("assets/Bariol_Bold.otf");


		G.colorScheme = [];
		G.colorScheme[0] = {bg: 0xffffff,
							color: [0xf50c5d, 0x8ffe3b, 0x455eff],
							fg: 0x535353};
		G.currentScheme = 0;


		G.file = SharedObject.getLocal("options");
		var needSave: Bool = false;

		if (G.file.data.score == null) {
			G.file.data.score = 0;
			needSave = true;
		}

		if (G.file.data.level == null) {
			G.file.data.level = 1;
			needSave = true;
		}

		if (G.file.data.purchased == null) {
			#if android
				G.file.data.purchased = false;
			#else
				G.file.data.purchased = true;
			#end
		}

		if (needSave) {
			try {
				G.file.flush();
			} catch (e: Dynamic) {}
		}

		G.score = G.file.data.score;
		G.level = G.file.data.level;
		G.nextScore = G.level * 400;
		G.maxPopsNotPurchased = 20;
	}

	// game's entry point
	private function begin()
	{
		G.game = this;

		setState(new MenuState());
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

		IO.touchUpdate();

		state.update();

		IO.keyUpdate();
	}

}