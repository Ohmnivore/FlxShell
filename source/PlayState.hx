package;

import flash.display.Bitmap;
import flash.utils.ByteArray;
import flixel.addons.text.FlxTypeText;
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
import haxe.Resource;
import hscript.*;
import haxe.Json;
import flash.external.ExternalInterface;
import flxsys.*;
import hparse.*;
import byte.*;
import flxsys.Disk;
import flxsys.BashParser;

@:file("assets/FlxOSjson.txt")
class OS extends ByteArray
{
    
}

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
			//untyped{var dis:Dynamic = __as__('new DisplayToggle("some_id")');
			//dis.hide();}
			
			//var parser = new PrintfParser(byte.ByteData.ofString("Valu$$e: $-050.2f kg"));
			//trace(parser.parse());
			
			var filesys:Disk = new Disk(Json.parse(new OS().toString()));
			
			// Set a background color
			FlxG.cameras.bgColor = 0xff000000;
			
			//#if !FLX_NO_MOUSE
			FlxG.mouse.hide();
			//#end
			
			var square:FlxSprite = new FlxSprite( 10, 10 );
			square.makeGraphic( FlxG.width - 20, FlxG.height - 76, 0xff333333 );
			
			_typeText = new Console( filesys, 15, -16, FlxG.width - 30, "Welcome!", 16, true );
			
			_typeText.maxHeight = FlxG.height - 76;
			_typeText.showCursor = true;
			_typeText.cursorBlinkSpeed = 1.0;
			_typeText.prefix = "User@LinuxBox ~\n$ ";
			_typeText.eraseblock = _typeText.prefix.length;
			_typeText.color = 0x8811EE11;
			//_typeText._finalText = "Hi";
			//_typeText.giveControl();
			//_typeText.takeControl();
			var script:String = '
Cons.print("Scripting");
';
			var parser = new hscript.Parser();
			var program = parser.parseString(script);
			var interp = new hscript.Interp();
			interp.variables.set("Cons", _typeText); // share the Math class
			//interp.variables.set("angles",[0,1,2,3]); // set the angles list
			//interp.execute(program);
			//trace(_typeText.disk.getFromPath("bin"));
			//var k:Dynamic = _typeText.disk.getFromPath("bin");
			//trace(_typeText.disk.isFile(k));
			//_typeText.print("FlxBash");
			//_typeText.print("is");
			//_typeText.print("kewl");
			//_typeText.giveControl();
			
			var effect:FlxSprite = new FlxSprite( 10, 10 );
			var bitmapdata:BitmapData = new BitmapData( FlxG.width - 20, FlxG.height - 20, true, 0x88114411 );
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
			
			//trace(Disk.findFromRoot("/bin/ls", filesys));
			//trace(Disk.findFromRelative("ls", "/bin", filesys));
			//BashParser.getTabParent("bin/l", filesys);
			
	}
}