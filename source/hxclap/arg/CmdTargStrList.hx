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
		maxSize:Int = 100, delim:String = ",~/")
	{
		super(keyWord, valueName, description, syntaxFlags, minSize, maxSize, delim);
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		if (i < argc)
		{
			var tokens:String = argv[i];
			
			var tokens_arr:Array<String> = tokens.split(delimiters.charAt(0));
			
			for (v in tokens_arr)
			{
				insert(v);
			}
			
			return validate();
		}
		
		else
			return false;
	}
}