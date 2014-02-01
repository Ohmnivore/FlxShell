package flxsys;

/**
 * ...
 * @author Ohmnivore
 */
class Disk
{
	public var fs:Dynamic;
	
	public static inline var delimiter:String = "/";
	
	public static inline var root:String = "~";
	
	public function new(object:Dynamic) 
	{
		fs = object;
	}
	
	static public function findFromRelative(Path:String, Start:String = null, Drive:Disk):Dynamic
	{
		var result:Dynamic = "";
		
		if (Start == null)
		{
			result = findFromRoot(Path, Drive);
		}
		
		else
		{
			var paths:Array<String> = Path.split(delimiter);
			if (paths.length == 0) paths.push(Path);
			
			var p:Dynamic = findFromRoot(Start, Drive);
			
			for (path in paths)
			{
				p = Reflect.field(p, path);
			}
			
			result = p;
		}
		
		return result;
	}
	
	static public function findFromRoot(Path:String, Drive:Disk):Dynamic
	{
		var result:Dynamic = "";
		
		Path = Path.substr(1, Path.length - 1);
		if (Path.charAt(Path.length - 1) == delimiter)
			Path = Path.substring(0, Path.length - 1);
		var paths:Array<String> = Path.split(delimiter);
		if (paths.length == 0) paths.push(Path);
		
		var p = Drive.fs;
		
		for (path in paths)
		{
			p = Reflect.field(p, path);
		}
		
		result = p;
		
		return result;
	}
	
	static public function isAbsPath(Path:String):Bool
	{
		if (Path.charAt(0) == "/" || Path.charAt(0) == root)
			return true;
		else 
			return false;
	}
	
	static public function listChildren(Abspath:String, Drive:Disk):Array<String>
	{
		var point:Dynamic = Disk.findFromRoot(Abspath, Drive);
		
		return Reflect.fields(point);
	}
	
	static public function getParent(Abspath:String, Drive:Disk):Dynamic
	{
		var result:Dynamic = "";
		
		var p:Dynamic = Drive.fs;
		
		Abspath = Abspath.substr(1, Abspath.length - 1);
		if (Abspath.charAt(Abspath.length - 1) == delimiter)
			Abspath = Abspath.substring(0, Abspath.length - 1);
		var paths:Array<String> = Abspath.split(delimiter);
		if (paths.length > 0) paths.pop();
		
		for (path in paths)
		{
			p = Reflect.field(p, path);
		}
		
		result = p;
		
		return result;
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