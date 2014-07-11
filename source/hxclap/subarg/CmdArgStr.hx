package hxclap.subarg;

import hxclap.ArgError;
import hxclap.CmdArg;

//Definition of class CmdArgStr
class CmdArgStr extends CmdArg
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
			
			if (arg.charAt(0) == "-") return false;
			_v = arg;
			setParseOK();
			return true;
		}
		
		else
			return false;
	}
	//operator char*();
	//friend ostream& operator<<(ostream&, const CmdArgStr&);
}