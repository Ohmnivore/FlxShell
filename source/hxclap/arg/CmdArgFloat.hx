package hxclap.arg;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArgFloat extends CmdArg
{
	public var value:Float;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), def:Float = 0)
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		value = def;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		var ptr:String;
		i++;
		
		if (i < argc)
		{
			var arg:String = argv[i];
			
			try
			{
				value = Std.parseFloat(arg);
			}
			
			catch (e:Dynamic)
			{
				parseError(ArgError.INVALID_ARG, this, ArgType.ARG_FLOAT, arg);
				return false;
			}
			
			setParseOK();
			return true;
		}
		
		else
		{
			return false;
		}
	}
}