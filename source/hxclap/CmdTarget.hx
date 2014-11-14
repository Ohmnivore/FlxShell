package hxclap;

import hxclap.arg.*;

/**
 * ...
 * @author Ohmnivore
 */

class CmdTarget extends CmdElem
{
	public function new(keyWord:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ)) 
	{
		super(keyWord, valueName, description, syntaxFlags);
		
		isArg = false;
	}
}