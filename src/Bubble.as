package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Bubble extends FlxSprite
	{
		[Embed(source='../data/Notifications.png')] private var ImgBubble:Class;
		
		private var _chair:Chair;
		private var _passenger:Passenger;
		
		private var bounceTime:Number = 0.2;
		private var bounceTimer:Number = bounceTime;
		private var bounceToggle:Boolean = false;
		
		public function Bubble(X:int,Y:int, passenger:Passenger, chair:Chair):void
		{
			_chair = chair;
			_passenger = passenger;
			
			super(X,Y);
			
			loadGraphic(ImgBubble, true, true, 100, 100);
			width = 100;
			height = 100;
			
			if( _chair.tileX == 0 || _chair.tileX == 1 || _chair.tileX == 4 )
			{
				offset.x = width/2 - 20;
				facing = RIGHT;
			}
			else
			{
				offset.x = width/2 + 20;
				facing = LEFT;
			}
			offset.y = height/2 - 5;
			
			addAnimation("peanut", [0]);
			addAnimation("coffee", [1]);
			addAnimation("water", [2]);
			addAnimation("beer", [3]);
			addAnimation("happy", [4, 7], 5);
			addAnimation("cell", [5, 6], 5);
		}
		
		public function updateBounce():void 
		{		
			if( bounceTimer <= 0 )
			{
				bounceTimer = bounceTime;
				if( bounceToggle )
				{
					y += 8;
					bounceToggle = false;
				}
				else
				{
					y -= 8;
					bounceToggle = true;
				}
			}
			else
			{
				bounceTimer -= FlxG.elapsed;
			}
		}
		
		override public function update():void
		{
			if( _passenger.happy )
			{
				play( "happy" );
				return;
			}
			
			updateBounce();
			
			alpha = 1.0;
			switch( _passenger.want )
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
