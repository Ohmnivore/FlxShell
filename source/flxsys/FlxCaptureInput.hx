package flxsys;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFieldType;

class FlxCaptureInput
{
	private var _t:TextField;
	
	public function new():Void
	{
		_t = new TextField();
		_t.type = TextFieldType.INPUT;
		_t.alpha = 0;
		_t.text = "";
		FlxG.stage.addChild(_t);
		FlxG.stage.focus = _t;
	}

	public function getNewInput():String
	{
		var ret:String = _t.text;
		
		_t.text = "";
		
		return ret;
	}
}