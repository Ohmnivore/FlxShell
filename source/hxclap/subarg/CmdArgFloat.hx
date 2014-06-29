package hxclap.subarg;

import hxclap.ArgError;
import hxclap.CmdArg;

//Definition of class CmdArgFloat
class CmdArgFloat extends CmdArg
{
	public var _v:Float;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), def:Float = 0)
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
				_v = Std.parseFloat(arg);
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
	//operator float();
    //friend ostream& operator<<(ostream&, const CmdArgFloat&);
}