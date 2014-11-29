package flxsys;

import hscript.Parser;
import hscript.Interp;
import hscript.Expr.Error;

/**
 * ...
 * @author Ohmnivore
 */

class FlxParser
{
	public var shell:FlxShell;
	private var _history:Array<String>;
	private var _hist_index:Int = 0;
	
	public function new(Shell:FlxShell) 
	{
		shell = Shell;
		
		clear();
	}
	
	public function clear():Void
	{
		_hist_index = 0;
		_history = [""];
	}
	
	public function getHistPrevious():String
	{
		_hist_index--;
		if (_hist_index < 0)
			_hist_index = 0;
		
		return _history[_hist_index];
	}
	
	public function getHistNext():String
	{
		_hist_index++;
		if (_hist_index >= _history.length)
			_hist_index = _history.length - 1;
		
		return _history[_hist_index];
	}
	
	public function getHistFirst():String
	{
		if (_history.length < 2)
			return "";
		return _history[1];
	}
	
	public function getHistLast():String
	{
		return _history[_history.length - 1];
	}

	public function parseStringInput(Input:String, DoPrint:Bool = true):Dynamic
	{
		_history.push(Input);
		_hist_index = _history.length;
		
		var stream = new ScriptLexer(Input, shell).stream;
		var sp:ScriptParser = new ScriptParser(stream, shell, DoPrint);
		
		return sp.ret;
	}
	
	public function tabComplete(Shell:FlxShell, Word:String):String
	{
		for (c in Shell.curDir.children.keys())
		{
			if (c.indexOf(Word) >= 0)
			{
				return c;
			}
		}
		
		return null;
	}
}