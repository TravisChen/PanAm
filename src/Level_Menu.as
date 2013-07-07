package    {
	
	import org.flixel.*;
	
	public class Level_Menu extends Level{
		
		[Embed(source = '../data/wasd.png')] private var ImgWasd:Class;
		
		public var wasd:FlxSprite;
		public var wasdFadeInTime:Number;
		public var wasdBounceTime:Number;
		public var wasdBounceToggle:Boolean;
		
		public var startTime:Number;

		public function Level_Menu( group:FlxGroup ) {
			
			super();
			
			levelSizeX = 1440;
			levelSizeY = 900;
			
			startTime = 1.0;
			
			createForegroundAndBackground();
		}
		
		override public function nextLevel():Boolean
		{
			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return false;
			}
			
			if(FlxG.keys.any() )
			{
				return true;
			}
			return false;
		}
		
		public function createForegroundAndBackground():void {
			// Create wasd
			createWasd();
		}
		
		public function createWasd():void {
			// Create wasd
			wasd = new FlxSprite(0,0);
			wasd.loadGraphic(ImgWasd, true, true, 32, 32);	
			wasd.x = FlxG.width/2 - 16;
			wasd.y = FlxG.height * 3/4;
			wasd.alpha = 0;
			wasd.scale.x = 5.0;
			wasd.scale.y = 5.0;
			
			// Add to foreground
			PlayState.groupForeground.add(wasd);
			
			// Timer
			wasdFadeInTime = 0.5;
			wasdBounceToggle = true;
			wasdBounceTime = 0;
		}
		
		public function updateWasd():void 
		{		
			if( wasdFadeInTime <= 0 )
			{
				if( wasd.alpha < 1 )
				{
					wasd.alpha += 0.025;		
				}
				else
				{
					if( wasdBounceTime <= 0 )
					{
						wasdBounceTime = 0.02;
						if( wasdBounceToggle )
						{
							wasd.y += 6;
							wasdBounceToggle = false;
						}
						else
						{
							wasd.y -= 6;
							wasdBounceToggle = true;
						}
					}
					else
					{
						wasdBounceTime -= FlxG.elapsed;
					}
				}
			}
			else
			{
				wasdFadeInTime -= FlxG.elapsed;
			}
		}
		
		override public function update():void
		{			
			updateWasd();
			
			// BG color
			FlxG.bgColor = 0xFFfaf2e5;
			
			super.update();
		}	
	}
}
