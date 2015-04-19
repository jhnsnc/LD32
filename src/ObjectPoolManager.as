package
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;

	public class ObjectPoolManager
	{
		private static var _instance:ObjectPoolManager;
		
		//VARIABLES
		private const INITIAL_SMALL_NOTE_POOL_SIZE:uint = 20;
		private const INITIAL_NORMAL_NOTE_POOL_SIZE:uint = 20;
		private const INITIAL_LARGE_NOTE_POOL_SIZE:uint = 20;
		
		private var _notesSmall:Array;
		private var _notesNormal:Array;
		private var _notesLarge:Array;
		
		//FUNCTIONS
		public function ObjectPoolManager(singleton:SingletonEnforcer)
		{
			if(!singleton) throw new Error("You cannot instantiate the ObjectPoolManager class using the constructor. Please use ObjectPoolManager.getInstance() instead.");
			initialize();
		}
		
		static public function getInstance():ObjectPoolManager
		{
			if(!_instance)
			{
				_instance = new ObjectPoolManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public function initialize():void
		{
			var i:uint;
			var mc:Sprite;
			
			//create notes
			_notesSmall = new Array();
			for (i = 0; i < INITIAL_SMALL_NOTE_POOL_SIZE; i++) {
				mc = new GameAssets.noteSmall();
				_notesSmall.push({inUse: false, asset: mc});
			}
			_notesNormal = new Array();
			for (i = 0; i < INITIAL_NORMAL_NOTE_POOL_SIZE; i++) {
				mc = new GameAssets.noteNormal();
				_notesNormal.push({inUse: false, asset: mc});
			}
			_notesLarge = new Array();
			for (i = 0; i < INITIAL_LARGE_NOTE_POOL_SIZE; i++) {
				mc = new GameAssets.noteLarge();
				_notesLarge.push({inUse: false, asset: mc});
			}
		}
		
		public function getNote(size:String):Object
		{
			//MonsterDebugger.trace(this, "small: "+_notesSmall.length+" / normal: "+_notesNormal.length+" / large: "+_notesLarge.length);
			
			var result:Sprite;
			var i:uint;
			
			if (size == "small") {
				for (i = 0; i < _notesSmall.length; i++) {
					if (!_notesSmall[i].inUse) {
						_notesSmall[i].inUse = true;
						result = _notesSmall[i].asset;
						_notesSmall.push(_notesSmall.splice(i, 1)[0]); //move to end of array
						
						//reset values before sending
						//FIXME TweenMax.set(result, {scaleX: 1.0, scaleY: 1.0, alpha: 1.0, tint: null});
						return result;
					}
				}
				//none found -- generate a new one and add it to the pool
				result = new GameAssets.noteSmall();
				_notesSmall.push({inUse: true, asset: result});
				
				return result;
			} else if (size == "large") {
				for (i = 0; i < _notesLarge.length; i++) {
					if (!_notesLarge[i].inUse) {
						_notesLarge[i].inUse = true;
						result = _notesLarge[i].asset;
						_notesLarge.push(_notesLarge.splice(i, 1)[0]); //move to end of array
						
						//reset values before sending
						//FIXME TweenMax.set(result, {scaleX: 1.0, scaleY: 1.0, alpha: 1.0, tint: null});
						return result;
					}
				}
				//none found -- generate a new one and add it to the pool
				result = new GameAssets.noteLarge();
				_notesLarge.push({inUse: true, asset: result});
				
				return result;
			} else {
				for (i = 0; i < _notesNormal.length; i++) {
					if (!_notesNormal[i].inUse) {
						_notesNormal[i].inUse = true;
						result = _notesNormal[i].asset;
						_notesNormal.push(_notesNormal.splice(i, 1)[0]); //move to end of array
						
						//reset values before sending
						//FIXME TweenMax.set(result, {scaleX: 1.0, scaleY: 1.0, alpha: 1.0, tint: null});
						return result;
					}
				}
				//none found -- generate a new one and add it to the pool
				result = new GameAssets.noteNormal();
				_notesNormal.push({inUse: true, asset: result});
				
				return result;
			}
		}
		
		public function returnNote(asset:Sprite, size:String):void
		{
			var i:uint;
			
			if (size == "small") {
				for (i = 0; i < _notesSmall.length; i++) {
					if (_notesSmall[i].asset == asset) {
						_notesSmall[i].inUse = false;
						break;
					}
				}
			} else if (size == "large") {
				for (i = 0; i < _notesLarge.length; i++) {
					if (_notesLarge[i].asset == asset) {
						_notesLarge[i].inUse = false;
						break;
					}
				}
			} else {
				for (i = 0; i < _notesNormal.length; i++) {
					if (_notesNormal[i].asset == asset) {
						_notesNormal[i].inUse = false;
						break;
					}
				}
			}
		}
	}
}

class SingletonEnforcer
{
	public function SingletonEnforcer(){};
}