package flxsys;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import openfl.Assets;
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
class FlxShell extends FlxSubState
{
	public var drive:Drive;
	public var curDir:Folder;
	
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
	private var _frame:FlxSprite;
	
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
		
		drive = new Drive();
		drive.loadJSON(Assets.getText("assets/data/FlxOS.txt"));
		curDir = drive.root;
		
		super();
		
		var l1:ScriptLexer = new ScriptLexer("bash -new lol -test | trace -now");
		var l2:ScriptLexer = new ScriptLexer("bash -new lol -test | trace -now > TESTFILE.txt");
		var l3:ScriptLexer = new ScriptLexer("TESTFILE.txt < bash -new lol -test | trace -now");
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
		
		_cap.fetchFocus();
		
		if (_t.frameHeight + _t.y >= _frame.height - 10)
		{
			var ind:Int = _realtext.indexOf(" ", 1);
			_realtext = _realtext.substr(ind, _realtext.length);
			_cursorPos -= ind;
			_eraseblock -= ind;
		}
		
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
		
		_realtext += pre + prompt.getPrompt(curDir.path);
		allowInput = true;
	}
	
	public function print(ToPrint:Dynamic, NewLine:Bool = false):Void
	{
		if (ToPrint != null)
		{
			var post:String = "";
			
			if (NewLine)
				post = Util.NEWLINE;
			
			_realtext += Std.string(ToPrint) + post;
		}
	}
	
	public function handleInput(event)
	{
		if (event.ctrlKey)
		{
			switch(event.keyCode)
			{
				case 37: //left arrow
					handleCtrlLeft();
				case 39: //right arrow
					handleCtrlRight();
			}
		}
		
		else
		{
			switch(event.keyCode)
			{
				case 13: //enter
					handleEnter();
				case 9: //tab
					handleTab();
				case 8: //backspace
					handleBackSpace();
				case 37: //left arrow
					handleLeftArrow();
				case 39: //right arrow
					handleRightArrow();
				case 38: //up arrow
					handleUpArrow();
				case 40: //down arrow
					handleDownArrow();
				case 33: //page up
					handlePageUp();
				case 34: //page down
					handlePageDown();
				case 35: //end
					handleEnd();
				case 36: //home
					handleHome();
			}
		}
	}
	
	//Key handler functions
	private function handleEnter():Void
	{
		if (_inputTime)
		{
			var cmd:String = _realtext.substring(_eraseblock, _realtext.length);
			_realtext += Util.NEWLINE;
			_parser.parseStringInput(cmd);
		}
	}
	
	private function handleTab():Void
	{
		if (_inputTime)
		{
			try
			{
				var until_cursor:String = _realtext.substring(0, _cursorPos);
				var word_start:Int = until_cursor.lastIndexOf(" ");
				if (word_start < _eraseblock)
					word_start = _eraseblock;
				var word_end:Int = _realtext.indexOf(" ", _cursorPos);
				if (word_end < 0)
					word_end = _realtext.length;
				
				var res:String = _parser.tabComplete(
						this,
						StringTools.trim(_realtext.substring(word_start, word_end))
					);
				
				if (res != null)
				{
					var prepre:String = " ";
					
					var pre:String = _realtext.substr(0, word_start);
					if (_realtext.substring(_eraseblock, word_start).length < 1)
						prepre = "";
					
					_realtext = pre + prepre +
						res + _realtext.substring(word_end, _realtext.length);
					
					_cursorPos = word_start + res.length + 1;
				}
			}
			
			catch (e: Dynamic)
			{
				
			}
		}
	}
	
	private function handleBackSpace():Void
	{
		if (_inputTime)
		{
			if (_cursorPos > _eraseblock)
			{
				_realtext = _realtext.substring(0, _cursorPos - 1) +
					_realtext.substring(_cursorPos, _realtext.length);
				_cursorPos -= 1;
			}
		}
	}
	
	private function handleLeftArrow():Void
	{
		if (_inputTime)
		{
			if (_cursorPos > _eraseblock) _cursorPos--;
		}
	}
	
	private function handleRightArrow():Void
	{
		if (_inputTime)
		{
			if (_cursorPos < _realtext.length) _cursorPos++;
		}
	}
	
	private function handleUpArrow():Void
	{
		if (_inputTime)
		{
			_realtext = _realtext.substring(0, _eraseblock);
			_realtext += _parser.getHistNext();
			_cursorPos = _realtext.length;
		}
	}
	
	private function handleDownArrow():Void
	{
		if (_inputTime)
		{
			_realtext = _realtext.substring(0, _eraseblock);
			_realtext += _parser.getHistPrevious();
			_cursorPos = _realtext.length;
		}
	}
	
	private function handlePageUp():Void
	{
		if (_inputTime)
		{
			_realtext = _realtext.substring(0, _eraseblock);
			_realtext += _parser.getHistFirst();
			_cursorPos = _realtext.length;
		}
	}
	
	private function handlePageDown():Void
	{
		if (_inputTime)
		{
			_realtext = _realtext.substring(0, _eraseblock);
			_realtext += _parser.getHistLast();
			_cursorPos = _realtext.length;
		}
	}
	
	private function handleEnd():Void
	{
		if (_inputTime)
		{
			_cursorPos = _realtext.length;
		}
	}
	
	private function handleHome():Void
	{
		if (_inputTime)
		{
			_cursorPos = _eraseblock;
		}
	}
	
	private function handleCtrlLeft():Void
	{
		if (_inputTime)
		{
			var until_cursor:String = _realtext.substring(0, _cursorPos);
			var word_start:Int = until_cursor.lastIndexOf(" ");
			if (word_start < _eraseblock)
				word_start = _eraseblock;
			_cursorPos = word_start;
		}
	}
	
	private function handleCtrlRight():Void
	{
		if (_inputTime)
		{
			var word_end:Int = _realtext.indexOf(" ", _cursorPos + 1);
			if (word_end < 0)
				word_end = _realtext.length;
			_cursorPos = word_end;
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
		
		_frame = square;
	}
}