package hxclap.arg;

/**
 * ...
 * @author Ohmnivore
 */

class CmdTargStr extends CmdTarget
{
	public var value:String;
	
	public function new(keyWord:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), def:String)
	{
		super(keyWord, valueName, description, syntaxFlags);
		
		value = def;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		if (i < argc)
		{
			var arg:String = argv[i];
			
			if (arg.charAt(0) == "-") return false;
			value = arg;
			setParseOK();
			return true;
		}
		
		else
			return false;
	}
}