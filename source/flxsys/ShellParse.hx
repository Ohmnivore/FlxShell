package flxsys;

import hscript.Expr.Error;
import hscript.Parser;
import hscript.Interp;

import flxsys.Drive;

/**
 * ...
 * @author Ohmnivore
 */

class ShellParse
{
	static public var bins:Array<String> = ["ls"];
	
	static public function parseLine(Shell:FlxShell, Line:String) 
	{
		var args:Array<String> = Line.split(" ");
		
		var name:String = args[0];
		args = args.splice(0, 1);
		
		if (Lambda.has(bins, name))
		{
			parseScript(Shell, "bin/" + name, args); //Must get file content from bin
		}
		else
		{
			//Not an executable command
			Shell.print("shell: " + name + " not found", true);
		}
	}
	
	static public function parseScript(Shell:FlxShell, Script:String, Args:Array<String>):Void
	{
		Script = Shell.drive.readFile(Script).content;
		
		var parser = new hscript.Parser();
		try
		{
			var ast = parser.parseString(Script);
			var interp = new hscript.Interp();
			interp.variables.set("Args", Args);
			interp.variables.set("Shell", Shell);
			Shell.print(interp.execute(ast), true);
		}
		catch (E:Error)
		{
			Shell.print(
				"Error on line " + Std.string(parser.line) + 
				" [Index:" + Std.string(E.getIndex()) + 
				" Name:" + E.getName() + 
				" Params:" + Std.string(E.getParameters()) + "]", 
				true);
		}
	}
}