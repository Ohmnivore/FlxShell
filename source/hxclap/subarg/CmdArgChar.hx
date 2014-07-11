package hxclap.subarg;

import hxclap.ArgError;
import hxclap.CmdArg;
import hxclap.E_CmdArgSyntax;

//Definition of class CmdArgChar
class CmdArgChar extends CmdArg
{
	public var _v:String;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = E_CmdArgSyntax.isDefault, def:String)
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		_v = def;
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
			
			_v = arg.charAt(0);
			setParseOK();
			return true;
		}
		
		else
			return false;
	}
	//operator char();
	//friend ostream& operator<<(ostream&, const CmdArgChar&);
}