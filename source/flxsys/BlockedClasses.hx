package flxsys;

/**
 * ...
 * @author Ohmnivore
 */
class BlockedClasses
{
	private static var blocked:Array<String> = ["BlockedClasses"];
	
	public static function has(ClassName:String):Bool
	{
		for (cn in blocked)
		{
			//if (ClassName == cn)
			if (ClassName.indexOf(cn) > -1)
				return true;
		}
		
		return false;
	}
	
	public static function add(ClassName:String):Void
	{
		blocked.push(ClassName);
	}
	
	public static function clear():Void
	{
		blocked = ["BlockedClasses"];
	}
}