package flxsys;

/**
 * ...
 * @author Ohmnivore
 */
class BashParser
{

	static public function getTabTarget():String
	{
		var cmd:String = _finalText.substring(eraseblock, _finalText.length);
		var possibilities:Array<String> = cmd.split(" ");
		
		if (possibilities.length == 0)
			possibilities.push(cmd);
		
		var startpos:Int = 0;
		var curindex:Int = cursorPos - eraseblock;
		//trace('curindex: $curindex, plength: $possibilities.length');
		var found:String = "";
		
		for (t in possibilities)
		{
			if (startpos < curindex && curindex <= t.length + startpos)
			{
				found = t;
			}
			
			startpos += t.length + 1;
		}
		
		return found;
	}
	
	static public function getTabTarget():String
	{
		
	}
	
	static public function parse(Input:String, Cons:Console):Void
	{
		//trace(Input);
		if (Input.split("/").length == 1)
		{
			try
			{
				//trace(Input);
				var parser = new hscript.Parser();
				untyped {var program = parser.parseString(Reflect.field(Reflect.field(Cons.disk.fs, "bin"), Input));
				var interp = new hscript.Interp();
				interp.variables.set("Cons", Cons);
				interp.execute(program);}
			}
			
			catch (e: Dynamic)
			{
				Cons.print('-bash: $Input: command not found');
				Cons.giveControl();
			}
		}
	}
}