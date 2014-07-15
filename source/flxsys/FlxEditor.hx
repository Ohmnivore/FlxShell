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
class FlxEditor extends FlxGroup
{
	static public inline var charWidth:Float = 7.2727;
	
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
		//Hide cursor
		#if (!FLX_NO_MOUSE || !mobile)
		FlxG.mouse.visible = true;
		#end
		//Register font
		Font.registerFont(ShellFont);
		
		makeScreen();
		setUpText();
		
		_inp.text = _file.content;
	}
	
	override public function update():Void 
	{
		super.update();
		
		FlxG.stage.focus = _inp;
	}
	
	private function handleInput(event)
	{
		if (event.ctrlKey)
		{
			switch(event.keyCode)
			{
				case 68: //D
					handleCtrlD();
				case 83: //S
					handleCtrlS();
				//case 27: //ESC
					//handleEscape();
			}
		}
	}
	
	private function handleCtrlD():Void
	{
		_shell.allowInput = true;
		_inp.visible = false;
		
		#if (!FLX_NO_MOUSE || !mobile)
		FlxG.mouse.visible = false;
		#end
		
		//close();
	}
	
	private function handleCtrlS():Void
	{
		_file.content = _inp.text;
	}
	
	//private function handleEscape():Void
	//{
		//toggle();
	//}
	//
	//private var _open:Bool = true;
	//
	//public function toggle():Void
	//{
		//if (_open)
		//{
			//close();
		//}
		//else
		//{
			//open();
		//}
	//}
	//
	//public function open():Void
	//{
		//if (!_open)
		//{
			//active = true;
			//visible = true;
			//_inputTime = true;
			//_cap.active = true;
			//_cap.resetText();
			//
			//_open = true;
		//}
	//}
	//
	//public function close():Void
	//{
		//if (_open)
		//{
			//active = false;
			//visible = false;
			//_inputTime = false;
			//_cap.active = false;
			//
			//_open = false;
		//}
	//}
	
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
		_inp.mouseWheelEnabled = true;
		_inp.type = TextFieldType.INPUT;
		
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