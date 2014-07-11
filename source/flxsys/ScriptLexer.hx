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
	
	VALUE(content:Dynamic);
}

enum Mode
{
	INCOMMAND;
	OUTCOMMAND;
}

enum StringMode
{
	INSTRING;
	OUTSTRING;
}

class ScriptLexer
{
	public var shell:FlxShell;
	public var stream:Array<Token>;
	
	private var mode:Mode = OUTCOMMAND;
	private var stringMode:StringMode = OUTSTRING;
	private var last_cmd:String = "";
	private var string_buffer:String = "";
	
	public function new(Inp:String, Shell:FlxShell) 
	{
		shell = Shell;
		
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
		
		//Remove phantom COMMANDs and VALUEs (last step)
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
		
		for (x in tokenized)
		{
			if (x.getName() == "VALUE")
			{
				x.getParameters()[0] = [x.getParameters()[0], "", ""];
			}
		}
		
		stream = tokenized;
	}
	
	private function retrieve(T:String):Token
	{
		if (T.length > 0)
		{
			if (T.charAt(0) == "'")
			{
				stringMode = INSTRING;
				string_buffer = "";
				T = T.substr(1, T.length);
			}
			
			if (T.charAt(T.length - 1) == "'")
			{
				stringMode = OUTSTRING;
				T = T.substr(0, T.length - 1);
				string_buffer += " " + T;
				return VALUE(string_buffer);
			}
		}
		
		if (stringMode == INSTRING)
		{
			string_buffer += " " + T;
			return VALUE(string_buffer);
		}
		else
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
		}
		
		return COMMAND(StringTools.trim(last_cmd));
	}
}