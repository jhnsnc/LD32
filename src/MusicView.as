package
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import net.design4learning.MusicTracker_v03.MusicTracker;
	
	public class MusicView extends Sprite
	{
		private static const NOTE_SPEED:Number = 100.0;
		private static const NOTE_TARGET:Number = 500.0;
		private static const NOTE_HIT_SENSITIVITY:Number = 150.0;
		
		private var _mv:Sprite;
		private var _musicTracker:MusicTracker;
		
		private var _objectPool:ObjectPoolManager;
		
		private var _flashes:Array;
		private var _notes:Array;
		private var _notesData:Array;
		private var _patternData:Array;
		
		private var _deadLineGlow:GlowFilter;
		private var _gameGridGlow:GlowFilter;
		
		private var _trackNum:int;
		private var _difficulty:String;
		
		public var notesCount:uint;
		public var notesScore:uint;
		
		public function MusicView(tracker:MusicTracker, trackNum:int, difficulty:String)
		{
			_musicTracker = tracker;
			_trackNum = trackNum;
			_difficulty = difficulty;
			super();
			init();
		}
		
		private function init():void {
			//MonsterDebugger.trace(this, "Setting up music view");
			
			var i:uint;
			_objectPool = ObjectPoolManager.getInstance();
			if (_trackNum == 1) {
				if (_difficulty == "easy") {
					_patternData = GamePatterns.track1_easy.slice(0);
				} else {
					_patternData = GamePatterns.track1_hard.slice(0);
				}
			} else {
				if (_difficulty == "easy") {
					_patternData = GamePatterns.track2_easy.slice(0);
				} else {
					_patternData = GamePatterns.track2_hard.slice(0);
				}
			}
			
			_mv = new GameAssets.musicView();
			this.addChild(_mv);
			
			//get button "flashes" and hide them
			_flashes = new Array();
			for (i = 0; i < GameAssets.buttonIds.length; i++) {
				_flashes.push(_mv.getChildByName(""+GameAssets.buttonIds[i]+"Flash"));
				_flashes[i].alpha = 0.0;
			}
			
			//get glow filters (for modifying to the beat)
			_deadLineGlow = Object(_mv).deadLine.filters[0];
			_gameGridGlow = Object(_mv).gameGrid.filters[0];
			
			_notes = new Array();
			
			//MonsterDebugger.trace(this, "Music view is ready");
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			_musicTracker.addEventListener(MusicTracker.TRACK_STOP, onTrackStop, false, 0, true);
			
			notesCount = _patternData.length;
			notesScore = 0;
		}
		
		public function cleanup():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
			this.removeEventListener(MusicTracker.TRACK_STOP, onTrackStop);
		}
		
		private function onTrackStop(evt:Event = null):void {
			cleanup();
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function update(evt:Event = null):void {
			var i:uint;
			var currentBeat:Number = _musicTracker.currentBeat;
			
			//update note positions
			for (i = 0; i < _notes.length; i++) {
				_notes[i].asset.y = NOTE_TARGET + (currentBeat - _notes[i].beat) * NOTE_SPEED;
				if (_notes[i].asset.y > 550.0) {
					//note out of bounds - return to pool and remove
					this.removeChild(_notes[i].asset);
					_objectPool.returnNote(_notes[i].asset, getSizeFromButtonIdx(_notes[i].button));
					_notes.asset = null;
					_notes.splice(i, 1);
					i--;
				}
			}
			
			//check MusicManager for upcoming notes
			while ( _patternData.length > 0 && 
					_patternData[0].beat < currentBeat + 5.1 ) {
				var note:Object = _patternData.shift();
				note.asset = _objectPool.getNote(getSizeFromButtonIdx(note.button));
				
				note.asset.y = NOTE_TARGET + (currentBeat - note.beat) * NOTE_SPEED;
				note.asset.x = _mv.getChildByName(""+GameAssets.buttonIds[note.button]+"Target").x;
				this.addChild(note.asset);
				
				_notes.push(note);
			}
			
			//glow pulses
			var glowAlpha:Number = Math.pow(2 * Math.abs((currentBeat - Math.floor(currentBeat)) - 0.5), 2.0);
			_deadLineGlow.alpha = glowAlpha;
			_gameGridGlow.alpha = glowAlpha;
			Object(_mv).deadLine.filters = [_deadLineGlow];
			Object(_mv).gameGrid.filters = [_gameGridGlow];
			
			//MonsterDebugger.trace(this, "notes: "+_notes.length+" / patternData: "+_patternData.length);
		}
		
		public function handleButtonPress(buttonIdx:uint):void
		{
			//show button hit "flash"
			if (buttonIdx < _flashes.length) {
				_flashes[buttonIdx].alpha = 1.0;
				TweenMax.to(_flashes, 0.5, {overwrite: true, alpha:0.0});
			}
			
			//check for hit notes
			var currentBeat:Number = _musicTracker.currentBeat;
			var timePerBeat:Number = _musicTracker.timePerBeat;
			for (var i:uint = 0; i < _notes.length; i++) {
				if (_notes[i].button == buttonIdx) {
					var diff:Number = (_notes[i].beat - currentBeat) * timePerBeat;
					if (diff < -1 * NOTE_HIT_SENSITIVITY) { //note too late, let it go
						continue;
					} else {
						if (diff < NOTE_HIT_SENSITIVITY) {
							//it's a hit! score it, remove it, and stop checking other notes
							notesScore++;
							
							this.removeChild(_notes[i].asset);
							_objectPool.returnNote(_notes[i].asset, getSizeFromButtonIdx(_notes[i].button));
							_notes.splice(i, 1);
							
							break;
						} else {
							break;
						}
					}
				}
			}
		}
		
		private function getSizeFromButtonIdx(buttonIdx:uint):String {
			switch (buttonIdx) {
				case 1: case 5:
					return "small";
					break;
				case 3:
					return "large";
					break;
				case 0: case 2:
				case 4: case 6:
				default:
					return "normal";
					break;
			}
		}
	}
}