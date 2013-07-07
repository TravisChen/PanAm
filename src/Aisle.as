package
{
	import org.flixel.FlxSprite;
	
	public class Aisle extends CabinItem
	{
		[Embed(source='../data/chair.png')] private var ImgChair:Class;
		
		public function Aisle(X:int,Y:int,chairScale:Number,_tileX:int, _tileY:int, type:int):void
		{
			tileX = _tileX;
			tileY = _tileY;
			
			super(X,Y,type);
			
			loadGraphic(ImgChair, true, true, 113, 150);
			width = 113;
			height = 150;
			offset.x = width/2;
			scale.x = chairScale;
			scale.y = chairScale;
			
			alpha = 0.0;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
