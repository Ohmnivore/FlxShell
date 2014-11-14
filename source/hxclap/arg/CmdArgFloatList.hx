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
		maxSize:Int = 100, delim:String = ",~/")
	{
		super(optChar, keyword, valueName, description, syntaxFlags, minSize, maxSize, delim);
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		i++;
		
		if (i < argc)
		{
			var tokens:String = argv[i];
			
			var tokens_arr:Array<String> = tokens.split(delimiters.charAt(0));
			
			for (v in tokens_arr)
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
		
		else
			return false;
	}
}