package
{
	import org.flixel.FlxSprite;
	
	public class CabinItem extends FlxSprite
	{
		public var type:int = 0;
		public var tileX:int = 0;
		public var tileY:int = 0;
		
		public function CabinItem(X:int,Y:int, cabinType:uint):void
		{
			type = cabinType;
			
			super(X,Y);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
