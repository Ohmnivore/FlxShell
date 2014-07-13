package flxsys;

import flixel.FlxG;
import openfl.events.TextEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.events.Event;

#if flash
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;
#end

import flash.events.TextEvent;
//import flash.events.KeyboardEvent;

class FlxCaptureInput
{
	private var _t:TextField;
	
	public function new():Void
	{
		_t = new TextField();
		_t.type = TextFieldType.INPUT;
		_t.multiline = true;
		_t.alpha = 0;
		_t.text = "";
		_t.selectable = false;
		_t.mouseEnabled = false;
		
		FlxG.stage.addChild(_t);
		FlxG.stage.focus = _t;
		
		_t.addEventListener(Event.CHANGE,
		function test_change(e:Event)
		{
			_t.text = StringTools.replace(_t.text, "\r", "");
		}
		);
	}
	
	public function fetchFocus():Void
	{
		FlxG.stage.focus = _t;
	}

	public function getNewInput():String
	{
		var ret:String = _t.text;
		
		_t.text = "";
		
		return ret;
	}
}