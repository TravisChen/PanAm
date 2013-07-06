package    {
		
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	
	public class Level_Main extends Level{
	
		// Points
		private var pointsText:FlxText;

		// Timer
		public var startTime:Number;
		public var endTime:Number;
		private var timerText:FlxText;

		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndPointsText:FlxText;
		
		// Consts
		public const MAX_TIME:uint = 10;
		public const TEXT_COLOR:uint = 0xFF555555;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 1400;
			levelSizeY = 900;

			// Create player
			player = new Player(FlxG.height*1/4,FlxG.height/2);
			PlayState.groupPlayer.add(player);
			
			// Chairs
			createChairs();
			
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
			
			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			super();
		}
		
		public function createChairs():void {
			
			var startX:int = 0;
			var startY:int = 20;
			var chairSpacingX:int = 76;
			var chairSpacingY:int = 60;
			var rowArray:Array = new Array( FlxG.width/2 - chairSpacingX*3.5, FlxG.width/2 - chairSpacingX*2.5, 0, FlxG.width/2 - chairSpacingX*0.5, 
											FlxG.width/2 + chairSpacingX*0.5, 0, FlxG.width/2 + chairSpacingX*2.5, FlxG.width/2 + chairSpacingX*3.5 );
			var numRows:int = 10;

			// Loop through rows
			var perspective:int = 0;
			var perspectiveAmmount:int = 10;
			var chairScale:Number = 1.0;
			var chairScaleStart:Number = 1.0;
			var chairScaleAmmount:Number = 0.025;
			for( var i:int = 0; i < numRows; i++ )
			{
				chairScale = chairScaleStart - chairScaleAmmount * (numRows - i);
				for( var j:int = 0; j < rowArray.length; j++ )
				{
					if( rowArray[j] != 0 )
					{
						var chair:Chair;
						var perspectiveScalar:Number;
						if( j < rowArray.length / 2 )
						{
							perspectiveScalar = 1.15 - (j / ( (rowArray.length / 2) - 1 ) );
							chair = new Chair(startX + rowArray[j] - ( perspective * perspectiveScalar ), startY + i*chairSpacingY, chairScale);
						}
						else
						{
							perspectiveScalar = ( ( j - ( (rowArray.length / 2) - 1) ) / ( (rowArray.length / 2) - 1 ) ) - 0.15;
							chair = new Chair(startX + rowArray[j] + ( perspective * perspectiveScalar ), startY + i*chairSpacingY, chairScale);
						}
					
						PlayState.groupChairs.add(chair);	
					}
				}
				perspective += perspectiveAmmount;
			}	
		}
		
		public function turbulence():void {
			
			FlxG.shake(0.01, 0.5);
			
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
			turbulence();

			// BG color
			FlxG.bgColor = 0xFFfaf2e5;
			
			// Timer
			updateTimer();

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
