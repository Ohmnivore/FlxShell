package flxsys;

import hscript.Expr.Error;
import hscript.Parser;
import hscript.Interp;

import flxsys.Drive;
import flxsys.FlxCmdLine;
import flxsys.frontends.BusFront;

import openfl.system.System;

import hxclap.arg.*;

/**
 * ...
 * @author Ohmnivore
 */

class ScriptRun
{
	static private var modules:Map<String,Dynamic>;
	static private var toImport:Map<String, String>;
	
	static private function ensureCompilation():Void
	{
		FlxCmdLine;
		CmdArgBool;
		System;
	}
	
	static public function parseLine(Shell:FlxShell, Line:String,
		Input:Dynamic = null, FileInput = null):Dynamic
	{
		var args:Array<String> = Line.split(" ");
		
		var name:String = args[0];
		
		var ret:Dynamic = ["shell: " + name + " not found", "", ""];
		
		var bin:Folder = Shell.drive.readFolder("/bin");
		
		if (bin.children.exists(name))
		{
			ret = parseScript(Shell, "/bin/" + name, args, Input, FileInput); //Must get file content from bin
		}
		else
		{
			ret = parseScript(Shell, Shell.curDir.path + "/" + name, args, Input, FileInput); //Must get file content from bin
		}
		
		return ret;
	}
	
	static public function parseScript(Shell:FlxShell, Script:String, Args:Array<String>,
		Input:Dynamic = null, FileInput = null):Dynamic
	{
		var f:File = Shell.drive.readFile(Script);
		if (checkIfShellRun(f.content))
			return parseLine(Shell, "shell " + f.path);
		else
			return parseScriptString(Shell, Shell.drive.readFile(Script).content, Args, Input, FileInput);
	}
	
	static private function checkIfShellRun(Script:String):Bool
	{
		if (Script.indexOf("#!/bin/sh;") > -1 || Script.indexOf("#!/bin/shell;") > -1)
			return true;
		
		return false;
	}
	
	static public function parseScriptString(Shell:FlxShell, Script:String, Args:Array<String>,
		Input:Dynamic = null, FileInput = null):Dynamic
	{
		var parser = new hscript.Parser();
		parser.allowTypes = true;
		toImport = new Map<String, String>();
		Script = popImports(Script);
		//#if cpp
		//Script = replaceStaticHXCLAP(Script);
		//#end
		try
		{
			var ast = parser.parseString(Script);
			//var interp = new hscript.Interp();
			var interp = new MyInterp();
			Args.shift();
			interp.variables.set("Args", Args);
			interp.variables.set("Shell", Shell);
			interp.variables.set("Bus", BusFront);
			interp.variables.set("input", Input);
			interp.variables.set("fileInput", FileInput);
			
			try
			{
				parseImports(interp);
			}
			catch (E:Dynamic)
			{
				return [E, "", ""];
			}
			try 
			{
				var value:Dynamic = interp.execute(ast);
				
				if (interp.variables.get("update") != null)
				{
					if (interp.variables.get("update") == true)
					{
						Shell.inScript = true;
						Shell.allowInput = false;
					}
					
					return [null, "", ""];
				}
				
				else
				{
					return value;
				}
			}
			catch (E:Dynamic)
			{
				return [E, "", ""];
			}
		}
		catch (E:Error)
		{
			return [
				"Error on line " + Std.string(parser.line) + 
				" [Index:" + Std.string(E.getIndex()) + 
				" Name:" + E.getName() + 
				" Params:" + Std.string(E.getParameters()) + "]", "", ""];
		}
	}
	
	static private function popImports(Script:String):String
	{
		var lines:Array<String> = Script.split(";");
		
		for (l in lines)
		{
			l = StringTools.trim(l);
			
			if (l.substr(0, 6) == "import")
			{
				var className:String = l.substring(7, l.length);
				var name = className.split(".").pop();
				
				if (!BlockedClasses.has(className))
				{
					toImport.set(name, className);
				}
				
				Script = StringTools.replace(Script, l + ";", "");
			}
		}
		
		return Script;
	}
	
	//static private function parseImports(interp:Interp):Void
	static private function parseImports(interp:MyInterp):Void
	{
		for (name in toImport.keys())
		{
			interp.variables.set(name, getClass(toImport.get(name)));
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
				throw 'Import of class $path failed.';
			}
		}
	}
	
	static public function replaceStaticHXCLAP(Script:String):String
	{
		var ret:String = StringTools.replace(Script, "E_CmdArgSyntax.isOPT", "1");
		ret = StringTools.replace(ret, "E_CmdArgSyntax.isREQ", "2");
		ret = StringTools.replace(ret, "E_CmdArgSyntax.isVALOPT", "4");
		ret = StringTools.replace(ret, "E_CmdArgSyntax.isVALREQ", "8");
		ret = StringTools.replace(ret, "E_CmdArgSyntax.isHIDDEN", "16");
		
		return ret;
	}
}