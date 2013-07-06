package
{
	import org.flixel.FlxSprite;
	
	public class Chair extends FlxSprite
	{
		[Embed(source='../data/chair.png')] private var ImgChair:Class;
		
		public function Chair(X:int,Y:int,chairScale:Number):void
		{
			super(X,Y);
			
			loadGraphic(ImgChair, true, true, 113, 150);
			width = 113;
			height = 150;
			offset.x = width/2;
			scale.x = chairScale;
			scale.y = chairScale;
			
			var passenger:Passenger = new Passenger(x, y, chairScale);
			PlayState.groupPassengers.add(passenger);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
