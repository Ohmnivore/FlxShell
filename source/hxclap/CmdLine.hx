package hxclap;

import hxclap.E_CmdArgSyntax;

import hxclap.subarg.CmdArgBool;
import hxclap.subarg.CmdArgInt;
import hxclap.subarg.CmdArgFloat;
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
	public function getUsageString():String
	{
		var u:UsageInfo = usage();
		var ret:String = "";
		
		ret += "Usage: " + u.name + "\n";
		
		for (cmd in u.args)
		{
			if (cmd.type < 5)
			{
				ret += _traceSimple(cmd) + "\n";
			}
			else
			{
				ret += _traceList(cmd) + "\n";
			}
		}
		
		return ret;
	}
	
	private function _traceSimple(cmd:ArgInfo):String
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
		
		return '-$longName (-$shortName) -> $description -> expects: $expects';
	}
	
	private function _traceList(cmd:ArgInfo):String
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
		
		return '-$longName (-$shortName) -> $description -> expects: $expects';
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