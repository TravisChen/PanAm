package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../data/Attendant-back.png")] private var ImgPlayer:Class;
		
		public var itemArray:Array;
		public var bubblePlayer:BubblePlayer;
		public var wantSpawner:WantSpawner;
		
		public var startTime:Number;
		public var roundOver:Boolean;
		
		public var tileX:Number;
		public var tileY:Number;
		
		public var pickup1:PickUp;
		public var pickup2:PickUp;
		public var pickup3:PickUp;
		public var givingItem:Boolean = false;
		
		private var moveTo:CabinItem;
		private var moving:Boolean = false;
		public var startedMoving:Boolean = false;
		private var startedKick:Boolean = false;
		private var speed:Number = 8.0;
		
		private var _cabin:Array;
		private var _wantSpawner:WantSpawner;
		private var _cart:Cart
		private var fulfilled:Boolean = false;
		
		public function Player( cabin:Array, wantSpawner:WantSpawner )
		{
			// Set cabin, orig position
			_cabin = cabin;
			_wantSpawner = wantSpawner;
			tileX = 2;
			tileY = 11;
			var cabinItem:CabinItem = _cabin[tileY][tileX];
			super(cabinItem.x,cabinItem.y);
			
			// Graphic
			loadGraphic(ImgPlayer,true,true,150,225);

			// Build item array
			itemArray = new Array( -1, -1, -1 );
			
			// Bounding box tweaks
			width = 150;
			height = 225;
			offset.x = width/2;
			offset.y = width/3;
			
			scale.x = cabinItem.scale.x;
			scale.y = cabinItem.scale.y;
			
//			bubblePlayer = new BubblePlayer(x, y, this);
//			PlayState.groupHudSort.add(bubblePlayer);
			
			// Init
			roundOver = false;
			
			// Start time
			startTime = 0.5;
			
			// Pickup
			pickup1 = new PickUp( 85, 115, -1, this, 0.65 );
			PlayState.groupHudSort.add(pickup1);
			
			pickup2 = new PickUp( 155, 115, -1, this, 0.65 );
			PlayState.groupHudSort.add(pickup2);

			pickup3 = new PickUp( 225, 115, -1, this, 0.65 );
			PlayState.groupHudSort.add(pickup3);
			
			addAnimation("idle", [0]);
			addAnimation("run", [0,1,2,3,4], 6);
			addAnimation("deliver", [5], 6);
		}
		
		public function getFirstAisle():CabinItem
		{
			var cabinItem:CabinItem = _cabin[0][0];
			for( var y:int = 0; y < _cabin.length; y++)
			{
				for( var x:int = 0; x < _cabin[y].length; x++ )
				{	
					cabinItem = _cabin[y][x];
					if( cabinItem.type == 0 )
					{
						return cabinItem;
					}
				}
			}
			return cabinItem;
		}
		
		public function updateRowHighlight():void
		{
			var cabinItem:CabinItem = _cabin[0][0];
			for( var y:int = 0; y < _cabin.length; y++)
			{
				for( var x:int = 0; x < _cabin[y].length; x++ )
				{	
					cabinItem = _cabin[y][x];
					if( cabinItem.type == 1 )
					{
						if( cabinItem.tileY == tileY )
						{
							cabinItem.color = 0xffffffff;
						}
						else
						{
							cabinItem.color = 0xffb4b4b4;
						}
					}
				}
			}
		}

		public function updateMovement():void
		{			
			var moveToX:Number = moveTo.x;
			var moveToY:Number = moveTo.y;
			
			if( x > moveToX )
				x -= 1 * speed;
			else if ( x < moveToX )
				x += 1 * speed;
			
			if( y > moveToY )
				y -= 1 * speed;
			else if ( y < moveToY )
				y += 1 * speed;
			
			// Update scale
			scale.x = moveTo.scale.x;
			scale.y = moveTo.scale.y;
			
			if( x > moveToX - speed*2 && x < moveToX + speed*2 )
			{
				if( y > moveToY - speed*2 && y < moveToY + speed*2 ) 
				{
					moving = false;
					x = moveToX;
					y = moveToY;
				}
			}
		}
		
		public function validTile( x:int, y:int ):Boolean
		{		
			if( y >= 0 && y < _cabin.length )
			{
				if( x >= 0 && x < _cabin[y].length )
				{
					var cabinItem:CabinItem = _cabin[y][x];
					if( cabinItem.type >= 0 )
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function moveToTile( x:int, y:int ):Boolean
		{
			if( validTile( x, y ) )
			{
				var cabinItem:CabinItem = _cabin[y][x];
				
				if( cabinItem.type == 0 )
				{
					tileX = x;
					tileY = y;
					moveTo = cabinItem;
					moving = true;
					
					return true;
				}
			}
			return false;
		}
		
		public function giveItemUpdate():Boolean
		{		
			if( tileY == _cabin.length - 1 )
			{
				if( ( FlxG.keys.DOWN || FlxG.keys.S ) )
				{
					if( !givingItem )
					{
						givingItem = true;
						if( tileX == 0 || tileX == 1 )
						{
							addItemToInventory(0);
						}
						
						if( tileX == 3 || tileX == 4 )
						{
							addItemToInventory(1);
						}
						
						if( tileX == 6 || tileX == 7 )
						{
							addItemToInventory(2);
						}
					}
				}
				else
				{
					givingItem = false;
				}
			}
			return false;
		}
		
		public function addItemToInventory( item:int ):void
		{
			itemArray[2] = itemArray[1];
			itemArray[1] = itemArray[0];
			itemArray[0] = item;			
		}
		
		public function isItemFulfilled( x:int, y:int ):Boolean 
		{
			if( !fulfilled )
			{
				if( validTile( x, y ) )
				{
					var chair:Chair = _cabin[y][x];
					for( var i:int = 0; i < 3; i++ )
					{
						if( chair.passenger.want == itemArray[i] )
						{
							chair.passenger.want = -1;
							chair.passenger.makeHappy();
							_wantSpawner.numWant--;
							itemArray[i] = -1;
							fulfilled = true;
							compactInventory();
							break;
						}
					}
					
					if ( chair.passenger.want == 3 )
					{
						chair.passenger.want = -1;
						_wantSpawner.numWant--;		
						fulfilled = true;
					}
				}
			}
			return false;
		}
		
		public function compactInventory():void
		{
			var itemArrayCopy:Array = itemArray;
			for( var i:int = 0; i < 3; i++ )
			{
				if( itemArray[i] < 0 )
				{
					if( i < 2 )
					{
						var origLeft:int = itemArray[i];
						var origRight:int = itemArray[i+1];
						itemArray[i] = origRight;
						itemArray[i + 1] = origLeft;
					}
				}
			}
		}
		
		public function updateInventory():void
		{
			pickup1.type = itemArray[0];	
			pickup2.type = itemArray[1];	
			pickup3.type = itemArray[2];	
		}
		
		override public function update():void
		{			
			super.update();

			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return;
			}
			
			if( roundOver )
			{
				play("idle");
				return;
			}

			giveItemUpdate();
			updateRowHighlight();
			updateInventory();

			if( moving )
			{
				updateMovement();
				return;
			}
			
			if(FlxG.keys.UP || FlxG.keys.W )
			{
				fulfilled = false;
				if( moveToTile( tileX, tileY - 1 ) )
				{
					play("run");
				}
			}
			else if(FlxG.keys.DOWN || FlxG.keys.S )
			{
				fulfilled = false;
				if( moveToTile( tileX, tileY + 1 ) )
				{
					play("run");
				}
			}
			else if(FlxG.keys.LEFT || FlxG.keys.A )
			{
				if( moveToTile( tileX - 1, tileY) )
				{
					play("run");
				}
				else
				{
					if( !fulfilled )
					{
						facing = RIGHT;
						play("deliver");
						isItemFulfilled( tileX - 1, tileY );
					}
				}
			}
			else if(FlxG.keys.RIGHT || FlxG.keys.D )
			{
				if( moveToTile( tileX + 1, tileY) )
				{
					play("run");
				}
				else
				{
					if( !fulfilled )
					{
						facing = LEFT;
						play("deliver");					
						isItemFulfilled( tileX + 1, tileY );
					}
				}
			}
			else
			{
				fulfilled = false;
				play("idle");
			}
		}
	}
}