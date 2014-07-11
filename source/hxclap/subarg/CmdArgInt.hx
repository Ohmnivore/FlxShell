package hxclap.subarg;

import hxclap.ArgError;
import hxclap.CmdArg;
import hxclap.E_CmdArgSyntax;

//Definition of class CmdArgInt
class CmdArgInt extends CmdArg
{
	public var _v:Int;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = E_CmdArgSyntax.isDefault, def:Int = 0)
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		_v = def;
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
				_v = Std.parseInt(arg);
			}
			
			catch (e:Dynamic)
			{
				parseError(ArgError.INVALID_ARG, this, ArgType.ARG_INT, arg);
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
	//operator int();
	//friend ostream& operator<<(ostream&, const CmdArgInt&);
}