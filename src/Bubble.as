package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class Bubble extends FlxSprite
	{
		[Embed(source='../data/Notifications.png')] private var ImgBubble:Class;
		[Embed(source="../data/vagroundedstdblack.ttf", fontFamily="VA", embedAsCFF="false"))] private var FontVA:String;
		
		private var _chair:Chair;
		private var _passenger:Passenger;
		
		private var bounceTime:Number = 0.2;
		private var bounceTimer:Number = bounceTime;
		private var bounceToggle:Boolean = false;
		
		public var countDownTime:Number = 8.0;
		public var countDownTimer:Number;
		
		private var countDownText:FlxText;
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		
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
			
			
			// Countdown Text
			countDownText = new FlxText(0, 100, 32, "5");
			countDownText.setFormat("VA",28,TEXT_COLOR,"center");
			countDownText.alpha = 1;
			countDownText.offset.x = 0;
			countDownText.offset.y = 0;
			countDownText.x = x;
			countDownText.y = y;
			PlayState.groupForeground.add(countDownText);
			
			addAnimation("peanut", [0]);
			addAnimation("coffee", [1]);
			addAnimation("water", [2]);
			addAnimation("beer", [3]);
			addAnimation("happy", [4, 7], 5);
			addAnimation("cell", [5, 6], 5);
		}
		
		public function startCountdown():void
		{
			countDownTimer = countDownTime;
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

			if( facing == RIGHT )
			{
				countDownText.x = x + 32;
				countDownText.y = y - 47;
			}
			else
			{
				countDownText.x = x - 68;
				countDownText.y = y - 47;				
			}
			
			visible = true;
			countDownText.visible = false;
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
					countDownText.visible = true;;
					countDownText.text = "" + Math.ceil(countDownTimer) + "";
					
					countDownTimer -= FlxG.elapsed;
					if( countDownTimer <= 0 )
					{
						countDownText.text = "!";
					}
					
					break;
				default:
					visible = false;
					break;
			}
			super.update();
		}
	}
}
