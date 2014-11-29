package flxsys;

import flash.text.TextField;
import flash.text.TextFormat;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import openfl.Assets;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import flash.display.BitmapData;
import flash.text.Font;
import openfl.text.TextFieldType;
import flash.events.KeyboardEvent;

//Monaco font
@:font("assets/images/Monaco.ttf") private class ShellFont extends Font { }

/**
 * ...
 * @author Ohmnivore
 */
class FlxViewer extends FlxGroup
{
	static public var charWidth:Float = 7.2727;
	
	private var _frame:FlxSprite;
	private var _inp:TextField;
	private var _file:File;
	private var _shell:FlxShell;
	
	public function new(F:File, Shell:FlxShell) 
	{
		super();
		
		_file = F;
		_shell = Shell;
		
		_shell.allowInput = false;
		
		// Set a background color
		FlxG.cameras.bgColor = 0x00000000;
		//Register font
		Font.registerFont(ShellFont);
		
		makeScreen();
		setUpText();
		
		_inp.text = Util.CLRFtoLF(_file.content);
		FlxG.stage.focus = _inp;
	}
	
	override public function update():Void 
	{
		super.update();
		
		_shell._inputTime = false;
		
		if (FlxG.keys.justPressed.Z)
			nextScreen();
		if (FlxG.keys.justPressed.B)
			lastScreen();
	}
	
	private function handleInput(event)
	{
		switch(event.keyCode)
		{
			case 81: //Q
				handleQ();
			case 66: //B
				//handleCtrlS();
			case 90: //Z
				//nextScreen();
		}
	}
	
	private function handleQ():Void
	{
		_shell.allowInput = true;
		_inp.visible = false;
		
		_shell.viewer = null;
		_shell.open();
		
		destroy();
	}
	
	private function nextScreen():Void
	{
		_inp.scrollV += 30;
	}
	
	private function lastScreen():Void
	{
		_inp.scrollV += 30;
	}
	
	public var _open:Bool = true;
	
	public function toggle():Void
	{
		if (_open)
		{
			close();
		}
		else
		{
			open();
		}
	}
	
	public function open():Void
	{
		active = true;
		visible = true;
		_inp.visible = true;
		_inp.type = TextFieldType.DYNAMIC;
		_inp.selectable = true;
		FlxG.stage.focus = _inp;
		
		_open = true;
	}
	
	public function close():Void
	{
		active = false;
		visible = false;
		_inp.visible = false;
		_inp.type = TextFieldType.DYNAMIC;
		_inp.selectable = false;
		
		_open = false;
	}
	
	private function setUpText():Void
	{
		_inp = new TextField();
		
		_inp.x = 10 * (FlxG.game.width / FlxG.width) * (FlxG.game.width / FlxG.width) + FlxG.game.x;
		_inp.y = 10 * (FlxG.game.width / FlxG.height) * (FlxG.game.height / FlxG.height) + FlxG.game.y;
		_inp.width = (FlxG.width - 20) * FlxG.game.width / FlxG.width;
		_inp.height = (FlxG.height - 40) * FlxG.game.height / FlxG.height;
		
		_inp.multiline = true;
		_inp.wordWrap = true;
		_inp.selectable = true;
		_inp.mouseEnabled = true;
		#if flash
		_inp.mouseWheelEnabled = true;
		#end
		_inp.type = TextFieldType.DYNAMIC;
		
		_inp.embedFonts = true;
		_inp.defaultTextFormat = new TextFormat(Assets.getFont("assets/images/Monaco.ttf").fontName,
			12, 0x8811EE11);
		
		FlxG.stage.addChild(_inp);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
	}
	
	private function makeScreen():Void
	{
		var square:FlxSprite = new FlxSprite(10, 10);
		square.makeGraphic(FlxG.width - 20, FlxG.height - 20, 0xff333333);
		square.scrollFactor.set();
		
		var effect:FlxSprite = new FlxSprite(10, 10);
		effect.scrollFactor.set();
		var bitmapdata:BitmapData = new BitmapData(FlxG.width - 20, FlxG.height - 20, true, 0x88114411);
		var scanline:BitmapData = new BitmapData(FlxG.width - 20, 1, true, 0x88001100);
		
		for (i in 0...bitmapdata.height)
		{
			if (i % 2 == 0)
			{
				bitmapdata.draw(scanline, new Matrix(1, 0, 0, 1, 0, i));
			}
		}
		
		// round corners
		
		var cX:Array<Int> = [5, 3, 2, 2, 1];
		var cY:Array<Int> = [1, 2, 2, 3, 5];
		var w:Int = bitmapdata.width;
		var h:Int = bitmapdata.height;
		
		for (i in 0...5)
		{
			bitmapdata.fillRect(new Rectangle(0, 0, cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(w-cX[i], 0, cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(0, h-cY[i], cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(w-cX[i], h-cY[i], cX[i], cY[i]), 0xff131c1b);
		}
		
		effect.loadGraphic(bitmapdata);
		
		add(square);
		add(effect);
		
		_frame = square;
	}
}