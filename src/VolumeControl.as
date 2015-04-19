package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class VolumeControl extends Sprite
	{
		private var _asset:Sprite;
		
		private var _volume:Number;
		private var _isMuted:Boolean;
		
		public function VolumeControl()
		{
			super();
			init();
		}
		
		public function init():void
		{
			_isMuted = false;
			_volume = 0.75;
			
			_asset = new GameAssets.volumeControl();
			this.addChild(_asset);
			
			Sprite(_asset.getChildByName("volumeFill")).mouseEnabled = false;
			_asset.getChildByName("volumeFill").scaleX = _volume;
			
			Sprite(_asset.getChildByName("btnMute")).buttonMode = true;
			Sprite(_asset.getChildByName("volumeSelect")).buttonMode = true;
			Sprite(_asset.getChildByName("volumeSelect")).mouseChildren = false;
			
			//bind events
			_asset.getChildByName("btnMute").addEventListener(MouseEvent.CLICK, toggleMute, false, 0, true);
			_asset.getChildByName("volumeSelect").addEventListener(MouseEvent.CLICK, selectVolume, false, 0, true);
		}
		
		private function toggleMute(evt:Event = null):void
		{
			_isMuted = !_isMuted;
			
			if (_isMuted) {
				_asset.getChildByName("volumeFill").scaleX = 0.0;
			} else {
				_asset.getChildByName("volumeFill").scaleX = _volume;
			}
			
			setVolumeTransform( _isMuted ? 0.0 : _volume );
		}
		
		private function selectVolume(evt:MouseEvent):void
		{
			var perc:Number = evt.localX / _asset.getChildByName("volumeSelect").width;
			
			if (_isMuted) {
				_isMuted = false;
			}
			_volume = perc;
			_asset.getChildByName("volumeFill").scaleX = _volume;
			
			setVolumeTransform(_volume);
		}
		
		private function setVolumeTransform(vol:Number):void
		{
			SoundMixer.soundTransform = new SoundTransform(vol);
		}
	}
}