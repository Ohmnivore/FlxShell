package flxsys;
import flxsys.ScriptLexer.Token;

/**
 * ...
 * @author Ohmnivore
 */

enum Token
{
	PIPE;
	OUTPUT;
	OUTPUTAPPEND;
	INPUT;
	
	FILE(path:String);
	COMMAND(content:String);
	
	IGNORE;
}

enum Mode
{
	INCOMMAND;
	OUTCOMMAND;
}

class ScriptLexer
{
	public var mode:Mode = OUTCOMMAND;
	public var last_cmd:String = "";
	
	public function new(Inp:String) 
	{
		var tokens:Array<String> = Inp.split(" ");
		var tokenized:Array<Token> = [];
		
		//Get unprocessed array of tokens
		for (t in tokens)
		{
			t = StringTools.trim(t);
			tokenized.push(retrieve(t));
		}
		
		//Detect FILEs
		var i:Int = 0;
		while (i < tokenized.length)
		{
			var t:Token = tokenized[i];
			
			var t_before:Token = IGNORE;
			var t_after:Token = IGNORE;
			
			if (i - 1 >= 0)
				t_before = tokenized[i - 1];
			if (i + 1 < tokenized.length)
				t_after = tokenized[i + 1];
			
			if (t_before == OUTPUT || t_before == OUTPUTAPPEND)
			{
				if (t.getName() == "COMMAND")
					tokenized[i] = FILE(tokenized[i].getParameters()[0]);
			}
			
			if (t_after == INPUT)
			{
				if (t.getName() == "COMMAND")
					tokenized[i] = FILE(tokenized[i].getParameters()[0]);
			}
			
			i++;
		}
		
		//Remove phantom COMMANDs (last step)
		i = 0;
		while (i < tokenized.length - 1)
		{
			var t:Token = tokenized[i];
			var t2:Token = tokenized[i + 1];
			
			if (t.getIndex() == t2.getIndex())
			{
				tokenized.remove(t);
				i--;
			}
			
			i++;
		}
		
		trace(tokenized);
	}
	
	public function retrieve(T:String):Token
	{
		if (T == "|")
		{
			mode = OUTCOMMAND;
			return PIPE;
		}
		
		if (T == ">")
		{
			mode = OUTCOMMAND;
			return OUTPUT;
		}
		
		if (T == ">>")
		{
			mode = OUTCOMMAND;
			return OUTPUTAPPEND;
		}
		
		if (T == "<")
		{
			mode = OUTCOMMAND;
			return INPUT;
		}
		
		if (mode == OUTCOMMAND)
		{
			mode = INCOMMAND;
			last_cmd = "";
		}
		
		if (mode == INCOMMAND)
		{
			last_cmd += " " + T;
		}
		
		return COMMAND(last_cmd);
	}
}