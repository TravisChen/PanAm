package
{
	import org.flixel.FlxSprite;
	
	public class CabinItem extends FlxSprite
	{
		public var isAisle:Boolean = false;
		public var tileX:int = 0;
		public var tileY:int = 0;
		
		public function CabinItem(X:int,Y:int, aisle:Boolean):void
		{
			isAisle = aisle;
			super(X,Y);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
