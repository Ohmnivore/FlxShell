package hxclap.arg;

import hxclap.CmdTargTypeList;

/**
 * ...
 * @author Ohmnivore
 */

class CmdTargStrList extends CmdTargTypeList<String>
{
	public function new(keyWord:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), minSize:Int = 1,
		maxSize:Int = 100)
	{
		super(keyWord, valueName, description, syntaxFlags, minSize, maxSize);
	}
	
	override public function getList(argv:Array<String>):Bool
	{
		for (v in argv)
		{
			insert(v);
		}
		
		return validate();
	}
}