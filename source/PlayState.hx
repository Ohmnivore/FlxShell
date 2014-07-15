package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flxsys.FlxEditor;
import flxsys.FlxShell;
//import flash.text.Font;

//Monaco font
//@:font("assets/images/Monaco.ttf") private class ShellFont extends Font { }

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var char:CharWidthFinder;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		//Font.registerFont(ShellFont);
		//char = new CharWidthFinder(12);
		//char.font = "assets/images/Monaco.ttf";
		//add(char);
		
		//openSubState(new FlxShell("User"));
		add(new FlxShell("User"));
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.ENTER)
		{
			trace(char.curChar);
		}
	}	
}