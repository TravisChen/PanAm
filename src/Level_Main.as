package    {
		
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class Level_Main extends Level{
		
		[Embed(source="../data/Main-bg.png")] private var ImgBackground:Class;
		[Embed(source="../data/Game-Over-bg.png")] private var ImgRoundOver:Class;
		
		[Embed(source = '../data/sound/start.mp3')] private var SndStart:Class;
		[Embed(source = '../data/sound/music-loop.mp3')] private var SndLoop:Class;
		[Embed(source = '../data/sound/fail.mp3')] private var SndEnd:Class;
		[Embed(source = '../data/sound/explode.mp3')] private var SndExplode:Class;
		
		[Embed(source="../data/vagroundedstdblack.ttf", fontFamily="VA", embedAsCFF="false"))] private var FontVA:String;
		
		// Points
		private var pointsText:FlxText;
		
		public var pickupCoffee:PickUp;
		public var pickupWater:PickUp;
		public var pickupBeer:PickUp;
		
		// Want Spawner
		public var wantSpawner:WantSpawner;
		
		// Cabin
		public var cabin:Array;
		public var chairs:Array;
		
		// Random turbulence
		public var turbulencePeriodSmall:Number = 0.1;
		public var turbulencePeriodLarge:Number = 0.5;
		public var turbulenceTime:Number = 0.0;
		public var turbulenceMinTime:Number = 2;
		public var turbulenceMaxTime:Number = 4;
		public var turbulenceAmmountSmall:Number = 0.002;
		public var turbulenceAmmountLarge:Number = 0.006;
		public var randomTurbulence:Number = turbulenceMinTime;
	
		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndPointsText:FlxText;
		private var roundEndBackground:FlxSprite;
		public var endTime:Number = 1.75;
		
		// Consts
		public const MAX_TIME:uint = 10;
		public const TEXT_COLOR:uint = 0xFFFF4E00;
		
		private var musicStarted:Boolean = false;
		private var musicEnd:Boolean = false;
		private var soundTime:Number = 1.75;
		private var soundTimer:Number = soundTime;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 1440;
			levelSizeY = 900;

			// Chairs
			createCabin();
			
			// Create want spawner
			wantSpawner = new WantSpawner( chairs );
			PlayState.groupHudSort.add( wantSpawner );
			
			// Create pickup points
			pickupCoffee = new PickUp( FlxG.width/4 + 20, 850, 0, player, 1.0 );
			PlayState.groupHudSort.add(pickupCoffee);
			
			pickupWater = new PickUp( FlxG.width/2 - 5, 850, 1, player, 1.0 );
			PlayState.groupHudSort.add(pickupWater);
			
			pickupBeer = new PickUp( FlxG.width* 3/4 - 20, 850, 2, player, 1.0 );
			PlayState.groupHudSort.add(pickupBeer);
			
			// Create player
			player = new Player( cabin, wantSpawner, pickupCoffee, pickupWater, pickupBeer );
			PlayState.groupSort.add(player);
						
			// Points
			points = 0;
			pointsText = new FlxText(FlxG.width - 250, 56, FlxG.width/8, "0");
			pointsText.setFormat("VA",64,TEXT_COLOR,"center");
			pointsText.scrollFactor.x = pointsText.scrollFactor.y = 0;
			pointsText.alpha = 1;
			PlayState.groupForeground.add(pointsText);
			
			// Background
			var background:FlxSprite;
			background = new FlxSprite(-40,-40);
			background.loadGraphic(ImgBackground, true, true, levelSizeX + 80, levelSizeY + 80);	
			PlayState.groupBackground.add(background);
			
			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			super();
		}
		
		public function createCabin():void {
			
			cabin = new Array();
			chairs = new Array()
			
			var startX:int = 0;
			var startY:int = 0;
			var chairSpacingX:int = 76;
			var chairSpacingY:int = 60;
			var rowPosArray:Array = new Array( FlxG.width/2 - chairSpacingX*3.5, FlxG.width/2 - chairSpacingX*2.5, FlxG.width/2 - chairSpacingX*1.5, FlxG.width/2 - chairSpacingX*0.5, 
											   FlxG.width/2 + chairSpacingX*0.5, FlxG.width/2 + chairSpacingX*1.5, FlxG.width/2 + chairSpacingX*2.5, FlxG.width/2 + chairSpacingX*3.5 );
			var isChairArray:Array = new Array( 1, 1, 0, 1, 1, 0, 1, 1 );
			var isChairArrayBack:Array = new Array( -1, -1, 0, 0, 0, 0, -1, -1 );
			var isChairArrayMiddle:Array = new Array( 1, 1, 0, 0, 0, 0, 1, 1 );
			var isChairArrayFront:Array = new Array( 0, 0, 0, 0, 0, 0, 0, 0 );
			var numRows:int = 12;

			// Loop through rows
			var perspective:int = 0;
			var perspectiveAmmount:int = 10;
			var chairScale:Number = 1.0;
			var chairScaleStart:Number = 1.0;
			var chairScaleAmmount:Number = 0.025;
			for( var y:int = 0; y < numRows; y++ )
			{
				chairScale = chairScaleStart - chairScaleAmmount * (numRows - y);
				
				var row:Array = new Array();
				for( var x:int = 0; x < rowPosArray.length; x++ )
				{
					var perspectiveScalar:Number;
					var cabinItem:CabinItem;
					var chairArray:Array = isChairArray;
					if( y == 0 )
					{
						chairArray = isChairArrayBack;
					}
					
					if( y == 5 )
					{
						chairArray = isChairArrayMiddle;
					}
					
					if( y == numRows - 1 )
					{
						chairArray = isChairArrayFront;
					}
					
					if( chairArray[x] > 0 )
					{
						if( x < rowPosArray.length / 2 )
						{
							perspectiveScalar = 1.15 - (x / ( (rowPosArray.length / 2) - 1 ) );
							cabinItem = new Chair(startX + rowPosArray[x] - ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y, 1);
						}
						else
						{
							perspectiveScalar = ( ( x - ( (rowPosArray.length / 2) - 1) ) / ( (rowPosArray.length / 2) - 1 ) ) - 0.15;
							cabinItem = new Chair(startX + rowPosArray[x] + ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y, 1);
						}
					
						if( x != 0 && x != 7 )
						{
							chairs.push( cabinItem );
						}
					}
					else
					{
						if( x < rowPosArray.length / 2 )
						{
							perspectiveScalar = 1.15 - (x / ( (rowPosArray.length / 2) - 1 ) );
							cabinItem = new Aisle(startX + rowPosArray[x] - ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y, chairArray[x]);
						}
						else
						{
							perspectiveScalar = ( ( x - ( (rowPosArray.length / 2) - 1) ) / ( (rowPosArray.length / 2) - 1 ) ) - 0.15;
							cabinItem = new Aisle(startX + rowPosArray[x] + ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y, chairArray[x]);
						}
					}
					
					PlayState.groupSort.add(cabinItem);	
					row.push( cabinItem );
				}
				
				cabin.push( row );
				perspective += perspectiveAmmount;
			}	
		}
		
		public function updateTurbulence():void {
			
			randomTurbulence -= FlxG.elapsed;
			turbulenceTime -= FlxG.elapsed;
			
			if( turbulenceTime <= 0 )
			{
				if( randomTurbulence <= 0 )
				{
					FlxG.shake(turbulenceAmmountLarge, turbulencePeriodLarge);
					randomTurbulence = ( turbulenceMinTime + Math.random() * (turbulenceMaxTime - turbulenceMinTime) );
					turbulenceTime = turbulencePeriodLarge;
				}
				else
				{
					FlxG.shake(turbulenceAmmountSmall, turbulencePeriodSmall);
					turbulenceTime = turbulencePeriodSmall;
				}
				
			}
			
		}
		
		public function buildRoundEnd():void {
			// Background
			roundEndBackground:FlxSprite;
			roundEndBackground = new FlxSprite(-40,-40);
			roundEndBackground.loadGraphic(ImgRoundOver, true, true, levelSizeX + 80, levelSizeY + 80);	
			roundEndBackground.visible = false;
			PlayState.groupForeground.add(roundEndBackground);
			
			roundEndContinueText = new FlxText(0, FlxG.height/2 + 60, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat("VA",32,0xFF00A3FF,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndPointsText = new FlxText(0, FlxG.height/2 - 115, FlxG.width, "0");
			roundEndPointsText.setFormat("VA",160,TEXT_COLOR,"center");
			roundEndPointsText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndPointsText.visible = false;
			PlayState.groupForeground.add(roundEndPointsText);

			// Propellers
			var propellerLeft:Propeller = new Propeller( 0 - 50, 600 );
			PlayState.groupForeground.add(propellerLeft);	
			
			var propellerRight:Propeller = new Propeller( FlxG.width + 50, 600 );
			PlayState.groupForeground.add(propellerRight);
		}
		
		public function isDead():Boolean
		{
			for( var i:int = 0; i < chairs.length; i++ )
			{
				var chair:Chair = chairs[i];
				if( chair.passenger.bubble.countDownTimer <= 0 )
				{
					return true;
				}
			}
			return false;			
		}
		
		override public function update():void
		{	
			if( soundTimer == soundTime )
			{
				// Start sound
				FlxG.play( SndStart, 1.0 );
			}
			if( soundTimer > 0 )
			{
				soundTimer -= FlxG.elapsed;
			}
			else
			{
				if( !musicStarted )
				{
					musicStarted = true;
					FlxG.playMusic( SndLoop );
				}
			}
			
			// Turbulence
			updateTurbulence();
			
			// Want spawner update
			wantSpawner.update();

			// BG color
			FlxG.bgColor = 0xFFfaf2e5;
			
			// Player dead
			if( isDead() )
			{
				if( !musicEnd )
				{
					musicEnd = true;
					FlxG.music.stop();
					FlxG.play( SndExplode, 0.5 );
					FlxG.play( SndEnd );
				}
				
				PlayState._currLevel.player.roundOver = true;
				
				if( endTime <= 0 )
				{
					showEndPrompt();
					checkAnyKey();					
				}
				else
				{
					endTime -= FlxG.elapsed;
				}
				return;
			}
			
			// Update points text
			pointsText.text = "$" + points + "";
			roundEndPointsText.text = "$" + points + "";
			
			super.update();
		}
		
		private function showEndPrompt():void 
		{
			roundEndPointsText.visible = true;
			roundEndBackground.visible = true;
		}
		
		private function checkAnyKey():void 
		{
			roundEndContinueText.visible = true;
			if (FlxG.keys.any())
			{
				FlxG.flash(0xffffffff, 0.75);
				roundEnd = true;
			}	
		}
		
		override public function nextLevel():Boolean
		{
			if( roundEnd )
			{
				return true;
			}
			return false;
		}
	}
}
