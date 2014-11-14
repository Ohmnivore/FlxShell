package hxclap.arg;

import hxclap.CmdArgTypeList;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArgFloatList extends CmdArgTypeList<Float>
{
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ), minSize:Int = 1,
		maxSize:Int = 100)
	{
		super(optChar, keyword, valueName, description, syntaxFlags, minSize, maxSize);
	}
	
	override public function getList(argv:Array<String>):Bool
	{
		for (v in argv)
		{
			var value:Dynamic = Std.parseFloat(v);
			
			if (value != null)
			{
				insert(value);
			}
			else
			{
				parseError(ArgError.INVALID_ARG, this, ArgType.ARG_LIST_FLOAT, v);
				return false;
			}
		}
		
		return validate();
	}
}