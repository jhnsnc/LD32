package
{
	public class GameAssets
	{
		[Embed(source="assets/screens.swf", symbol='screens')]
		public static const basicScreens:Class;
		
		[Embed(source="assets/menuMusic.mp3")]
		public static const menuMusic:Class;
		
		[Embed(source="assets/music1.mp3")]
		public static const musicTrack1:Class;
		public static const musicTrack1_timeSignatures:Array = [{firstBeatAt: 6, beatsPerMinute: 153.0}]; //6
		
		[Embed(source="assets/music2.mp3")]
		public static const musicTrack2:Class;
		public static const musicTrack2_timeSignatures:Array = [{firstBeatAt: 31, beatsPerMinute: 164.0}]; //31
		
		public static const buttonIds:Array = ["s", "d", "f", "space", "j", "k", "l"];
		
		[Embed(source="assets/assets.swf", symbol='noteSmall')]
		public static const noteSmall:Class;
		[Embed(source="assets/assets.swf", symbol='noteNormal')]
		public static const noteNormal:Class;
		[Embed(source="assets/assets.swf", symbol='noteLarge')]
		public static const noteLarge:Class;
		
		[Embed(source="assets/assets.swf", symbol='musicView')]
		public static const musicView:Class;
		
		[Embed(source="assets/assets.swf", symbol='volumeControl')]
		public static const volumeControl:Class;
		
		public function GameAssets()
		{
		}
	}
}