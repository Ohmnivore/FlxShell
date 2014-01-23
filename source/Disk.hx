package ;

/**
 * ...
 * @author Ohmnivore
 */
class Disk
{
	public var fs:Dynamic;
	
	public var delimiter:String = "/";
	
	public static inline var root:String = "~";
	
	public function new(object:Dynamic) 
	{
		fs = object;
	}
	
	public function getFromPath(Path:String, Start:String = root):Dynamic
	{
		var paths:Array<String> = Path.split(delimiter);
		
		var p = fs;
		//var found = fs;
		
		if (Start == root)
		{
			for (path in paths)
			{
				p = Reflect.field(p, path);
			}
		}
		
		return p;
	}
	
	public function isFile(Fileorfolder:Dynamic):Bool
	{
		if (Std.is(Fileorfolder, String))
		{
			return true;
		}
		
		else return false;
	}
}