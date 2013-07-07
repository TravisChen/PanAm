package
{
	import flash.display.StageDisplayState;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGame;

	[SWF(width="1440", height="900", backgroundColor="#faf2e5")] 
	
	public class PanAm extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function PanAm()
		{
			super(1440,900,PlayState,1);
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			forceDebugger = true;
		}
	}
}