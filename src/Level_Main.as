package    {
		
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class Level_Main extends Level{
		
		[Embed(source="../data/Main-bg.png")] private var ImgBackground:Class;
	
		// Points
		private var pointsText:FlxText;

		// Timer
		public var startTime:Number;
		public var endTime:Number;
		private var timerText:FlxText;
		
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
		
		// Consts
		public const MAX_TIME:uint = 10;
		public const TEXT_COLOR:uint = 0xFF555555;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 1440;
			levelSizeY = 900;

			// Chairs
			createCabin();
			
			// Create want spawner
			wantSpawner = new WantSpawner( chairs );
			PlayState.groupHudSort.add( wantSpawner );
			
			// Create player
			player = new Player( cabin, wantSpawner );
			PlayState.groupSort.add(player);
			
			// Create pickup points
			var pickupCoffee:PickUp = new PickUp( FlxG.width/4, 850, 0, player );
			PlayState.groupHudSort.add(pickupCoffee);

			var pickupWater:PickUp = new PickUp( FlxG.width/2, 850, 1, player );
			PlayState.groupHudSort.add(pickupWater);
			
			var pickupBeer:PickUp = new PickUp( FlxG.width* 3/4, 850, 2, player );
			PlayState.groupHudSort.add(pickupBeer);
			
			// Timer
			startTime = 1.0;
			endTime = 3.0;
			timer = MAX_TIME;
			timerText = new FlxText(0, 0, FlxG.width, "0:00");
			timerText.setFormat(null,64,TEXT_COLOR,"left");
			timerText.scrollFactor.x = timerText.scrollFactor.y = 0;
			timerText.alpha = 0;
			PlayState.groupBackground.add(timerText);
			
			// Points
			points = 0;
			pointsText = new FlxText(0, 0, FlxG.width, "0");
			pointsText.setFormat(null,64,TEXT_COLOR,"right");
			pointsText.scrollFactor.x = pointsText.scrollFactor.y = 0;
			pointsText.alpha = 0;
			PlayState.groupBackground.add(pointsText);
			
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
					
					if( chairArray[x] > 0 && y != numRows - 1 )
					{
						if( x < rowPosArray.length / 2 )
						{
							perspectiveScalar = 1.15 - (x / ( (rowPosArray.length / 2) - 1 ) );
							cabinItem = new Chair(startX + rowPosArray[x] - ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y);
						}
						else
						{
							perspectiveScalar = ( ( x - ( (rowPosArray.length / 2) - 1) ) / ( (rowPosArray.length / 2) - 1 ) ) - 0.15;
							cabinItem = new Chair(startX + rowPosArray[x] + ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y);
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
							cabinItem = new Aisle(startX + rowPosArray[x] - ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y);
						}
						else
						{
							perspectiveScalar = ( ( x - ( (rowPosArray.length / 2) - 1) ) / ( (rowPosArray.length / 2) - 1 ) ) - 0.15;
							cabinItem = new Aisle(startX + rowPosArray[x] + ( perspective * perspectiveScalar ), startY + y*chairSpacingY, chairScale, x, y);
						}
						
						if( chairArray[x] < 0 )
						{
							cabinItem.isAisle = false;
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
			roundEndContinueText = new FlxText(0, FlxG.height - 16, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat(null,8,TEXT_COLOR,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndPointsText = new FlxText(0, FlxG.height - 48, FlxG.width, "0");
			roundEndPointsText.setFormat(null,16,TEXT_COLOR,"center");
			roundEndPointsText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndPointsText.visible = false;
			PlayState.groupForeground.add(roundEndPointsText);
		}
		
		private function updateTimer():void
		{
			// Timer
			var minutes:uint = timer/60;
			var seconds:uint = timer - minutes*60;
			if( startTime <= 0 )
			{
				timer -= FlxG.elapsed;
			}
			else
			{
				startTime -= FlxG.elapsed;
			}
			
			// Check round end
			if( timer <= 0 )
			{
				showEndPrompt();
				if( endTime <= 0 )
				{
					checkAnyKey();					
				}
				else
				{
					endTime -= FlxG.elapsed;
				}
				return;
			}
			
			// Update timer text
			if( seconds < 10 )
				timerText.text = "" + minutes + ":0" + seconds;
			else
				timerText.text = "" + minutes + ":" + seconds;
		}
		
		override public function update():void
		{	
			// Turbulence
			updateTurbulence();
			
			// Want spawner update
			wantSpawner.update();

			// BG color
			FlxG.bgColor = 0xFFfaf2e5;
			
			// Timer
//			updateTimer();

			// Update points text
			pointsText.text = "" + points + " (" + PlayState._currLevel.multiplier + "x)";
			roundEndPointsText.text = "" + points;
			
			super.update();
		}
		
		private function showEndPrompt():void 
		{
			PlayState._currLevel.player.roundOver = true;
			roundEndPointsText.visible = true;
		}
		
		private function checkAnyKey():void 
		{
			roundEndContinueText.visible = true;
			if (FlxG.keys.any())
			{
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
