package
{
	import org.flixel.FlxSprite;
	
	public class PickUp extends FlxSprite
	{
		[Embed(source='../data/Notifications-no-bubble.png')] private var ImgPickUp:Class;
		
		public var type:int = 0;
		
		public function PickUp(X:int,Y:int, _type:int, player:Player):void
		{			
			type = _type;
			
			super(X,Y);
			
			loadGraphic(ImgPickUp, true, true, 200, 200);
			width = 200;
			height = 200;
			offset.x = width/2;
			offset.y = height/2;
			
			addAnimation("peanut", [0]);
			addAnimation("coffee", [1]);
			addAnimation("water", [2]);
			addAnimation("beer", [3]);
			addAnimation("happy", [4]);
			addAnimation("cell", [5, 6], 5);
		}
		
		override public function update():void
		{
			switch( type )
			{
				case 0:
					play( "coffee" );
					break;
				case 1:
					play( "water" );
					break;
				case 2:
					play( "beer" );
					break;
				case 3:
					play( "cell" );
					break;
				default:
					alpha = 0;
					break;
			}
			super.update();
		}
	}
}
