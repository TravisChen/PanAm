package
{
	import org.flixel.FlxSprite;
	
	public class BubblePlayer extends FlxSprite
	{
		[Embed(source='../data/Notifications.png')] private var ImgBubble:Class;
		
		private var _player:Player;
		
		public function BubblePlayer(X:int,Y:int,player:Player):void
		{		
			_player = player;
			
			super(X,Y);
			
			loadGraphic(ImgBubble, true, true, 100, 100);
			width = 100;
			height = 100;
			
			offset.x = width/2;
			offset.y = height + 30;
				
			addAnimation("peanut", [0]);
			addAnimation("coffee", [1]);
			addAnimation("water", [2]);
			addAnimation("beer", [3]);
			addAnimation("happy", [4]);
			addAnimation("cell", [5, 6], 5);
		}
		
		override public function update():void
		{
			x = _player.x;
			y = _player.y;
			offset.y = height * _player.scale.y + 30;
			scale.x = _player.scale.x;
			scale.y = _player.scale.y;
			
			alpha = 1.0;
			switch( _player.itemArray[0] )
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
