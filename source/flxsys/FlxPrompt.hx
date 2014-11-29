package flxsys;

/**
 * ...
 * @author ...
 */
class FlxPrompt
{
	static private var NAME_SYS_SEP:String = "@";
	static private var SYS_PATH_SEP:String = " ~ ";
	
	public var userName:String;
	public var prefix:String;
	public var sysName:String;
	
	public function new(UserName:String, Prefix:String = "$", SysName:String = "SYS")
	{
		userName = UserName;
		prefix = Prefix;
		sysName = SysName;
	}
	
	public function getPrompt(CurDir:String):String
	{
		if (CurDir.substr(0, 2) == "//")
			CurDir = CurDir.substr(1);
		
		return(userName + NAME_SYS_SEP + sysName + SYS_PATH_SEP + CurDir + Util.NEWLINE + prefix + " ");
	}
	
}