package
{
	import org.flixel.*;
	
	public class Propeller extends FlxSprite
	{
		[Embed(source='../data/propeller.png')] private var ImgPropeller:Class;

		public function Propeller(X:int,Y:int):void
		{
			super(X,Y);
			
			loadGraphic(ImgPropeller, true, true, 375, 375);
			width = 375;
			height = 375;
			
			offset.x = width/2;
			offset.y = height/2;
		}
		
		override public function update():void
		{
			angle += 12;
			super.update();
		}
	}
}
