package flxsys;

/**
 * ...
 * @author Ohmnivore
 */
class BashParser
{
	public static var tabstart:Int = 0;
	public static var tablength:Int = 0;
	public static var tababs:Bool = false;
	
	
	static public function getTabTarget(Cons:Console):String
	{
		var cmd:String = Cons._finalText.substring(Cons.eraseblock, Cons._finalText.length);
		//if (cmd.charAt(0) == Disk.delimiter) tababs = true;
		var possibilities:Array<String> = cmd.split(" ");
		
		if (possibilities.length == 0)
			possibilities.push(cmd);
		//trace(possibilities)
		var startpos:Int = 0;
		var curindex:Int = Cons.cursorPos - Cons.eraseblock;
		//trace('curindex: $curindex, plength: $possibilities.length');
		var found:String = "";
		
		for (t in possibilities)
		{
			if (startpos < curindex && curindex <= t.length + startpos)
			{
				found = t;
				tabstart = startpos;
				tablength = t.length;
				
				if (found.charAt(0) == Disk.delimiter) tababs = true;
			}
			
			startpos += t.length + 1;
		}
		
		return found;
	}
	
	static public function getTabChoices(Path:String, Drive:Disk):Array<String>
	{
		if (Disk.isAbsPath(Path)) Path = Path.substr(1, Path.length - 1);
		var paths:Array<String> = Path.split(Disk.delimiter);
		//trace(paths);
		
		if (paths.length > 1) 
		{
			paths.pop();
			
			var parentstring:String = Disk.delimiter;
			for (item in paths)
			{
				parentstring += item + Disk.delimiter;
			}
			
			var choices:Array<String> = Disk.listChildren(parentstring, Drive);
			return choices;
		}
		
		else
		{
			var choices:Array<String> = Reflect.fields(Drive.fs);
			return choices;
		}
	}
	
	static public function tabComplete(Cons:Console):Void
	{
		var path:String = getTabTarget(Cons);
		var choices:Array<String> = getTabChoices(path, Cons.disk);
		var tomatch:Array<String> = path.split(Disk.delimiter);
		if (tomatch.length == 0) tomatch.push(path);
		var tofind:String = tomatch[tomatch.length - 1];
		
		for (item in choices)
		{
			if (item.indexOf(tofind, 0) != -1 && tofind != "" && tofind != " ")
			{
				var prefix:Array<String> = path.split(Disk.delimiter);
				prefix.pop();
				prefix.push(item);
				
				var final:String = "";
				for (element in prefix)
				{
					final += Disk.delimiter + element;
				}
				
				if (!tababs) 
				{
					final = final.substr(1, final.length - 1);
				}
				else
				{
					final = final.substr(1, final.length - 1);
				}
				tababs = false;
				
				//trace(final);
				//var cmd:String = Cons._finalText.substring(Cons.eraseblock, Cons._finalText.length);
				Cons._finalText = Cons._finalText.substring(0, Cons.eraseblock + tabstart) +
				final +
				Cons._finalText.substring(Cons.eraseblock + tabstart + tablength, Cons._finalText.length);
				Cons.cursorPos = Cons.eraseblock + tabstart + tablength + 1;
			}
		}
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
				//Cons.giveControl();
			}
		}
		Cons.giveControl();
	}
}