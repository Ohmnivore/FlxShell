package hxclap;

import hxclap.CmdArg.E_CmdArgSyntax;

import hxclap.CmdArg.CmdArgBool;
import hxclap.CmdArg.CmdArgInt;
import hxclap.CmdArg.CmdArgFloat;
import hxclap.CmdArg.CmdArgStr;
import hxclap.CmdArg.CmdArgChar;

import hxclap.CmdArg.CmdArgIntList;
import hxclap.CmdArg.CmdArgFloatList;
import hxclap.CmdArg.CmdArgStrList;
import hxclap.CmdArg.CmdArgCharList;

/**
 * ...
 * @author Ohmnivore
 */

 /**
 * The core
 */
class CmdLine
{
	private var _cmdList:Array<CmdArg>;
	private var _progName:String;
	private var _maxLength:Int;
	
	//Callbacks
	/**
	 * Called when the parser can't find the specified flag
	 */
	public var switchNotFound:String->Void;
	/**
	 * Called when a required flag wasn't passed to the parser
	 */
	public var missingRequiredSwitch:CmdArg->Void;
	
	/**
	 * Called when a flag's argument couldn't be parsed
	 */
	public var argNotFound:CmdArg->Void;
	/**
	 * Called when a flag doesn't receive its required argument
	 */
	public var missingRequiredArg:CmdArg->Void;
	
	/**
	 * @param ProgName	The program's name - typically the application's name
	 * @param cmds		Flags available for this application
	 */
	public function new(progName:String, cmds:Array<CmdArg>) 
	{
		_progName = progName;
		_maxLength = 0;
		_cmdList = [];
		
		setUpDefaultCallbacks();
		
		for (cmd in cmds)
		{
			_cmdList.push(cmd);
			_maxLength = Std.int(Math.max(_maxLength, cmd._valueName.length));
		}
	}
	
	/**
	 * Traces this function's usage using default trace()
	 */
	public function defaultTraceUsage():Void
	{
		var u:UsageInfo = usage();
		
		trace("Usage: " + u.name);
		
		for (cmd in u.args)
		{
			if (cmd.type < 5)
			{
				_traceSimple(cmd);
			}
			else
			{
				_traceList(cmd);
			}
		}
	}
	
	private function _traceSimple(cmd:ArgInfo):Void
	{
		var longName:String = cmd.longName;
		var shortName:String = cmd.shortName;
		var description:String = cmd.description;
		var expects:String = cmd.expects;
		
		if (cmd.isOPT)
		{
			longName = '[$longName]';
		}
		if (cmd.isVALOPT)
		{
			expects = '[$expects]';
		}
		
		trace('-$longName (-$shortName) -> $description -> expects: $expects');
	}
	
	private function _traceList(cmd:ArgInfo):Void
	{
		var longName:String = cmd.longName;
		var shortName:String = cmd.shortName;
		var description:String = cmd.description;
		var expects:String = cmd.expects;
		
		if (cmd.isOPT)
		{
			longName = '[$longName]';
		}
		if (cmd.isVALOPT)
		{
			expects = '[$expects]';
		}
		
		trace('-$longName (-$shortName) -> $description -> expects: $expects');
	}
	
	private function setUpDefaultCallbacks():Void
	{
		switchNotFound = HandleSwitchNotFound;
		missingRequiredSwitch = HandleMissingSwitch;
		
		argNotFound = HandleArgNotFound;
		missingRequiredArg = HandleMissingArg;
	}
	
	public function HandleSwitchNotFound(Switch:String):Void
	{
		trace("Warning: argument '" + Switch + "' looks strange, ignoring");
	}
	
	public function HandleMissingSwitch(Cmd:CmdArg):Void
	{
		trace("Error: the switch -" + Cmd.getKeyword() + " must be supplied");
	}
	
	public function HandleArgNotFound(Cmd:CmdArg):Void
	{
		trace("Error: switch -" + Cmd.getKeyword() + " must take an argument");
	}
	
	public function HandleMissingArg(Cmd:CmdArg):Void
	{
		trace("Error: the switch -" + Cmd.getKeyword() + " must take a value");
	}
	
	/**
	 * Returns this program's arguments and name in a UsageInfo object.
	 * Iterate of that object's args array to retrieve useful info
	 */
	public function usage():UsageInfo
	{
		var u:UsageInfo = new UsageInfo(_progName);
		
		for (cmd in _cmdList)
		{
			if (!cmd.isHidden())
			{
				u.args.push(new ArgInfo(cmd));
			}
		}
		
		return u;
	}
	
	/**
	 * This is probably the most essential function.
	 * @param argc		Amount of arguments you wish to pass to the parser
	 * @param argv		List of arguments to parse, ex: ["-test-arg", "1", "-B"]
	 */
	public function parse(argc:Int, argv:Array<String>):Void
	{
		var cmd:CmdArg;
		
		var i:Int = 0;
		while (i < argv.length)
		{
			var arg:String = argv[i];
			var found:Bool = false;
			
			var i2:Int = 0;
			while ((i2 < _cmdList.length) && !found)
			{
				cmd = _cmdList[i2];
				
				var cmdWord:String = "";
				var cmdChar:String = "";
				
				cmdWord = "-" + cmd.getKeyword();
				cmdChar = "-" + cmd.getOptChar();
				
				if ((arg == cmdWord) || (arg == cmdChar))
				{
					cmd.setFound();
					
					if (!cmd.getValue(i, argc, argv))
					{
						if (argNotFound != null && !cmd.isValOpt())
						{
							argNotFound(cmd);
						}
					}
					else
					{
						cmd.setValFound();
						
						if (!Std.is(cmd, CmdArgBool))
							i++;
					}
					
					found = true;
				}
				
				i2++;
			}
			
			if (!found)
			{
				if (switchNotFound != null)
				{
					switchNotFound(arg);
				}
			}
			
			i++;
		}
		
		for (cmd2 in _cmdList)
		{
			if (!cmd2.isOpt()) // i.e required
			{
				if (!cmd2.isFound())
				{
					if (missingRequiredSwitch != null)
					{
						missingRequiredSwitch(cmd2);
					}
				}
			}
			
			if (cmd2.isFound() && !cmd2.isValOpt()) // i.e need value
			{
				if (!cmd2.isValFound())
				{
					if (missingRequiredArg != null)
					{
						missingRequiredArg(cmd2);
					}
				}
			}
		}
	}
}

class UsageInfo
{
	/**
	 * Program's name as passed when the CmdLine object was constructed
	 */
	public var name:String;
	/**
	 * List of all CmdArgs added to the CmdLine object that don't have the HIDDEN flag set to true
	 */
	public var args:Array<ArgInfo>;
	
	public function new(Name:String)
	{
		name = Name;
		args = [];
	}
}

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
	
	public function new(Arg:CmdArg)
	{
		longName = Arg._keyword;
		shortName = Arg._optChar;
		description = Arg._description;
		expects = Arg._valueName;
		
		if ((Arg._syntaxFlags & E_CmdArgSyntax.isOPT) > 0)
		{
			isOPT = true;
		}
		if ((Arg._syntaxFlags & E_CmdArgSyntax.isREQ) > 0)
		{
			isREQ = true;
		}
		if ((Arg._syntaxFlags & E_CmdArgSyntax.isVALOPT) > 0)
		{
			isVALOPT = true;
		}
		if ((Arg._syntaxFlags & E_CmdArgSyntax.isVALREQ) > 0)
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
	}
	
	private function initList(Arg:CmdArg):Void
	{
		min = Reflect.field(Arg, "_min");
		max = Reflect.field(Arg, "_max");
	}
}

class ArgType
{
	public static inline var ARG_BOOL:Int = 0;
	public static inline var ARG_INT:Int = 1;
	public static inline var ARG_FLOAT:Int = 2;
	public static inline var ARG_STRING:Int = 3;
	public static inline var ARG_CHAR:Int = 4;
	
	public static inline var ARG_LIST_INT:Int = 5;
	public static inline var ARG_LIST_FLOAT:Int = 6;
	public static inline var ARG_LIST_STRING:Int = 7;
	public static inline var ARG_LIST_CHAR:Int = 8;
}