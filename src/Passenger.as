package
{
	import org.flixel.FlxSprite;
	import Helpers;
	
	public class Passenger extends FlxSprite
	{
		[Embed(source='../data/passenger-boy1.png')] private var ImgPassenger:Class;
		
		public var bubble:Bubble;
		public var want:int = 4;
		
		private var _chair:Chair;
		
		public function Passenger(X:int,Y:int,passengerScale:Number, chair:Chair):void
		{	
			_chair = chair;
			
			super(X,Y);
			
			loadGraphic(ImgPassenger, true, true, 100, 150);
			width = 100;
			height = 150;
			offset.x = width/2;
			scale.x = passengerScale;
			scale.y = passengerScale;
			
			addAnimation("idle", [0,1,2,3], 10);
			
			bubble = new Bubble(x, y, this, chair);
			PlayState.groupHudSort.add(bubble);
			
			if( isWantingPassenger() )
			{
				want = Helpers.randomInt(0,10);
			}
			else
			{
				want = -1;
			}
		}
		
		public function isWantingPassenger():Boolean
		{
			if( _chair.tileX != 0 && _chair.tileX != 7 )
			{
				return true;
			}
			return false;
		}
		
		public function updateWant():void 
		{
		}
		
		override public function update():void
		{
			super.update();
			
			updateWant();
			
			play( "idle" );
		}
	}
}
