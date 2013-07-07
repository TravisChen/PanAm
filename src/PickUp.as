package
{
	import org.flixel.*;
	
	public class PickUp extends FlxSprite
	{
		[Embed(source='../data/Notifications-no-bubble.png')] private var ImgPickUp:Class;
		
		public var type:int = 0;
		
		public var pulseTime:Number = 0.1;
		public var pulseTimer:Number = 0.0;
		public var _pickUpScale:Number;
		
		public function PickUp(X:int,Y:int, _type:int, player:Player, pickUpScale:Number):void
		{	
			_pickUpScale = pickUpScale;
			type = _type;
			
			super(X,Y);
			
			loadGraphic(ImgPickUp, true, true, 200, 200);
			width = 200;
			height = 200;
			offset.x = width/2;
			offset.y = height/2;
			scale.x = pickUpScale;
			scale.y = pickUpScale;
			
			addAnimation("peanut", [0]);
			addAnimation("coffee", [1]);
			addAnimation("water", [2]);
			addAnimation("beer", [3]);
			addAnimation("happy", [4]);
			addAnimation("cell", [5, 6], 5);
		}
		
		public function pulse():void 
		{
			pulseTimer = pulseTime;
		}

		public function pulseUpdate():void
		{
			if( pulseTimer > 0 )
			{
				scale.x = _pickUpScale - 0.25;
				scale.y = _pickUpScale - 0.25;
				pulseTimer -= FlxG.elapsed;
			}
			else
			{
				scale.x = _pickUpScale;
				scale.y = _pickUpScale;
			}
		}
		
		override public function update():void
		{
			pulseUpdate();
			
			alpha = 1.0;
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
