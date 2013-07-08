package    {
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class Level_Menu extends Level{
		
		[Embed(source = '../data/arrow-keys.png')] private var ImgWasd:Class;
		[Embed(source = '../data/title-background.png')] private var ImgBackground:Class;
		[Embed(source = '../data/title-logo.png')] private var ImgLogo:Class;
		[Embed(source = '../data/title-clouds-back.png')] private var ImgCloudBack:Class;
		[Embed(source = '../data/title-clouds-front.png')] private var ImgCloudFront:Class;
		[Embed(source = '../data/sound/intro.mp3')] private var SndIntro:Class;
		
		public var wasd:FlxSprite;
		public var wasdFadeInTime:Number;
		public var wasdBounceTime:Number;
		public var wasdBounceToggle:Boolean;
		
		public var startTime:Number;
		
		public var introSound:Boolean = false;
		
		public var cloudBackTime:Number = 2.0;
		public var cloudBackTimer:Number = cloudBackTime;
		public var cloudBackToggle:Boolean = false;
		
		public var cloudFrontTime:Number = 5.0;
		public var cloudFrontTimer:Number = cloudBackTime;
		public var cloudFrontToggle:Boolean = false;
		
		public var cloudBack:FlxSprite;
		public var cloudFront:FlxSprite;
		
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
			
			// Background
			var background:FlxSprite;
			background = new FlxSprite(-40,-40);
			background.loadGraphic(ImgBackground, true, true, levelSizeX + 80, levelSizeY + 80);	
			background.visible = true;
			PlayState.groupBackground.add(background);

			// Background
			cloudBack = new FlxSprite(-40,-40);
			cloudBack.loadGraphic(ImgCloudBack, true, true, levelSizeX + 80, levelSizeY + 80);	
			cloudBack.visible = true;
			PlayState.groupBackground.add(cloudBack);
			
			// Background
			cloudFront = new FlxSprite(-40,-40);
			cloudFront.loadGraphic(ImgCloudFront, true, true, levelSizeX + 80, levelSizeY + 80);	
			cloudFront.visible = true;
			PlayState.groupBackground.add(cloudFront);
			
			// Background
			var logo:FlxSprite;
			logo = new FlxSprite(-40,-40);
			logo.loadGraphic(ImgLogo, true, true, levelSizeX + 80, levelSizeY + 80);	
			logo.visible = true;
			PlayState.groupBackground.add(logo);
		}
		
		public function createWasd():void {
			// Create wasd
			wasd = new FlxSprite(0,0);
			wasd.loadGraphic(ImgWasd, true, true, 350, 150);	
			wasd.offset.x = 350/2;
			wasd.offset.y = 150/2;
			wasd.x = FlxG.width/2 + 16;
			wasd.y = FlxG.height/2 + 150;
			wasd.alpha = 0;
			
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
							wasd.y += 4;
							wasdBounceToggle = false;
						}
						else
						{
							wasd.y -= 4;
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
		
		public function updateClouds():void 
		{
			// Back
			if( cloudBackTimer <= 0 )
			{
				cloudBackTimer = cloudBackTime;
				if( cloudBackToggle )
				{
					cloudBackToggle = false;
				}
				else
				{
					cloudBackToggle = true;
				}
			}
			else
			{
				cloudBackTimer -= FlxG.elapsed;
				if( cloudBackToggle )
				{
					cloudBack.y += 0.2;
				}
				else
				{
					cloudBack.y -= 0.2;
				}
			}
			
			// Front
			if( cloudFrontTimer <= 0 )
			{
				cloudFrontTimer = cloudFrontTime;
				if( cloudFrontToggle )
				{
					cloudFrontToggle = false;
				}
				else
				{
					cloudFrontToggle = true;
				}
			}
			else
			{
				cloudFrontTimer -= FlxG.elapsed;
				if( cloudFrontToggle )
				{
					cloudFront.y -= 0.2;
				}
				else
				{
					cloudFront.y += 0.2;
				}
			}
		}
		
		override public function update():void
		{			
			updateClouds();
			
			if( !introSound )
			{
				FlxG.play( SndIntro );
				introSound = true;
			}
			updateWasd();
			
			// BG color
			FlxG.bgColor = 0xFFfaf2e5;
			
			super.update();
		}	
	}
}
