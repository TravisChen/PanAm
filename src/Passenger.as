package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Passenger extends FlxSprite
	{
		[Embed(source='../data/passenger-boy1.png')] private var ImgPassenger1:Class;
		[Embed(source='../data/passenger-boy2.png')] private var ImgPassenger2:Class;
		[Embed(source='../data/passenger-boy3.png')] private var ImgPassenger3:Class;
		[Embed(source='../data/passenger-boy4.png')] private var ImgPassenger4:Class;
		[Embed(source='../data/passenger-girl1.png')] private var ImgPassenger5:Class;
		[Embed(source='../data/passenger-girl2.png')] private var ImgPassenger6:Class;
		[Embed(source='../data/passenger-girl3.png')] private var ImgPassenger7:Class;
		[Embed(source='../data/passenger-girl4.png')] private var ImgPassenger8:Class;
		
		[Embed(source = '../data/sound/drink1.mp3')] private var SndDrink1:Class;
		[Embed(source = '../data/sound/drink2.mp3')] private var SndDrink2:Class;
		[Embed(source = '../data/sound/drink3.mp3')] private var SndDrink3:Class;
		[Embed(source = '../data/sound/drink4.mp3')] private var SndDrink4:Class;
		[Embed(source = '../data/sound/cell.mp3')] private var SndCell:Class;
		
		public var bubble:Bubble;
		public var want:int = -1;
		
		public var happy:Boolean = false;
		public var happyTime:Number = 1.5;
		public var happyTimer:Number = 0.0;
		
		public var sad:Boolean = false;
		public var sadTime:Number = 1.0;
		public var sadTimer:Number = 0.0;
		
		private var _chair:Chair;
		
		public function Passenger(X:int,Y:int,passengerScale:Number, chair:Chair):void
		{	
			_chair = chair;
			
			super(X,Y);
			
			var random:int = Helpers.randomInt(0, 7);
			switch( random )
			{
				case 0:
					loadGraphic(ImgPassenger1, true, true, 100, 150);
					break;
				case 1:
					loadGraphic(ImgPassenger2, true, true, 100, 150);
					break;
				case 2:
					loadGraphic(ImgPassenger3, true, true, 100, 150);
					break;
				case 3:			
					loadGraphic(ImgPassenger4, true, true, 100, 150);
					break;
				case 4:			
					loadGraphic(ImgPassenger5, true, true, 100, 150);
					break;
				case 5:			
					loadGraphic(ImgPassenger6, true, true, 100, 150);
					break;
				case 6:			
					loadGraphic(ImgPassenger7, true, true, 100, 150);
					break;
				case 7:			
					loadGraphic(ImgPassenger8, true, true, 100, 150);
					break;
			}

			width = 100;
			height = 150;
			offset.x = width/2;
			scale.x = passengerScale;
			scale.y = passengerScale;
			
			var blinkSpeed:int = Helpers.randomInt(2, 10);
			addAnimation("idle", [0,0,1,2,3], blinkSpeed);
			addAnimation("cell", [5,6], 8 );
			addAnimation("happy",[0]);
			addAnimation("sad",[7]);
			addAnimation("dead",[8]);
			
			bubble = new Bubble(x, y, this, chair);
			PlayState.groupHudSort.add(bubble);
			
			if( isWantingPassenger() )
			{
				want = Helpers.randomInt(0,10);
			}
			else
			{
				want = -1;
			}
			want = -1;
		}
		
		public function isWantingPassenger():Boolean
		{
			if( _chair.tileX != 0 && _chair.tileX != 7 )
			{
				return true;
			}
			return false;
		}
		
		public function makeHappy():void 
		{
			happy = true;
			happyTimer = happyTime;
			
			var randomSound:int = Helpers.randomInt(0,3);
			switch( randomSound )
			{
				case 0:
					FlxG.play( SndDrink1, 0.25 );
					break;
				case 1:
					FlxG.play( SndDrink2, 0.25 );
					break;
				case 2:
					FlxG.play( SndDrink3, 0.25 );
					break;
				case 3:
					FlxG.play( SndDrink4, 0.25);
					break;
			}
		}
		
		public function makeSad():void
		{
			sad = true;
			sadTimer = sadTime;		
			FlxG.play( SndCell, 0.5 );
		}
		
		override public function update():void
		{
			super.update();
			
			// Dead
			if( PlayState._currLevel.player && PlayState._currLevel.player.roundOver )
			{
				play( "dead" );
				want = -1;
				return;
			}
			
			// Happy
			if( happyTimer >= 0 )
			{
				play("happy");
				happy = true;
				happyTimer -= FlxG.elapsed;
				return;
			}
			else
			{
				happy = false;
			}
			
			// Sad
			if( sadTimer >= 0 )
			{
				play("sad");
				sad = true;
				sadTimer -= FlxG.elapsed;
				return;
			}
			else
			{
				sad = false;
			}
		
			if( want == 3 )
			{
				play("cell");
			}
			else 
			{
				play( "idle" );
			}
		}
	}
}
