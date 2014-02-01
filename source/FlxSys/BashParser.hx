package flxsys;

/**
 * ...
 * @author Ohmnivore
 */
class BashParser
{

	public function new() 
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