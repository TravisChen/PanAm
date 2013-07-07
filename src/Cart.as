package
{
	import org.flixel.FlxSprite;
	
	public class Cart extends FlxSprite
	{
		[Embed(source='../data/Cart.png')] private var ImgCart:Class;
		
		public function Cart(X:int,Y:int):void
		{
			super(X,Y);
			
			loadGraphic(ImgCart, true, true, 75, 100);
			width = 75;
			height = 100;
			offset.x = width/2;
			scale.x = 1.25;
			scale.y = 1.25;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
