package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArg extends CmdElem
{
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ)) 
	{
		this.optChar = optChar;
		
		super(keyword, valueName, description, syntaxFlags);
	}
}