package hxclap;

import hxclap.arg.*;

/**
 * ...
 * @author Ohmnivore
 */

class CmdElem
{
	public var isArg:Bool = true;
	public var isList:Bool = false;
	
	public var optChar:String;
	public var keyword:String;
	public var valueName:String;
	public var description:String;
	public var syntaxFlags:Int;
	public var status:Int;
	
	//Callback
	public var parseError:Int->CmdElem->Int->String->Void;
	
	public function new(keyWord:String, valueName:String, description:String, syntaxFlags:Int) 
	{
		this.keyword = keyWord;
		this.valueName = valueName;
		this.description = description;
		this.syntaxFlags = syntaxFlags;
		this.status = E_CmdArgStatus.isBAD;
		
		setUpDefaultCallbacks();
		validate_flags();
	}
	
	public function setUpDefaultCallbacks():Void
	{
		parseError = HandleParseError;
	}
	
	public function HandleParseError(E:Int, Cmd:CmdElem, T:Int, Arg:String=""):Void
	{
		if (E == ArgError.OPT_CONFLICT_REQUIRED)
		{
			trace("Warning: keyword " + Cmd.keyword + " can't be optional AND required");
			trace(" changing the syntax of " + Cmd.keyword + " to be required.");
		}
		
		if (E == ArgError.INVALID_ARG)
		{
			switch(T)
			{
				case ArgType.ARG_INT:
					trace(" invalid integer value '" + Arg + "'");
				case ArgType.ARG_FLOAT:
					trace(" invalid float value '" + Arg + "'");
				case ArgType.ARG_CHAR:
					trace(" value '" + Arg + "' is too long. ignoring");
				
				case ArgType.ARG_LIST_INT:
					trace(" invalid float value '" + Arg + "'");
				case ArgType.ARG_LIST_FLOAT:
					trace(" invalid float value '" + Arg + "'");
				case ArgType.ARG_LIST_CHAR:
					trace(" invalid float value '" + Arg + "'");
			}
		}
		
		if (E == ArgError.SPACE_DELIMITER)
		{
			trace("ERROR: space can't be a delimiter");
		}
		
		if (E == ArgError.TOO_FEW_ARGS)
		{
			trace("Too few arguments to the switch -" + Cmd.keyword);
		}
		if (E == ArgError.TOO_MANY_ARGS)
		{
			trace("Too many arguments to the switch -" + Cmd.keyword);
		}
	}
	
	public function isHidden():Bool
	{
		if (syntaxFlags & E_CmdArgSyntax.isHIDDEN > 0)
			return true;
		
		return false;
	}
	
	public function isOpt():Bool
	{
		if (syntaxFlags & E_CmdArgSyntax.isOPT > 0)
			return true;
		
		return false;
	}
	
	public function isValOpt():Bool
	{
		if (syntaxFlags & E_CmdArgSyntax.isVALOPT > 0)
			return true;
		
		return false;
	}
	
	public function isBad():Bool
	{
		if (status > 0)
			return true;
		
		return false;
	}
	
	public function isFound():Bool
	{
		if (status & E_CmdArgStatus.isFOUND > 0)
			return true;
		
		return false;
	}
	
	public function setFound():Void
	{
		status |= E_CmdArgStatus.isFOUND;
	}
	
	public function setValFound():Void
	{
		status |= E_CmdArgStatus.isVALFOUND;
	}
	
	public function isValFound():Bool
	{
		if ((status & E_CmdArgStatus.isVALFOUND) > 0)
			return true;
		
		return false;
	}
	
	public function setParseOK():Void
	{
		status |= E_CmdArgStatus.isPARSEOK;
	}
	
	public function isParseOK():Bool
	{
		if (status & E_CmdArgStatus.isPARSEOK > 0)
			return true;
		
		return false;
	}
	
	//methods
	public function isNull():Bool
	{
		return !isParseOK();
	}
	
	public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		return true;
	}
	
	public function getList(argv:Array<String>):Bool
	{
		return true;
	}
	
	public function validate_flags():Bool
	{
		if ((syntaxFlags & E_CmdArgSyntax.isOPT > 0) && (syntaxFlags & E_CmdArgSyntax.isREQ > 0))
		{
			var type:Int = 0;
			
			if (Std.is(this, CmdArgBool))
			{
				type = ArgType.ARG_BOOL;
			}
			if (Std.is(this, CmdArgInt))
			{
				type = ArgType.ARG_INT;
			}
			if (Std.is(this, CmdArgFloat))
			{
				type = ArgType.ARG_FLOAT;
			}
			if (Std.is(this, CmdArgStr))
			{
				type = ArgType.ARG_STRING;
			}
			if (Std.is(this, CmdArgChar))
			{
				type = ArgType.ARG_CHAR;
			}
			
			if (Std.is(this, CmdArgIntList))
			{
				type = ArgType.ARG_LIST_INT;
			}
			if (Std.is(this, CmdArgFloatList))
			{
				type = ArgType.ARG_LIST_FLOAT;
			}
			if (Std.is(this, CmdArgStrList))
			{
				type = ArgType.ARG_LIST_STRING;
			}
			if (Std.is(this, CmdArgCharList))
			{
				type = ArgType.ARG_LIST_CHAR;
			}
			
			if (Std.is(this, CmdTargStr))
			{
				type = ArgType.TARG_STRING;
			}
			if (Std.is(this, CmdTargStrList))
			{
				type = ArgType.TARG_LIST_STRING;
			}
			
			parseError(ArgError.OPT_CONFLICT_REQUIRED, this, type, "");
			
			syntaxFlags &= ~E_CmdArgSyntax.isOPT;
			return false;
		}
		
		if ((syntaxFlags & E_CmdArgSyntax.isVALOPT > 0) && (syntaxFlags & E_CmdArgSyntax.isVALREQ > 0))
		{
		   var type:Int = 0;
			
			if (Std.is(this, CmdArgBool))
			{
				type = ArgType.ARG_BOOL;
			}
			if (Std.is(this, CmdArgInt))
			{
				type = ArgType.ARG_INT;
			}
			if (Std.is(this, CmdArgFloat))
			{
				type = ArgType.ARG_FLOAT;
			}
			if (Std.is(this, CmdArgStr))
			{
				type = ArgType.ARG_STRING;
			}
			if (Std.is(this, CmdArgChar))
			{
				type = ArgType.ARG_CHAR;
			}
			
			if (Std.is(this, CmdArgIntList))
			{
				type = ArgType.ARG_LIST_INT;
			}
			if (Std.is(this, CmdArgFloatList))
			{
				type = ArgType.ARG_LIST_FLOAT;
			}
			if (Std.is(this, CmdArgStrList))
			{
				type = ArgType.ARG_LIST_STRING;
			}
			if (Std.is(this, CmdArgCharList))
			{
				type = ArgType.ARG_LIST_CHAR;
			}
			
			if (Std.is(this, CmdTargStr))
			{
				type = ArgType.TARG_STRING;
			}
			if (Std.is(this, CmdTargStrList))
			{
				type = ArgType.TARG_LIST_STRING;
			}
			
			parseError(ArgError.OPT_CONFLICT_REQUIRED, this, type, "");
		   
			syntaxFlags &= ~E_CmdArgSyntax.isVALREQ;
			return false;
		}
		
		return true;
	}
}