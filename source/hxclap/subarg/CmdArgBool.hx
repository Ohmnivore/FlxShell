package hxclap.subarg;

import hxclap.ArgError;
import hxclap.CmdArg;
import hxclap.E_CmdArgSyntax;

//Definition of class CmdArgBool
class CmdArgBool extends CmdArg
{
	public var _v:Bool;
	
	public function new(optChar:String, keyword:String, description:String, syntaxFlags:Int = E_CmdArgSyntax.isDefault)
	{
		super(optChar, keyword, "", description, syntaxFlags);
		
		_v = false;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		_v = true;
		setParseOK();
		return true;
	}
	//operator bool();
	//friend ostream& operator<<(ostream&, const CmdArgBool&);
}