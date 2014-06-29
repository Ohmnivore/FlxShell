package hxclap;

import hxclap.E_CmdArgStatus;
import hxclap.E_CmdArgSyntax;

import hxclap.subarg.CmdArgInt;
import hxclap.subarg.CmdArgFloat;
import hxclap.subarg.CmdArgBool;
import hxclap.subarg.CmdArgStr;
import hxclap.subarg.CmdArgChar;

import hxclap.subarg.CmdArgIntList;
import hxclap.subarg.CmdArgFloatList;
import hxclap.subarg.CmdArgStrList;
import hxclap.subarg.CmdArgCharList;

/**
 * ...
 * @author Ohmnivore
 */

//Definition of class CmdArg
class CmdArg
{
	public var _optChar:String;
	public var _keyword:String;
	public var _valueName:String;
	public var _description:String;
	public var _syntaxFlags:Int;
	public var _status:Int;
	
	//Callback
	public var parseError:Int->CmdArg->Int->String->Void;
	
	public function setUpDefaultCallbacks():Void
	{
		parseError = HandleParseError;
	}
	
	public function HandleParseError(E:Int, Cmd:CmdArg, T:Int, Arg:String=""):Void
	{
		if (E == ArgError.OPT_CONFLICT_REQUIRED)
		{
			trace("Warning: keyword " + Cmd.getKeyword() + " can't be optional AND required");
			trace(" changing the syntax of " + Cmd.getKeyword() + " to be required.");
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
			trace("Too few arguments to the switch -" + Cmd.getKeyword());
		}
		if (E == ArgError.TOO_MANY_ARGS)
		{
			trace("Too many arguments to the switch -" + Cmd.getKeyword());
		}
	}
	
	private function setValueName(S:String):Void
	{
		_valueName = S;
	}
	
	private function setDescription(S:String):Void
	{
		_description = S;
	}
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ)) 
	{
		_optChar = optChar;
		_keyword = keyword;
		_valueName = valueName;
		_description = description;
		_syntaxFlags = syntaxFlags;
		_status = E_CmdArgStatus.isBAD;
		
		setUpDefaultCallbacks();
		validate_flags();
	}
	
	// selectors
	public function getOptChar():String
	{
		return _optChar;
	}
	
	public function getKeyword():String
	{
		return _keyword;
	}
	
	public function getValueName():String
	{
		return _valueName;
	}
	
	public function getDescription():String
	{
		return _description;
	}
	
	public function getSyntaxFlags():Int
	{
		return _syntaxFlags;
	}
	
	public function isHidden():Bool
	{
		//return (_syntaxFlags & E_CmdArgSyntax.isHIDDEN);
		if (_syntaxFlags & E_CmdArgSyntax.isHIDDEN > 0)
			return true;
		
		return false;
	}
	
	public function isOpt():Bool
	{
		//return (_syntaxFlags & E_CmdArgSyntax.isOPT);
		if (_syntaxFlags & E_CmdArgSyntax.isOPT > 0)
			return true;
		
		return false;
	}
	
	public function isValOpt():Bool
	{
		//return (_syntaxFlags & E_CmdArgSyntax.isVALOPT);
		if (_syntaxFlags & E_CmdArgSyntax.isVALOPT > 0)
			return true;
		
		return false;
	}
	
	public function isBad():Bool
	{
		//return _status;
		if (_status > 0)
			return true;
		
		return false;
	}
	
	public function setFound():Void
	{
		_status |= E_CmdArgStatus.isFOUND;
	}
	
	public function isFound():Bool
	{
		if (_status & E_CmdArgStatus.isFOUND > 0)
			return true;
		
		return false;
	}
	
	public function setValFound():Void
	{
		_status |= E_CmdArgStatus.isVALFOUND;
	}
	
	public function isValFound():Bool
	{
		//return (_status & E_CmdArgStatus.isVALFOUND);
		if ((_status & E_CmdArgStatus.isVALFOUND) > 0)
			return true;
		
		return false;
	}
	
	public function setParseOK():Void
	{
		_status |= E_CmdArgStatus.isPARSEOK;
	}
	
	public function isParseOK():Bool
	{
		//return (_status & E_CmdArgStatus.isPARSEOK);
		if (_status & E_CmdArgStatus.isPARSEOK > 0)
			return true;
		
		return false;
	}
	
	// methods
	public function isNull():Bool
	{
		return !isParseOK();
	}
	
	public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		return true;
	}
	
	public function validate_flags():Bool
	{
		if ((_syntaxFlags & E_CmdArgSyntax.isOPT > 0) && (_syntaxFlags & E_CmdArgSyntax.isREQ > 0))
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
			
			parseError(ArgError.OPT_CONFLICT_REQUIRED, this, type, "");
			
			_syntaxFlags &= ~E_CmdArgSyntax.isOPT;
			return false;
		}
		
		if ((_syntaxFlags & E_CmdArgSyntax.isVALOPT > 0) && (_syntaxFlags & E_CmdArgSyntax.isVALREQ > 0))
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
			
			parseError(ArgError.OPT_CONFLICT_REQUIRED, this, type, "");
		   
			_syntaxFlags &= ~E_CmdArgSyntax.isVALREQ;
			return false;
		}
		
		return true;
	}
}

//Definition of CmdArgTypeList
class CmdArgTypeList<T> extends CmdArg
{
	public var _list:Array<T>;
	public var _index:Int;
	public var _delimiters:String;
	public var _max:Int;
	public var _min:Int;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ),
		minSize:Int = 1,
		maxSize:Int = 100,
		delim:String = ",-~/.")
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		_delimiters = delim;
		_min = minSize;
		_max = maxSize;
		_list = [];
		
		var buf:String = "";
		buf = getValueName();
		if (buf.length == 0)
			buf += " ";
		buf += _delimiters.charAt(0) + " ..." + _delimiters.charAt(0) + " " + getValueName() + ' (Min: $_min Max: $_max)';
		setValueName(buf);
		
		buf = "";
		buf += '$description';
		setDescription(buf);
		
		var i:Int = 0;
		while (i < delim.length)
		{
			if (delim.charAt(i) == ' ')
			{
				parseError(ArgError.SPACE_DELIMITER, this, ArgType.ARG_LIST_STRING, "");
			}
			
			i++;
		}
	}
	
	public function getDelimiters():String
	{
		return _delimiters;
	}
	
	public function getMaxSize():Int
	{
		return _max;
	}
	
	public function getMinSize():Int
	{
		return _min;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		return true;
	}
	
	public function getItem(Index:Int):T
	{
		Index = Index % _list.length;
		while (_index != Index)
		{
			if (_index < Index)
			{
				_index++;
			}
			else
			{
				_index++;
			}
		}
		
		return _list[_index];
	}
	
	public function reset():Void
	{
		_index = 0;
	}
	
	public function size():Int
	{
		return _list.length;
	}
	
	public function insert(Item:T):Void
	{
		if (_list.length < _max)
		{
			_list.push(Item);
		}
	}
	
	public function validate():Bool
	{
		if (_list.length < _min)
		{
			parseError(ArgError.TOO_FEW_ARGS, this, ArgType.ARG_LIST_INT, "");
			return false;
		}
		
		if (_list.length > _max)
		{
			parseError(ArgError.TOO_MANY_ARGS, this, ArgType.ARG_LIST_INT, "");
			return false;
		}
		
		reset();
		setParseOK();
		return true;
	}
	
	//friend ostream& operator<< <>(ostream&, const CmdArgTypeList<T>&);
	//ostream& print_me(ostream&) const;
}