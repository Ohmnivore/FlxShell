package flxsys;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import flash.display.BitmapData;
import flash.text.Font;
import openfl.events.KeyboardEvent;

//Monaco font
@:font("assets/images/Monaco.ttf") private class ShellFont extends Font { }

/**
 * This is based on the FlxTypeText demo from flixel-demos
 * https://github.com/HaxeFlixel/flixel-demos/blob/master/User%20Interface/FlxTypeText/source/MenuState.hx
 * @author Ohmnivore
 */
class FlxShell extends FlxState
{
	//Prompt vars
	public var userName:String;
	public var sysName:String;
	public var prompt:FlxPrompt;
	
	private var _parser:FlxParser;
	
	//Text display vars
	public var _inputTime:Bool = false;
	private var _t:FlxText;
	private var _realtext:String = "";
	private var _cursorPos:Int = 0;
	private var _eraseblock:Int = 0;
	private var _cap:FlxCaptureInput;
	
	//Cursor vars
	private var _cursorCharacter:String = "|";
	private var _cursorBlinkSpeed:Float = 1.0;
	private var _cursorTimer:Float = 0.0;
	
	public var allowInput(get, set):Bool;
	
	public function get_allowInput():Bool
	{
		return _inputTime;
	}
	
	public function set_allowInput(V:Bool):Bool
	{
		_inputTime = V;
		if (_inputTime)
		{
			_eraseblock = _realtext.length;
			_cursorPos = _eraseblock;
		}
		
		return _inputTime;
	}
	
	public function new(UserName:String, SysName:String = "SYS")
	{
		userName = UserName;
		sysName = SysName;
		
		super();
	}
	
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0x00000000;
		//Hide cursor
		#if (!FLX_NO_MOUSE || !mobile)
		FlxG.mouse.visible = false;
		#end
		//Register font
		Font.registerFont(ShellFont);

		super.create();
		makeScreen();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		_cap = new FlxCaptureInput();
		_parser = new FlxParser(this);
		
		prompt = new FlxPrompt(userName);
		printPrompt(false);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (_inputTime)
		{
			var inp:String = _cap.getNewInput();
			_cursorPos += inp.length;
			_realtext = _realtext.substr(0, _cursorPos - 1) + inp + _realtext.substring(_cursorPos - 1, _realtext.length);
		}
		
		if (_inputTime)
		{
			_cursorTimer += FlxG.elapsed;

			if ( _cursorTimer > _cursorBlinkSpeed / 2 )
			{
				_t.text = _realtext.substr(0, _cursorPos) + _cursorCharacter + _realtext.substring(_cursorPos, _realtext.length);
			}

			else
			{
				_t.text = _realtext.substr(0, _cursorPos) + " " + _realtext.substring(_cursorPos, _realtext.length);
			}

			if ( _cursorTimer > _cursorBlinkSpeed )
			{
				_cursorTimer = 0;
			}
		}
		else
		{
			_t.text = _realtext;
		}
	}
	
	public function printPrompt(NewLine:Bool = true):Void
	{
		var pre:String = "";
		
		if (NewLine)
			pre = Util.NEWLINE;
		
		_realtext += pre + prompt.getPrompt("/");
		allowInput = true;
	}
	
	public function print(ToPrint:String, NewLine:Bool = false):Void
	{
		var post:String = "";
		
		if (NewLine)
			post = Util.NEWLINE;
		
		_realtext += ToPrint + post;
	}
	
	public function handleInput(event)
	{
		switch(event.keyCode)
		{
			case 13: //enter
				if (_inputTime)
				{
					var cmd:String = _realtext.substring(_eraseblock, _realtext.length);
					_realtext += Util.NEWLINE;
					_parser.parseStringInput(cmd);
				}
			case 9: //tab
				if (_inputTime)
				{
					try
					{
						//BashParser.tabComplete(this);
					}

					catch (e: Dynamic)
					{

					}
				}
			case 8: //backspace
				if (_inputTime)
				{
					if (_cursorPos > _eraseblock)
					{
						_realtext = _realtext.substring(0, _cursorPos - 1) + _realtext.substring(_cursorPos, _realtext.length);
						_cursorPos -= 1;
					}
				}
			case 37: //left arrow
				if (_inputTime)
				{
					if (_cursorPos > _eraseblock) _cursorPos--;
				}
			case 39: //right arrow
				if (_inputTime)
				{
					if (_cursorPos < _realtext.length) _cursorPos++;
				}
			case 38: //up arrow
				if (_inputTime)
				{
					_realtext = _realtext.substring(0, _eraseblock);
					_realtext += _parser.getHistNext();
					_cursorPos = _realtext.length;
				}
			case 40: //down arrow
				if (_inputTime)
				{
					_realtext = _realtext.substring(0, _eraseblock);
					_realtext += _parser.getHistPrevious();
					_cursorPos = _realtext.length;
				}
			default:
				//cursorPos++;
		}
	}
	
	private function makeScreen():Void
	{
		var square:FlxSprite = new FlxSprite(10, 10);
		square.makeGraphic(FlxG.width - 20, FlxG.height - 20, 0xff333333);

		var effect:FlxSprite = new FlxSprite(10, 10);
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
		
		_t = new FlxText(square.x + 5, square.y + 5, square.width - 10, "", 12, false);
		_t.font = "assets/images/Monaco.ttf";
		_t.color = 0x8811EE11;
		add(_t);
	}
}