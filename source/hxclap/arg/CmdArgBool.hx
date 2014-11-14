package hxclap.arg ;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArgBool extends CmdArg
{
	public var value:Bool;
	
	public function new(optChar:String, keyword:String, description:String, syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ))
	{
		super(optChar, keyword, "", description, syntaxFlags);
		
		value = false;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		value = true;
		setParseOK();
		return true;
	}
}