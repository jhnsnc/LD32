package
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import net.design4learning.MusicTracker_v03.MusicTracker;
	
	public class GameLevel extends Sprite
	{
		private var _musicView:MusicView;
		private var _musicTracker:MusicTracker;
		
		private var _trackNum:int;
		private var _difficulty:String;
		
		public var notesCount:uint;
		public var notesScore:uint;
		
		public function GameLevel(trackNum:int, difficulty:String)
		{
			_trackNum = trackNum;
			_difficulty = difficulty;
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0 , true);
		}
		
		private function init(evt:Event = null):void {
			//MonsterDebugger.trace(this, "Setting up level");
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (_trackNum == 1) {
				_musicTracker = new MusicTracker(new GameAssets.musicTrack1(), GameAssets.musicTrack1_timeSignatures.slice(0)[0]);
			} else {
				_musicTracker = new MusicTracker(new GameAssets.musicTrack2(), GameAssets.musicTrack2_timeSignatures.slice(0)[0]);
			}
			
			_musicView = new MusicView(_musicTracker, _trackNum, _difficulty);
			
			//setup keyboard listening
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
			
			//start it up!
			this.addChild(_musicView);
			_musicTracker.play();
			
			_musicView.addEventListener(Event.COMPLETE, onGameComplete, false, 0, true);
		}
		
		public function cleanup():void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_musicView.removeEventListener(Event.COMPLETE, onGameComplete);
		}
		
		private function onGameComplete(evt:Event = null):void
		{
			notesCount = _musicView.notesCount;
			notesScore = _musicView.notesScore;
			cleanup();
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function handleKeyDown(evt:KeyboardEvent):void
		{
			switch(evt.keyCode) {
				case Keyboard.S:
					_musicView.handleButtonPress(0);
					break;
				case Keyboard.D:
					_musicView.handleButtonPress(1);
					break;
				case Keyboard.F:
					_musicView.handleButtonPress(2);
					break;
				case Keyboard.SPACE:
					_musicView.handleButtonPress(3);
					break;
				case Keyboard.J:
					_musicView.handleButtonPress(4);
					break;
				case Keyboard.K:
					_musicView.handleButtonPress(5);
					break;
				case Keyboard.L:
					_musicView.handleButtonPress(6);
					break;
			}
		}
	}
}