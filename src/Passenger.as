package
{
	import org.flixel.FlxSprite;
	
	public class Passenger extends FlxSprite
	{
		[Embed(source='../data/passenger-boy1.png')] private var ImgPassenger:Class;
		
		public function Passenger(X:int,Y:int,passengerScale:Number):void
		{
			super(X,Y);
			
			loadGraphic(ImgPassenger, true, true, 100, 150);
			width = 100;
			height = 150;
			offset.x = width/2;
			scale.x = passengerScale;
			scale.y = passengerScale;
			
			addAnimation("idle", [0,1,2,3], 10);
		}
		
		override public function update():void
		{
			super.update();
			
			play( "idle" );
		}
	}
}
