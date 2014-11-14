package flxsys;

import hxclap.CmdLine;
import hxclap.CmdElem;
import hxclap.CmdArg;
import hxclap.UsageInfo;
import hxclap.E_CmdArgSyntax;

/**
 * ...
 * @author Ohmnivore
 */

class FlxCmdLine extends CmdLine
{
	static public var OK:String = "ok";
	
	public var addHelp:String = null;
	
	private var status:String;
	
	public function new(progName:String, cmds:Array<CmdElem>, ignoreRequired:Bool = false) 
	{
		if (ignoreRequired)
		{
			for (c in cmds)
			{
				c.syntaxFlags = c.syntaxFlags & ~E_CmdArgSyntax.isREQ;
				c.syntaxFlags |= E_CmdArgSyntax.isOPT;
			}
		}
		
		super(progName, cmds);
	}
	
	public function getUsageString():String
	{
		var u:UsageInfo = usage();
		var ret:String = "";
		
		ret += "Usage: " + u.name + "\n";
		if (addHelp != null)
		{
			ret += addHelp + "\n";
		}
		
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
	
	public function getParseReturn(Args:Array<String>):String
	{
		status = OK;
		
		parse(Args);
		
		return status;
	}
	
	override public function parse(argv:Array<String>):Void 
	{
		if (argv != null)
		{
			if (argv.length > 0)
			{
				if (argv[0] == "-h" || argv[0] == "-help")
				{
					status = getUsageString();
					return;
				}
			}
		}
		
		super.parse(argv);
	}
	
	override public function HandleArgNotFound(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			status = "Error: switch -" + Cmd.keyword + " must take an argument";
		else
			status = "Error: target " + Cmd.keyword + " must take an argument";
	}
	
	override public function HandleMissingArg(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			status = "Error: the switch -" + Cmd.keyword + " must take a value";
		else
			status = "Error: the target " + Cmd.keyword + " must take a value";
	}
	
	override public function HandleMissingSwitch(Cmd:CmdElem):Void
	{
		if (Cmd.isArg)
			status = "Error: the switch -" + Cmd.keyword + " must be supplied";
		else
			status = "Error: the target " + Cmd.keyword + " must be supplied";
	}
	
	override public function HandleSwitchNotFound(Switch:String):Void
	{
		status = "Warning: argument '" + Switch + "' looks strange, ignoring";
	}
	
	override public function HandleNoArgsPassed():Void
	{
		status = getUsageString();
	}
}