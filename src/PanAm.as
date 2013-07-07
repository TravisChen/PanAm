package
{
	import org.flixel.*; 
	[SWF(width="1400", height="900", backgroundColor="#faf2e5")] 
	
	public class PanAm extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function PanAm()
		{
			super(1400,900,PlayState,1);
			forceDebugger = true;
		}
	}
}