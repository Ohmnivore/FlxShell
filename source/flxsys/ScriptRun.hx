package flxsys;

import hscript.Expr.Error;
import hscript.Parser;
import hscript.Interp;

import flxsys.Drive;

/**
 * ...
 * @author Ohmnivore
 */

class ScriptRun
{
	static private var bins:Array<String> = ["cd", "ls"];
	static private var modules:Map<String,Dynamic>;
	
	static public function parseLine(Shell:FlxShell, Line:String, Piped:Bool = false, Input:Dynamic = null, FileInput = null):Dynamic
	{
		var args:Array<String> = Line.split(" ");
		
		var name:String = args[0];
		
		var ret:Dynamic = "shell: " + name + " not found";
		
		if (Lambda.has(bins, name))
		{
			ret = parseScript(Shell, "/bin/" + name, args, Piped, Input, FileInput); //Must get file content from bin
		}
		
		return ret;
	}
	
	static private function parseScript(Shell:FlxShell, Script:String, Args:Array<String>,
		Piped:Bool = false, Input:Dynamic = null, FileInput = null):Dynamic
	{
		Script = Shell.drive.readFile(Script).content;
		
		var parser = new hscript.Parser();
		try
		{
			var ast = parser.parseString(Script);
			var interp = new hscript.Interp();
			interp.variables.set("Args", Args);
			interp.variables.set("Shell", Shell);
			interp.variables.set("piped", Piped);
			interp.variables.set("input", Input);
			interp.variables.set("fileInput", FileInput);
			try
			{
				parseImports(Script, interp);
			}
			catch (E:Dynamic)
			{
				return E;
			}
			try 
			{
				var value:Dynamic = interp.execute(ast);
				return value;
			}
			catch (E:Dynamic)
			{
				return E;
			}
		}
		catch (E:Error)
		{
			return
				"Error on line " + Std.string(parser.line) + 
				" [Index:" + Std.string(E.getIndex()) + 
				" Name:" + E.getName() + 
				" Params:" + Std.string(E.getParameters()) + "]";
		}
	}
	
	static private function parseImports(script:String, interp:Interp)
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
	static private function getClass(path:String):Dynamic
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