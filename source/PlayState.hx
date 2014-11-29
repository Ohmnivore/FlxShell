package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flxsys.FlxEditor;
import flxsys.FlxShell;
import flxsys.Drive;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var shell:FlxShell;
	var shells:Array<FlxShell> = [];
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.scaleMode = new FixedScaleMode();
		
		super.create();
		
		shell = makeShell();
		makeShell(shell.drive);
		makeShell(shell.drive);
		makeShell(shell.drive);
		makeShell(shell.drive);
		
		closeShells();
		shell.open();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	private function makeShell(D:Drive = null):FlxShell
	{
		var shell:FlxShell = new FlxShell("User", "SYS", D);
		add(shell);
		shells.push(shell);
		
		return shell;
	}
	
	private function closeShells():Void
	{
		for (s in shells)
		{
			s.close();
		}
	}
	
	private function toggleShell(Index:Int):Void
	{
		var s:FlxShell = shells[Index];
		
		closeShells();
		s.open();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		#if !FLX_NO_DEBUG
		updateDebug();
		#end
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			shell.toggle();
		}
		
		if (FlxG.keys.justPressed.F1)
		{
			toggleShell(0);
		}
		if (FlxG.keys.justPressed.F2)
		{
			toggleShell(1);
		}
		if (FlxG.keys.justPressed.F3)
		{
			toggleShell(2);
		}
		if (FlxG.keys.justPressed.F4)
		{
			toggleShell(3);
		}
		if (FlxG.keys.justPressed.F5)
		{
			toggleShell(4);
		}
	}
	
	private function updateDebug():Void
	{
		if (FlxG.keys.justPressed.F12)
		{
			FlxG.save.bind("FlxOS");
			FlxG.save.erase();
			FlxG.save.close();
		}
	}
}