package ;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Ohmnivore
 */
class CharWidthFinder extends FlxText
{
	public var curChar:Int = 0;
	
	public function new(FontSize:Int = 12, Font:Dynamic = null) 
	{
		if (Font == null)
			super(0, 0, 0, "", FontSize);
		else
			super(0, 0, 0, "", FontSize, Font);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (frameWidth < FlxG.width - 5)
		{
			curChar++;
			text += "0";
		}
	}
}