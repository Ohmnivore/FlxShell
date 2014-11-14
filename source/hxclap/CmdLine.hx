package hxclap;

import hxclap.arg.*;

/**
 * ...
 * @author Ohmnivore
 */

 /**
 * The core
 */
class CmdLine
{
	private var _cmdList:Array<CmdElem>;
	private var _targList:Array<CmdTarget>;
	private var _progName:String;
	private var _maxLength:Int;
	
	private var _expectsAtLeastOne:Bool = false;
	
	//Callbacks
	/**
	 * Called when the parser can't find the specified flag
	 */
	public var switchNotFound:String->Void;
	/**
	 * Called when a required flag wasn't passed to the parser
	 */
	public var missingRequiredSwitch:CmdElem->Void;
	
	/**
	 * Called when a flag's argument couldn't be parsed
	 */
	public var argNotFound:CmdElem->Void;
	/**
	 * Called when a flag doesn't receive its required argument
	 */
	public var missingRequiredArg:CmdElem->Void;
	
	/**
	 * Called when a flag doesn't receive its required argument
	 */
	public var noArgsPassed:Void->Void;
	
	/**
	 * @param ProgName	The program's name - typically the application's name
	 * @param cmds		Flags available for this application
	 */
	public function new(progName:String, cmds:Array<CmdElem>) 
	{
		_progName = progName;
		_maxLength = 0;
		_cmdList = [];
		_targList = [];
		
		setUpDefaultCallbacks();
		
		for (cmd in cmds)
		{
			_cmdList.push(cmd);
			_maxLength = Std.int(Math.max(_maxLength, cmd.valueName.length));
			
			if (!cmd.isArg)
			{
				_targList.push(cast cmd);
			}
			
			if (!cmd.isOpt())
				_expectsAtLeastOne = true;
		}
	}
	
	/**
	 * Returns this function's usage
	 */
	public function defaultTraceUsage():String
	{
		var u:UsageInfo = usage();
		var ret:String = "";
		
		ret += "Usage: " + u.name + "\n";
		
		for (cmd in u.args)
		{
			if (cmd.type < 6)
			{
				ret += _traceSimple(cmd) + "\n";
			}
			else
			{
				ret += _traceList(cmd) + "\n";
			}
		}
		
		var lastNL:Int = ret.lastIndexOf("\n");
		if (lastNL > -1)
		{
			ret = ret.substr(0, lastNL);
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
		
		if (cmd.type == ArgType.TARG_STRING)
			return '$longName -> $description -> expects: $expects';
		else
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
		
		if (cmd.type == ArgType.TARG_LIST_STRING)
			return '$longName -> $description -> expects: $expects';
		else
			return '-$longName (-$shortName) -> $description -> expects: $expects';
	}
	
	private function setUpDefaultCallbacks():Void
	{
		switchNotFound = HandleSwitchNotFound;
		missingRequiredSwitch = HandleMissingSwitch;
		
		argNotFound = HandleArgNotFound;
		missingRequiredArg = HandleMissingArg;
		
		noArgsPassed = HandleNoArgsPassed;
	}
	
	public function HandleSwitchNotFound(Switch:String):Void
	{
		trace("Warning: argument '" + Switch + "' looks strange, ignoring");
	}
	
	public function HandleMissingSwitch(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			trace("Error: the switch -" + Cmd.keyword + " must be supplied");
		else
			trace("Error: the target " + Cmd.keyword + " must be supplied");
	}
	
	public function HandleArgNotFound(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			trace("Error: switch -" + Cmd.keyword + " must take an argument");
		else
			trace("Error: target " + Cmd.keyword + " must take an argument");
	}
	
	public function HandleMissingArg(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			trace("Error: the switch -" + Cmd.keyword + " must take a value");
		else
			trace("Error: the target " + Cmd.keyword + " must take a value");
	}
	
	public function HandleNoArgsPassed():Void
	{
		trace("Error: " + _progName + " requires at least one argument");
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
			if (!cmd.isHidden() && !cmd.isArg)
			{
				u.args.push(new ArgInfo(cmd));
			}
		}
		
		for (cmd in _cmdList)
		{
			if (!cmd.isHidden() && cmd.isArg)
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
	public function parse(argv:Array<String>):Void
	{
		var argc:Int = argv.length;
		var cmd:CmdElem;
		
		if (argv.length == 0 && _expectsAtLeastOne && noArgsPassed != null)
		{
			noArgsPassed();
			return;
		}
		if (argv.length == 0 && !_expectsAtLeastOne)
		{
			return;
		}
		
		var i:Int = 0;
		for (t in _targList)
		{
			if (Std.is(t, CmdTargStrList))
			{
				var tl:CmdTargStrList = cast t;
				
				while(true)
				{
					if (argv.length == 0)
						break;
					
					var arg:String = argv[0];
					
					if (arg.charAt(0) == "-")
					{
						if (!tl.isValOpt() && tl.list.length == 0)
						{
							if (argNotFound != null)
							{
								argNotFound(tl);
							}
						}
						
						break;
					}
					else
					{
						tl.setFound();
						tl.list.push(arg);
						tl.setValFound();
						
						argv.shift();
					}
				}
				
				tl.validate();
			}
			else
			{
				var val:String = argv[i];
				
				if (val.charAt(0) == "-")
				{
					if (t.isValOpt())
						continue;
					else
					{
						if (argNotFound != null)
						{
							argNotFound(t);
						}
					}
				}
				
				t.setFound();
				if (!t.getValue(i, argc, argv))
				{
					if (argNotFound != null && !t.isValOpt())
					{
						argNotFound(t);
					}
				}
				else
				{
					t.setValFound();
				}
				argv.shift();
			}
		}
		
		i = 0;
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
				
				cmdWord = "-" + cmd.keyword;
				cmdChar = "-" + cmd.optChar;
				
				if ((arg == cmdWord) || (arg == cmdChar))
				{
					cmd.setFound();
					
					if (cmd.isList)
					{
						var l:CmdArgTypeList<Dynamic> = cast cmd;
						
						var raw:Array<String> = [];
						
						while(true)
						{
							if (argv.length < i + 2)
								break;
							
							var arg:String = argv[i + 1];
							
							if (arg.charAt(0) == "-")
							{
								//if (!l.isValOpt() && l.list.length == 0)
								//{
									//if (argNotFound != null)
									//{
										//argNotFound(l);
									//}
								//}
								
								break;
							}
							else
							{
								raw.push(arg);
								l.setValFound();
								
								argv.splice(i + 1, 1);
							}
						}
						
						if (!l.getList(raw))
						{
							if (argNotFound != null && !l.isValOpt())
							{
								argNotFound(l);
							}
						}
					}
					else
					{
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