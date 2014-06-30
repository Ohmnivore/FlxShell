package flxsys;

import hxclap.CmdLine;
import hxclap.CmdArg;
import hxclap.UsageInfo;
import hxclap.E_CmdArgSyntax;

/**
 * ...
 * @author Ohmnivore
 */

class FlxCmdLine extends CmdLine
{
	static public inline var OK:String = "ok";
	private var status:String;
	
	public function new(progName:String, cmds:Array<CmdArg>, ignoreRequired:Bool = false) 
	{
		if (ignoreRequired)
		{
			for (c in cmds)
			{
				c._syntaxFlags = c._syntaxFlags & ~E_CmdArgSyntax.isREQ;
				c._syntaxFlags |= E_CmdArgSyntax.isOPT;
			}
		}
		
		super(progName, cmds);
	}
	
	public function getParseReturn(Args:Array<String>):String
	{
		status = OK;
		
		parse(Args.length, Args);
		
		return status;
	}
	
	override public function parse(argc:Int, argv:Array<String>):Void 
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
		
		super.parse(argc, argv);
	}
	
	override public function HandleArgNotFound(Cmd:CmdArg):Void 
	{
		status = "Error: switch -" + Cmd.getKeyword() + " must take an argument";
	}
	
	override public function HandleMissingArg(Cmd:CmdArg):Void 
	{
		status = "Error: the switch -" + Cmd.getKeyword() + " must take a value";
	}
	
	override public function HandleMissingSwitch(Cmd:CmdArg):Void 
	{
		status = "Error: the switch -" + Cmd.getKeyword() + " must be supplied";
	}
	
	override public function HandleSwitchNotFound(Switch:String):Void 
	{
		status = "Error: argument '" + Switch + "' looks strange";
	}
}