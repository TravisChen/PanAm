package
{
    import org.flixel.FlxSprite;
    
    public class Explosion extends FlxSprite
    {
        [Embed(source='../data/explosion.png')] private var ImgExplosion:Class;
		
		public var animPlayed:Boolean = false;
			
        public function Explosion(X:Number,Y:Number):void
        {
            super(X,Y);
         	
         	scale.x = 2.0;
         	scale.y = 2.0;
			width = 128;
			height = 192;
			offset.x = width/2;
			offset.y = height/2 + 100;
			
			loadGraphic(ImgExplosion, true, true, width, height);
			
			addAnimation("explosion", [0,1,2,3,4,5,6,7,8,9,10,11,12], 20);
        }
    
        override public function update():void
		{
			super.update();

			if( finished )
			{
				kill();
			}
			else
			{
				play( "explosion" );
			}
        }
    }
}
