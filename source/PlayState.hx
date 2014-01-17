package;

import flixel.addons.text.FlxTypeText;
import Console;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.text.FlxTypeText;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.events.KeyboardEvent;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _typeText:Console;
	private var _status:FlxTypeText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
			// Set a background color
			FlxG.cameras.bgColor = 0xff131c1b;
			
			//#if !FLX_NO_MOUSE
			FlxG.mouse.hide();
			//#end
			
			var square:FlxSprite = new FlxSprite( 10, 10 );
			square.makeGraphic( FlxG.width - 20, FlxG.height - 76, 0xff333333 );
			
			_typeText = new Console( 15, 10, FlxG.width - 30, "Welcome!\n", 16, true );
			
			_typeText.showCursor = true;
			_typeText.cursorBlinkSpeed = 1.0;
			_typeText.prefix = "User@LinuxBox ~\n$ ";
			_typeText.color = 0x8811EE11;
			//_typeText._finalText = "Hi";
			_typeText.giveControl();
			_typeText.print("LOL");
			_typeText.print("LOL");
			_typeText.print("LOL");
			_typeText.giveControl();
			
			var effect:FlxSprite = new FlxSprite( 10, 10 );
			var bitmapdata:BitmapData = new BitmapData( FlxG.width - 20, FlxG.height - 76, true, 0x88114411 );
			var scanline:BitmapData = new BitmapData( FlxG.width - 20, 1, true, 0x88001100 );
			
			for ( i in 0...bitmapdata.height )
			{
					if ( i % 2 == 0 )
					{
							bitmapdata.draw( scanline, new Matrix( 1, 0, 0, 1, 0, i ) );
					}
			}
			
			// round corners
			
			var cX:Array<Int> = [ 5, 3, 2, 2, 1 ];
			var cY:Array<Int> = [ 1, 2, 2, 3, 5 ];
			var w:Int = bitmapdata.width;
			var h:Int = bitmapdata.height;
			
			for ( i in 0...5 )
			{
					bitmapdata.fillRect( new Rectangle( 0, 0, cX[i], cY[i] ), 0xff131c1b );
					bitmapdata.fillRect( new Rectangle( w-cX[i], 0, cX[i], cY[i] ), 0xff131c1b );
					bitmapdata.fillRect( new Rectangle( 0, h-cY[i], cX[i], cY[i] ), 0xff131c1b );
					bitmapdata.fillRect( new Rectangle( w-cX[i], h-cY[i], cX[i], cY[i] ), 0xff131c1b );
			}
			
			effect.loadGraphic( bitmapdata );
			add(effect);
			add(_typeText);
			super.create();
	}
}