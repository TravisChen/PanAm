package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class WantSpawner extends FlxObject
	{
		private var _chairs:Array;

		public var currWant:uint;
		public var wantTimer:Number;
		public var numWant:Number = 0;
		
		public const START_WANT:uint = 2;
		public const MAX_WANT:uint = 6;
		public const MAX_TIME:Number = 8.0;
		public const MIN_TIME:Number = 5.0;
		
		public function WantSpawner( chairs:Array )
		{
			super();
			
			_chairs = chairs;
			
			wantTimer = MAX_TIME;
			
			for (var i:int = 0; i < START_WANT; i++) {
				addWant();
			}
		}
		
		public function addWant():void
		{
			var randomIndex:int = Helpers.randomInt(0, _chairs.length - 1);
			var chair:Chair = _chairs[randomIndex];
			
			if( chair.passenger.want == -1 )
			{
				chair.passenger.want = currWant;
				numWant++;
				
				updateCurrType();
			}
			
			if( chair.passenger.want == 3 )
			{
				chair.passenger.bubble.startCountdown();
			}
		}
		
		public function isNearby():Boolean 
		{
			return false;
		}
		
		public function updateCurrType():void 
		{
			currWant++;
			if( currWant >= 4 )
			{
				currWant = 0;				
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if( wantTimer >= 0 )
			{
				wantTimer -= FlxG.elapsed;
			}
			else
			{
				if( numWant < MAX_WANT )
				{
					addWant();
				}
				wantTimer = ( Math.random() * ( MAX_TIME - MIN_TIME ) ) + MIN_TIME;
			}
		}
	}
}