package hxclap.arg;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArgChar extends CmdArg
{
	public var value:String;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), def:String)
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		value = def;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		i++;
		
		if (i < argc)
		{
			var arg:String = argv[i];
			
			if (arg.length > 1)
			{
				parseError(ArgError.INVALID_ARG, this, ArgType.ARG_CHAR, arg);
				return false;
			}
			
			value = arg.charAt(0);
			setParseOK();
			return true;
		}
		
		else
			return false;
	}
}