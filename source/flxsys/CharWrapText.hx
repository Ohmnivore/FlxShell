package flxsys;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class CharWrapText extends FlxText
{
	public var charWidth:Float;
	public var widthLimit:Float;
	public var realText:String;
	
	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0,
		?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
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
}