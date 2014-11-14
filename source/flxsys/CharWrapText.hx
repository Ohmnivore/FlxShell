package flxsys;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ohmnivore
 */
class CharWrapText extends FlxText
{
	public var charWidth:Float;
	public var widthLimit:Float;
	public var realText:String;
	public var drawHeightCutoff:Float;
	
	public function new(DrawHeightCutoff:Float, X:Float = 0, Y:Float = 0, FieldWidth:Float = 0,
		?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		drawHeightCutoff = DrawHeightCutoff;
		realText = "";
		if (Text != null)
			realText = Text;
		
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
	}
	
	override private function set_text(Text:String):String 
	{
		var ot:String = realText;
		realText = Text;
		
		if (realText != ot)
		{
			_textField.text = charWrap(Text);
			dirty = true;
		}
		
		return realText;
	}
	
	private function charWrap(Inp:String):String
	{
		var i:Int = 2;
		var charCounter:Int = 0;
		
		while (i < Inp.length)
		{
			var pos = Inp.indexOf(Util.NEWLINE, i);
			if (pos == i)
			{
				charCounter = 0;
			}
			
			if (charCounter >= Math.floor(widthLimit / charWidth))
			{
				Inp = Inp.substr(0, i) + Util.NEWLINE + Inp.substring(i, Inp.length);
				charCounter = 0;
			}
			
			charCounter++;
			i++;
		}
		
		return Inp;
	}
	
	override function regenGraphics():Void 
	{
		var oldWidth:Float = cachedGraphics.bitmap.width;
		var oldHeight:Float = cachedGraphics.bitmap.height;
		
		var newWidth:Float = _textField.width + _widthInc;
		// Account for 2px gutter on top and bottom (that's why there is "+ 4")
		//var newHeight:Float = _textField.textHeight + _heightInc + 4;
		var newHeight:Float = drawHeightCutoff;
		
		// prevent text height from shrinking on flash if text == ""
		if (_textField.textHeight == 0) 
		{
			newHeight = oldHeight;
		}
		
		if ((oldWidth != newWidth) || (oldHeight != newHeight))
		{
			// Need to generate a new buffer to store the text graphic
			height = newHeight - _heightInc;
			var key:String = cachedGraphics.key;
			FlxG.bitmap.remove(key);
			
			makeGraphic(Std.int(newWidth), Std.int(newHeight), FlxColor.TRANSPARENT, false, key);
			frameHeight = Std.int(height);
			_textField.height = height * 1.2;
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = newWidth;
			_flashRect.height = newHeight;
		}
		// Else just clear the old buffer before redrawing the text
		else
		{
			cachedGraphics.bitmap.fillRect(_flashRect, FlxColor.TRANSPARENT);
		}
	}
}