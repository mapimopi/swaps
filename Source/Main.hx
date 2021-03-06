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

	public var menuState: MenuState;
	public var gameState: GameState;
	public var infoState: InfoState;
	public var tutorialState: TutorialState;

	private var currentState: String;

	private var centerStateX: Int;
	private var centerStateY: Int;

	private var lerpSpeed: Float;

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

	public function setState(newState: String)
	{
		if (G.sound) if (currentState == "menu" || currentState == "game" || currentState == "info") G.sounds.swipe.play(0, 0, new flash.media.SoundTransform(0.8));

		currentState = newState;

		resize();
	}

	// load assets and options into the memory
	private function load()
	{
		G.graphics = {};

		// game
		G.graphics.block = Assets.getBitmapData("assets/img/block.png");

		G.graphics.square = [];
		for (i in 0...9)
			G.graphics.square[i] = Assets.getBitmapData("assets/img/square" + i + ".png");

		G.graphics.face = [];
		G.graphics.face[4] = Assets.getBitmapData("assets/img/face04.png");
		G.graphics.face[6] = Assets.getBitmapData("assets/img/face06.png");
		G.graphics.face[8] = Assets.getBitmapData("assets/img/face08.png");
		G.graphics.face[9] = Assets.getBitmapData("assets/img/face09.png");
		G.graphics.face[10] = Assets.getBitmapData("assets/img/face10.png");
		G.graphics.face[12] = Assets.getBitmapData("assets/img/face12.png");
		G.graphics.face[15] = Assets.getBitmapData("assets/img/face15.png");
		G.graphics.face[16] = Assets.getBitmapData("assets/img/face16.png");
		G.graphics.face[18] = Assets.getBitmapData("assets/img/face18.png");
		G.graphics.face[20] = Assets.getBitmapData("assets/img/face20.png");
		G.graphics.face[24] = Assets.getBitmapData("assets/img/face24.png");
		G.graphics.face[25] = Assets.getBitmapData("assets/img/face25.png");
		G.graphics.face[30] = Assets.getBitmapData("assets/img/face30.png");
		G.graphics.face[36] = Assets.getBitmapData("assets/img/face36.png");

		G.graphics.retry = Assets.getBitmapData("assets/img/retry.png");
		G.graphics.menu = Assets.getBitmapData("assets/img/menu.png");

		G.graphics.rewScreen = Assets.getBitmapData("assets/img/rewscreenq.png");

		// settings
		G.graphics.logo = Assets.getBitmapData("assets/img/logo.png");
		G.graphics.music = Assets.getBitmapData("assets/img/music.png");
		


		G.sounds = {};

		G.sounds.swipe = Assets.getSound("assets/snd/swoosh.wav");

		// G.sounds.pop = [Assets.getSound("assets/snd/pop0.wav"),
		//                 Assets.getSound("assets/snd/pop1.wav"),
		//                 Assets.getSound("assets/snd/pop2.wav"),
		//                 Assets.getSound("assets/snd/pop3.wav"),
		//                 Assets.getSound("assets/snd/pop4.wav"),
		//                 Assets.getSound("assets/snd/pop5.wav")];

		// G.sounds.pop = Assets.getSound("assets/snd/pop_1.wav");

		G.sounds.select = [Assets.getSound("assets/snd/c.wav"),
											 Assets.getSound("assets/snd/d.wav"),
											 Assets.getSound("assets/snd/e.wav"),
											 Assets.getSound("assets/snd/f.wav"),
											 Assets.getSound("assets/snd/g.wav"),
											 Assets.getSound("assets/snd/a.wav"),
											 Assets.getSound("assets/snd/b.wav")];

		G.sounds.clear = Assets.getSound("assets/snd/rew.wav");


		G.font = Assets.getFont("assets/Bariol_Bold.otf");


		G.colorScheme = [];
		G.colorScheme[0] = {bg: 0xffffff,
							color: [0xf50c5d, 0x8ffe3b, 0x455eff],
							fg: 0x535353};
		G.currentScheme = 0;


		G.names = ["Jim",
               "Aaron",
               "Williams",
               "Martin",
               "Larry",
               "Lando",
               "Perry",
               "Mattew",
               "Peterson",
               "Dmitry",
               "Pixie",
               "Levy",
               "Dan",
               "Jumbo"];


		G.file = SharedObject.getLocal("options");
		var needSave: Bool = false;

		if (G.file.data.firstStart == null) {
			G.file.data.firstStart = true;
			needSave = true;
		}

		if (G.file.data.music == null) {
			G.file.data.music = true;
			needSave = true;
		}

		if (G.file.data.vibro == null) {
			G.file.data.vibro = true;
			needSave = true;
		}

		if (G.file.data.score == null) {
			G.file.data.score = 0;
			needSave = true;
		}

		if (G.file.data.unlocked == null) {
			G.file.data.unlocked = [];
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

		G.music = G.file.data.music;
		G.sound = true;
		G.vibro = G.file.data.vibro;
		G.score = G.file.data.score;
		firstStart = G.file.data.firstStart;
		G.purchased = G.file.data.purchased;
	}

	// game's entry point
	private function begin()
	{
		G.game = this;

		lerpSpeed = 0.15;
		centerStateX = 0;

		flash.Lib.stage.opaqueBackground = G.scheme().bg;

		addChild(menuState = new MenuState());
		addChild(gameState = new GameState()).x = 1000;
		addChild(infoState = new InfoState()).x = -1000;
		addChild(tutorialState = new TutorialState()).x = -1000;
		
		if (!firstStart) setState("menu");
		else {
			setState("tutorial");
			menuState.x = 1000;
			tutorialState.x = 0;
		}

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

		menuState.scaleX = menuState.scaleY = zoom;
		gameState.scaleX = gameState.scaleY = zoom;
		infoState.scaleX = infoState.scaleY = zoom;
		tutorialState.scaleX = tutorialState.scaleY = zoom;

		centerStateX = Std.int(Lib.current.stage.stageWidth / 2 - 768 * zoom / 2);
		
		// menuState.y = gameState.y = settingsState.y = aboutState.y = Lib.current.stage.stageHeight / 2 - 1280 * zoom / 2;
		menuState.y = gameState.y = infoState.y = tutorialState.y = Lib.current.stage.stageHeight / 2 - 1280 * zoom / 2;

		IO.setZoom(zoom, centerStateX, menuState.y);
	}

	private function update(e: Event)
	{
		menuState.x = H.lerp(menuState.x, (currentState == "menu" ? centerStateX : (currentState == "game" ? centerStateX - 700 : centerStateX + 700)), lerpSpeed);
		gameState.x = H.lerp(gameState.x, (currentState == "game" ? centerStateX : centerStateX + 700), lerpSpeed);
		infoState.x = H.lerp(infoState.x, (currentState == "info" ? centerStateX : centerStateX - 700), lerpSpeed);
		tutorialState.x = H.lerp(tutorialState.x, (currentState == "tutorial" ? centerStateX : centerStateX - 1400), lerpSpeed);

		var currentTime = Lib.getTimer();
		var deltaTime = currentTime - previousTime;
		previousTime = currentTime;

		G.dt = deltaTime * 0.001 * 60;

		IO.touchUpdate();

		if (currentState == "menu") menuState.update();
		else if (currentState == "game") gameState.update();
		else if (currentState == "info") infoState.update();
		else if (currentState == "tutorial") tutorialState.update();

		IO.keyUpdate();
	}

}