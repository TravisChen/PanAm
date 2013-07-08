package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class WantSpawner extends FlxObject
	{
		private var _chairs:Array;

		public var wantTimer:Number;
		public var numWant:Number = 0;
		
		public var START_WANT:uint = 2;
		public var MAX_WANT:uint = 12;
		public var MAX_TIME:Number = 8.0;
		public var MIN_TIME:Number = 5.0;
		
		public var timer:Number = 0;
		public var difficultyTime:Number = 25.0;
		public var difficultyTimer:Number = difficultyTime;
		public var difficultyScalarDown:Number = 0.75;
		public var difficultyScalarUp:Number = 1.1;
		
		public var cellPhoneProbability:Number = 0.25;
		
		public function WantSpawner( chairs:Array )
		{
			super();
			
			_chairs = chairs;
			
			wantTimer = MAX_TIME;
			
			for (var i:int = 0; i < START_WANT; i++) {
				addWant( false );
			}
		}
		
		public function addWant( cells:Boolean ):void
		{
			var randomIndex:int = Helpers.randomInt(0, _chairs.length - 1);
			var chair:Chair = _chairs[randomIndex];
			
			if( chair.passenger.want == -1 )
			{
				if( cells && Math.random() <= cellPhoneProbability )
				{
					if( timer > 120 )
					{
						chair.passenger.bubble.countDownTime = 5.0;
					}
					chair.passenger.want = 3;
				}
				else
				{
					chair.passenger.want = Helpers.randomInt(0,2);
				}
				
				chair.passenger.wanting = true;
				chair.passenger.wantTimer = chair.passenger.wantTime;
				numWant++;
				
				if( chair.passenger.want == 3 )
				{
					chair.passenger.bubble.startCountdown();
				}
			}
		}
		
		public function isNearby():Boolean 
		{
			return false;
		}
		
		override public function update():void
		{
			timer += FlxG.elapsed;
			
			super.update();
			
			if( difficultyTimer >= 0 )
			{
				difficultyTimer -= FlxG.elapsed;
				
			}
			else
			{
//				MAX_WANT += 1;
//				if( MAX_WANT >= MAX_CAP )
//				{
//					MAX_WANT = MAX_CAP;
//				}
				MAX_TIME *= difficultyScalarDown;
				MIN_TIME *= difficultyScalarDown;
				
				// Cell phone prob
				cellPhoneProbability *= difficultyScalarUp;
				if( cellPhoneProbability >= 0.5 )
				{
					cellPhoneProbability = 0.5;
				}
				
				difficultyTimer = difficultyTime;
			}
			
			if( wantTimer >= 0 )
			{
				wantTimer -= FlxG.elapsed;
			}
			else
			{
				if( numWant < MAX_WANT )
				{
					addWant(true);
				}
				trace( numWant + ", " + MAX_WANT + ", " +  MAX_TIME + ", " + MIN_TIME );
				trace( wantTimer );
				wantTimer = ( Math.random() * ( MAX_TIME - MIN_TIME ) ) + MIN_TIME;
			}
		}
	}
}