package hxclap;

import hxclap.arg.*;

/**
 * ...
 * @author Ohmnivore
 */

class ArgInfo
{
	/**
	 * ex: test-arg
	 */
	public var longName:String;
	/**
	 * ex: t
	 */
	public var shortName:String;
	
	public var description:String;
	/**
	 * Describes what sort of argument is expected for this switch
	 */
	public var expects:String;
	/**
	 * Minimum amount of arguments to be passed for this switch.
	 * Only applies to list command arguments.
	 */
	public var min:Int = 0;
	/**
	 * Maximum amount of arguments to be passed for this switch.
	 * Only applies to list command arguments.
	 */
	public var max:Int = 100;
	/**
	 * The type of this argument, as defined in ArgType
	 */
	public var type:Int;
	
	/**
	 * Whether this argument is optional
	 */
	public var isOPT:Bool = false;
	/**
	 * Wether this argument is required
	 */
	public var isREQ:Bool = false;
	/**
	 * Wether an argument for this switch is optional
	 */
	public var isVALOPT:Bool = false;
	/**
	 * Wether an argument is required for this switch
	 */
	public var isVALREQ:Bool = false;
	
	public function new(Arg:CmdElem)
	{
		longName = Arg.keyword;
		shortName = Arg.optChar;
		description = Arg.description;
		expects = Arg.valueName;
		
		if ((Arg.syntaxFlags & E_CmdArgSyntax.isOPT) > 0)
		{
			isOPT = true;
		}
		if ((Arg.syntaxFlags & E_CmdArgSyntax.isREQ) > 0)
		{
			isREQ = true;
		}
		if ((Arg.syntaxFlags & E_CmdArgSyntax.isVALOPT) > 0)
		{
			isVALOPT = true;
		}
		if ((Arg.syntaxFlags & E_CmdArgSyntax.isVALREQ) > 0)
		{
			isVALREQ = true;
		}
		
		//Simple
		if (Std.is(Arg, CmdArgBool))
		{
			type = ArgType.ARG_BOOL;
		}
		if (Std.is(Arg, CmdArgInt))
		{
			type = ArgType.ARG_INT;
		}
		if (Std.is(Arg, CmdArgFloat))
		{
			type = ArgType.ARG_FLOAT;
		}
		if (Std.is(Arg, CmdArgStr))
		{
			type = ArgType.ARG_STRING;
		}
		if (Std.is(Arg, CmdArgChar))
		{
			type = ArgType.ARG_CHAR;
		}
		
		//Lists
		if (Std.is(Arg, CmdArgIntList))
		{
			type = ArgType.ARG_LIST_INT;
			initList(Arg);
		}
		if (Std.is(Arg, CmdArgFloatList))
		{
			type = ArgType.ARG_LIST_FLOAT;
			initList(Arg);
		}
		if (Std.is(Arg, CmdArgStrList))
		{
			type = ArgType.ARG_LIST_STRING;
			initList(Arg);
		}
		if (Std.is(Arg, CmdArgCharList))
		{
			type = ArgType.ARG_LIST_CHAR;
			initList(Arg);
		}
		
		//Other
		if (Std.is(Arg, CmdTargStr))
		{
			type = ArgType.TARG_STRING;
		}
		if (Std.is(Arg, CmdTargStrList))
		{
			type = ArgType.TARG_LIST_STRING;
			initList(Arg);
		}
	}
	
	private function initList(Arg:CmdElem):Void
	{
		min = Reflect.field(Arg, "_min");
		max = Reflect.field(Arg, "_max");
	}
}