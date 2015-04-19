package
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	[SWF(width="800", height="600", backgroundColor="#181818", frameRate="60")]
	public class Main extends Sprite
	{
		private var _screens:MovieClip;
		private var _game:GameLevel;
		
		private var _screensMusic:Sound;
		private var _screensMusicSC:SoundChannel;
		
		private var _score:uint; //stupid... really shouldn't declare this here but... game jam code. yay!
		private var _total:uint;
		
		public function Main() {
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, "Game is up!");
			
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0 , true);
		}
		
		public function init(evt:Event = null):void
		{
			//MonsterDebugger.trace(this, "Initializing");
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//setup screen
			_screens = new GameAssets.basicScreens();
			gotoTitleScreen();
			
			this.addChild(_screens);
			
			//volume control
			var volumeControl:VolumeControl = new VolumeControl();
			volumeControl.x = 616.0;
			volumeControl.y = 16.0;
			this.addChild(volumeControl);
			//MonsterDebugger.trace(this, volumeControl);
			
			//menu music
			_screensMusic = new GameAssets.menuMusic();
			_screensMusicSC = _screensMusic.play(0, 99999);
		}
		
		private function gotoTitleScreen(evt:Event = null):void
		{
			_screens.gotoAndStop("title");
			_screens.btnStartGame.addEventListener(MouseEvent.CLICK, gotoIntroScreen, false, 0, true);
			_screens.btnCredits.addEventListener(MouseEvent.CLICK, gotoCreditsScreen, false, 0, true);
		}
		
		private function gotoCreditsScreen(evt:Event = null):void
		{
			_screens.gotoAndStop("credits");
			_screens.btnBack.addEventListener(MouseEvent.CLICK, gotoTitleScreen, false, 0, true);
			
			_screens.LD32Link.addEventListener(MouseEvent.CLICK, handleLD32Link, false, 0, true);
			_screens.LD32Link.buttonMode = true;
			_screens.LD32Link.mouseChildren = false;
		}
		
		private function handleLD32Link(evt:Event = null):void
		{
			navigateToURL(new URLRequest("http://ludumdare.com/compo/ludum-dare-32"), "_blank");
		}
		
		private function gotoIntroScreen(evt:Event = null):void
		{
			_screens.gotoAndStop("intro");
			_screens.btnTrack1Easy.addEventListener(MouseEvent.CLICK, selectTrack1Easy, false, 0, true);
			_screens.btnTrack1Hard.addEventListener(MouseEvent.CLICK, selectTrack1Hard, false, 0, true);
			_screens.btnTrack2Easy.addEventListener(MouseEvent.CLICK, selectTrack2Easy, false, 0, true);
			_screens.btnTrack2Hard.addEventListener(MouseEvent.CLICK, selectTrack2Hard, false, 0, true);
		}
		
		private function gotoSummaryScreen(evt:Event = null):void
		{
			_screens.gotoAndStop("summary");
			_screens.scoreHits.text = _score;
			_screens.scoreTotal.text = _total;
			_screens.btnNewGame.addEventListener(MouseEvent.CLICK, gotoIntroScreen, false, 0, true);
			_screens.btnTitle.addEventListener(MouseEvent.CLICK, gotoTitleScreen, false, 0, true);
		}
		
		private function selectTrack1Easy(evt:Event = null):void { startGame(1, "easy"); }
		private function selectTrack1Hard(evt:Event = null):void { startGame(1, "hard"); }
		private function selectTrack2Easy(evt:Event = null):void { startGame(2, "easy"); }
		private function selectTrack2Hard(evt:Event = null):void { startGame(2, "hard"); }
		
		private function startGame(trackNum:int, difficulty:String):void
		{
			_screens.gotoAndStop("blank");
			if (_screensMusicSC != null) {
				_screensMusicSC.stop();
				_screensMusicSC = null;
			}
			
			_game = new GameLevel(trackNum, difficulty);
			this.addChildAt(_game, 1);
			_game.addEventListener(Event.COMPLETE, onGameComplete, false, 0, true);
		}
		
		private function onGameComplete(evt:Event = null):void
		{
			_total = _game.notesCount;
			_score = _game.notesScore;
			
			_game.removeEventListener(Event.COMPLETE, onGameComplete);
			//TODO: do this right
			this.removeChild(_game);
			_game = null;
			
			_screensMusicSC = _screensMusic.play(0, 99999);
			
			gotoSummaryScreen();
		}
	}
}