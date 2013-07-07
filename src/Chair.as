package
{
	import org.flixel.FlxSprite;
	
	public class Chair extends CabinItem
	{
		[Embed(source='../data/chair.png')] private var ImgChair:Class;
		
		public var passenger:Passenger;
		
		public function Chair(X:int,Y:int,chairScale:Number,_tileX:int, _tileY:int):void
		{
			tileX = _tileX;
			tileY = _tileY;
			
			super(X,Y,false);
			
			loadGraphic(ImgChair, true, true, 113, 150);
			width = 113;
			height = 150;
			offset.x = width/2;
			scale.x = chairScale;
			scale.y = chairScale;
			color = 0xffb4b4b4;
			
			passenger = new Passenger(x, y + 1, chairScale, this);
			PlayState.groupSort.add(passenger);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
