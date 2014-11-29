package flxsys;
import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class Util
{
	static public var NEWLINE:String = "\n";
	
	static public function CLRFtoLF(S:String):String
	{
		var reg = new EReg("\r\n", "g");
		var ret:String = "";
		
		var a:Array<String> = reg.split(S);
		FlxG.log.add(a);
		
		var i:Int = 0;
		while (i < a.length)
		{
			ret += a[i];
			
			if (i < a.length - 1)
			{
				ret += "\n";
			}
			
			i++;
		}
		
		return ret;
	}
}