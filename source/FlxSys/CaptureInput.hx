package flxsys;

import flash.display.Sprite;
import flash.display.Stage;
import flash.text.*;
import flash.events.*;
import flixel.FlxG;

class CaptureInput extends TextField
{
	public function new():Void
	{
		super();
		captureText();
	}

	public function CaptureUserInput():Void
	{
		captureText();
	}

	public function captureText():Void
	{
	    type = TextFieldType.INPUT;
	    alpha = 0;
	    //background = true;
	    FlxG.stage.addChild(this);
	    text = "";
	}
}
