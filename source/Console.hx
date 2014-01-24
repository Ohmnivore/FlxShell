package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.util.FlxRandom;
import flash.text.Font;
import flixel.FlxG;
import flash.events.KeyboardEvent;

/**
 * This is loosely based on the TypeText class by Noel Berry, who wrote it for his Ludum Dare 22 game - Abandoned
 * http://www.ludumdare.com/compo/ludum-dare-22/?action=preview&uid=1527
 * @author Noel Berry
 */

@:font("assets/images/Monaco.ttf") private class DaFont extends Font { } 

class Console extends FlxText
{
	public var version:Int = 0;
	public var subversion:Int = 1;
	
	public var cursorPos:Int = 0;
	
	public var histindex:Int = 0;
	
	public var history:Array<String>;
	
	public var pathFix:String = "~";
	
	public var userFix:String = "User@Flinux";
	
	public var prompt:String = "$ ";
	
	/**
	 * Text to add at the beginning, without animating.
	 */
	public var prefix:String = "";
	
	public var disk:Disk;
	
	public var maxHeight:Int;
	
	public var eraseblock:Int = 0;
	
	public var noinput:Bool = false;
	
	public var input:CaptureInput;
	
	/**
	 * Set to true to show a blinking cursor at the end of the text.
	 */
	public var showCursor:Bool = false;
	
	/**
	 * The character to blink at the end of the text.
	 */
	public var cursorCharacter:String = "|";
	
	/**
	 * The speed at which the cursor should blink, if shown at all.
	 */
	public var cursorBlinkSpeed:Float = 0.5;
	
	/**
	 * Whether or not to animate the text. Set to false by start() and erase().
	 */
	public var paused:Bool = false;
	
	/**
	 * The text that will ultimately be displayed.
	 */
	public var _finalText:String = "";
	
	/**
	 * This is incremented every frame by FlxG.elapsed, and when greater than delay, adds the next letter.
	 */
	private var _timer:Float = 0.0;
	
	/**
	 * A timer that is used while waiting between typing and erasing.
	 */
	private var _waitTimer:Float = 0.0;
	
	/**
	 * Internal tracker for current string length, not counting the prefix.
	 */
	private var _length:Int = 0;
	
	/**
	 * Internal tracker for cursor blink time.
	 */
	private var _cursorTimer:Float = 0.0;
	
	/**
	 * Helper string to reduce garbage generation.
	 */
	static private var helperString:String = "";
	
	static private var initFonts:Bool = false;
	
	/**
	 * Create a Console object, which is very similar to FlxText except that the text is initially hidden and can be
	 * animated one character at a time by calling start().
	 * 
	 * @param	X				The X position for this object.
	 * @param	Y				The Y position for this object.
	 * @param	Width			The width of this object. Text wraps automatically.
	 * @param	Text			The text that will ultimately be displayed.
	 * @param	Size			The size of the text.
	 * @param	EmbeddedFont	Whether this text field uses embedded fonts or not.
	 */
	public function new( Ddisk:Disk, X:Float, Y:Float, Width:Int, Text:String, Size:Int = 8, EmbeddedFont:Bool = true )
	{
		super(X, Y, Width, "", Size, EmbeddedFont);
		disk = Ddisk;
		initFont();
		Font.registerFont(DaFont);
		font = "assets/images/Monaco.ttf";
		size = 12;
		_finalText = 'Shell version: $version.$subversion';
		maxHeight = FlxG.height;
		
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		input = new CaptureInput();
		input.CaptureUserInput();
		
		//print("Shell 0.1");
		giveControl();
		history = [""];
	}
	
	public function createPrefix(User:String, Path:String, Prompt:String):Void
	{
		prefix = User + ' ' + Path + '\n' + Prompt;
	}
	
	public function refreshPrefix():Void
	{
		prefix = userFix + ' ' + pathFix + '\n' + prompt;
	}
	
	public function initFont():Void
	{
		if (!initFonts) Font.registerFont(DaFont);
	}
	
	public function print( Str:String, Newline:Bool = true):Void
	{
		if (Newline) _finalText += "\n" + Str; //prefix + Str;
		else _finalText += Str; // prefix + Str;
		//trace(this._textField.textHeight, this._textField.height, this._textField.text);
		//trace(frameHeight);
	}
	
	public function takeControl():Void
	{
		//prefix = "";
		noinput = true;
	}
	
	public function giveControl():Void
	{
		//prefix = "User@LinuxBox ~\n$ ";
		refreshPrefix();
		_finalText += '\n\n' + prefix;
		eraseblock = _finalText.length;
		noinput = false;
		cursorPos = _finalText.length;
	}
	
	override public function update():Void
	{
		if (FlxG.stage.focus != input)
		{
			FlxG.stage.focus = input;
		}
		
		// If the timer value is higher than the rate at which we should be changing letters, increase or decrease desired string length.
		
		// Update the helper string with what could potentially be the new text.
		if (!noinput) 
		{
			//var result:String = _finalText + input.text;
			var result:String = _finalText.substring(0, cursorPos) + input.text + _finalText.substring(cursorPos);
			if (result.length > _finalText.length) cursorPos++;
			_finalText = result;
		}
		input.text = "";
		//trace(input.myFirstTextBox.text);
		helperString = _finalText;
		
		// Append the cursor if needed.
		
		if ( showCursor )
		{
			_cursorTimer += FlxG.elapsed;
			
			if ( _cursorTimer > cursorBlinkSpeed / 2 )
			{
				//helperString += cursorCharacter.charAt( 0 );
				helperString = helperString.substring(0, cursorPos) + cursorCharacter.charAt( 0 ) + helperString.substring(cursorPos);
			}
			
			else
			{
				helperString = helperString.substring(0, cursorPos) + " " + helperString.substring(cursorPos);
			}
			
			if ( _cursorTimer > cursorBlinkSpeed )
			{
				_cursorTimer = 0;
			}
		}
		
		// If the text changed, update it.
		
		if ( helperString != text )
		{
			text = helperString;
			//cursorPos++;
			//trace(frameHeight);
		}
		
		//switch(FlxG.keyboard.) 
		//{
			//case 
		//}
		//trace(height);
		while ((frameHeight) > maxHeight - 30)
		{
			_finalText = _finalText.substring(1, text.length);
			eraseblock -= 1;
			calcFrame();
			update();
			super.update();
		}
		
		super.update();
	}
	
	public function handleInput(event)
	{
		//trace(event.keyCode);
		switch(event.keyCode)
		{
			case 13: //enter
				if (!noinput)
				{
					var cmd:String = _finalText.substring(eraseblock, _finalText.length);
					takeControl();
					history.push(cmd);
					histindex = history.length - 1;
					BashParser.parse(cmd, this);
				}
			case 9: //tab
				
			case 8: //backspace
				if (!noinput)
				{
					if (text.length - 1 > eraseblock)
						if ( _cursorTimer > cursorBlinkSpeed / 2 )
							_finalText = _finalText.substring(0, text.length - 2);
						else
							_finalText = _finalText.substring(0, text.length - 1);
				}
			case 37: //left arrow
				if (!noinput)
				{
					if (cursorPos > eraseblock) cursorPos--;
					//trace(cursorPos);
					//textField.
				}
			case 39: //right arrow
				if (!noinput)
				{
					if (cursorPos < _finalText.length) cursorPos++;
					//trace(cursorPos);
					//textField.
				}
			case 38: //up arrow
				if (!noinput)
				{
					_finalText = _finalText.substring(0, eraseblock);
					_finalText += history[histindex];
					if (histindex > 1) histindex--; //0 is a dummy value of ""
				}
			case 40: //down arrow
				if (!noinput)
				{
					if (histindex < history.length - 1 && history.length > 1) //eliminate history[0] 
					{
						histindex++; //0 is a dummy value of ""
						_finalText = _finalText.substring(0, eraseblock);
						_finalText += history[histindex];
					}
				}
			default:
				//cursorPos++;
		}
	}
}