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
	static public var bins:Array<String> = ["cd", "ls"];
	static var modules:Map<String,Dynamic>;
	
	static public function parseLine(Shell:FlxShell, Line:String) 
	{
		var args:Array<String> = Line.split(" ");
		
		var name:String = args[0];
		//args = args.splice(0, 1);
		
		if (Lambda.has(bins, name))
		{
			parseScript(Shell, "/bin/" + name, args); //Must get file content from bin
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
			interp.variables.set("piped", false);
			try
			{
				parseImports(Script, interp);
			}
			catch (E:Dynamic)
			{
				Shell.print(E, true);
				return;
			}
			try 
			{
				var value:Dynamic = interp.execute(ast);
				Shell.print(value, false);
			}
			catch (E:Dynamic)
			{
				Shell.print(E, true);
				return;
			}
		}
		catch (E:Error)
		{
			Shell.print(
				"Error on line " + Std.string(parser.line) + 
				" [Index:" + Std.string(E.getIndex()) + 
				" Name:" + E.getName() + 
				" Params:" + Std.string(E.getParameters()) + "]", 
				true);
			return;
		}
	}
	
	static public function parseImports(script:String, interp:Interp)
	{
		var lines:Array<String> = script.split(";");
		
		for (l in lines)
		{
			l = StringTools.trim(l);
			
			if (l.substr(0, 6) == "import")
			{
				var className:String = l.substring(7, l.length);
				var name = className.split(".").pop();
				var c:Dynamic = getClass(className);
				interp.variables.set(name, c);
			}
		}
	}
	
	static public function __init__()
	{
		modules = new Map<String,Dynamic>();
	}
	
	/**
	 * Gets or creates an instance of a class
	 * @param	path
	 * @return
	 */
	static public function getClass(path:String):Dynamic
	{
		if (modules.exists(path))
		{
			return modules.get(path);
		}
		else
		{
			var myClass:Dynamic = Type.resolveClass(path);
			if (myClass != null)
			{
				modules.set(path, myClass);
				return(modules.get(path));
			}
			else
			{
				throw "expose attempt failed";
			}
		}
	}
}