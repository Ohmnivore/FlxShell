package flxsys;

import flxsys.ScriptLexer;
import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */

class ScriptParser
{
	public var shell:FlxShell;
	public var stream:Array<Token>;
	
	private var i:Int;
	
	public function new(Stream:Array<Token>, Shell:FlxShell) 
	{
		stream = Stream;
		shell = Shell;
		
		i = 0;
		
		while (i < Stream.length)
		{
			var prev:Token = IGNORE;
			var tok:Token = Stream[i];
			var next:Token = IGNORE;
			
			if (i - 1 >= 0)
				prev = Stream[i - 1];
			if (i + 1 < Stream.length)
				next = Stream[i + 1];
			
			parseToken(tok, prev, next);
			
			i++;
		}
	}
	
	private function parseToken(T:Token, TPrevious:Token, TNext:Token):Void
	{
		if (T == PIPE || T == OUTPUT || T == OUTPUTAPPEND || T == INPUT)
		{
			parseOperator(T, TPrevious, TNext);
		}
		
		else
		{
			if (TNext != PIPE && TNext != OUTPUT && TNext != OUTPUTAPPEND && TNext != INPUT)
			{
				if (TPrevious != PIPE && TPrevious != OUTPUT && TPrevious != OUTPUTAPPEND && TPrevious != INPUT)
				{
					if (T.getName() == "COMMAND")
						parseSimpleCmd(T);
					if (T.getName() == "VALUE")
						printValue(T);
				}
			}
		}
	}
	
	public function parseSimpleCmd(C:Token):Void
	{
		shell.print(ScriptRun.parseLine(shell, StringTools.trim(C.getParameters()[0])), true);
	}
	
	private function printValue(C:Token):Void
	{
		shell.print(C.getParameters()[0], true);
	}
	
	private function parseOperator(Operator:Token, Left:Token, Right:Token):Void
	{
		//trace("Operator: ", Left, Operator, Right);
		switch(Operator.getName())
		{
			case "PIPE":
				handleOpPipe(Operator, Left, Right);
			
			case "OUTPUT":
				handleOpOutput(Operator, Left, Right, false);
			
			case "OUTPUTAPPEND":
				handleOpOutput(Operator, Left, Right, true);
			
			case "INPUT":
				handleOpInput(Operator, Left, Right);
		}
	}
	
	private function handleOpPipe(Operator:Token, Left:Token, Right:Token):Void
	{
		var val:Dynamic = null;
		if (Left.getName() == "COMMAND")
		{
			val = ScriptRun.parseLine(shell, Left.getParameters()[0], true);
		}
		else
		{
			val = Left.getParameters()[0];
		}
		
		var piped:Bool = false;
		if (i + 2 < stream.length)
			piped = true;
		var final:Dynamic = ScriptRun.parseLine(shell, Right.getParameters()[0], piped, val);
		
		stream[i - 1] = VALUE(final);
		adjustStream(Operator, Left, Right);
	}
	
	private function handleOpOutput(Operator:Token, Left:Token, Right:Token, Append:Bool):Void
	{
		var val:Dynamic = null;
		if (Left.getName() == "COMMAND")
		{
			val = ScriptRun.parseLine(shell, Left.getParameters()[0], false);
		}
		else
		{
			val = Left.getParameters()[0];
		}
		
		var path:String = Right.getParameters()[0];
		var name:String = Path.withoutDirectory(path);
		var parpath:String = Path.directory(path);
		
		try
		{
			var fold:Folder = shell.drive.readFolder(parpath, shell.curDir.path);
			
			if (fold.children.exists(name))
			{
				var f:File = cast fold.children.get(name);
				
				if (!Append)
					f.content = Std.string(val);
				else
					f.content += Std.string(val);
			}
			else
			{
				var f:File = shell.drive.newFile(fold, name);
				
				if (!Append)
					f.content = Std.string(val);
				else
					f.content += Std.string(val);
			}
		}
		
		catch (e:Dynamic)
		{
			stream = [VALUE(e)];
			i = 0;
		}
		
		stream.remove(Left);
		adjustStream(Operator, Left, Right);
	}
	
	private function handleOpInput(Operator:Token, Left:Token, Right:Token):Void
	{
		try
		{
			var path:String = Left.getParameters()[0];
			var f:File = shell.drive.readFile(path, shell.curDir.path);
			
			var piped:Bool = false;
			if (i + 2 < stream.length)
				piped = true;
			var final:Dynamic = ScriptRun.parseLine(shell, Right.getParameters()[0], piped, null, f);
			
			stream[i - 1] = VALUE(final);
			adjustStream(Operator, Left, Right);
		}
		
		catch (e:Dynamic)
		{
			stream = [VALUE(e)];
			i = 0;
		}
	}
	
	private function adjustStream(Operator:Token, Left:Token, Right:Token):Void
	{
		stream.remove(Operator);
		stream.remove(Right);
		
		i -= 2;
	}
}