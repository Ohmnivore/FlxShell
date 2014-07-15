package flxsys.save;
import flxsys.Drive;
import flxsys.File;
import flxsys.FileBase;
import flxsys.Folder;
import haxe.Json;
import haxe.Serializer;

/**
 * ...
 * @author Ohmnivore
 */
class Stringer
{
	static private var toReplace:String;
	
	static public function saveDrive(D:Drive):Void
	{
		trace(stringify(D.root));
	}
	
	static public function stringify(F:Folder, ToReplace:String = null):String
	{
		toReplace = ToReplace;
		
		return Json.stringify(getFolder(F));
	}
	
	static private function getItem(Item:FileBase):Base
	{
		if (Item.isDirectory)
		{
			return getFolder(cast Item);
		}
		
		return getFile(cast Item);
	}
	
	static private function getFolder(F:Folder):SFolder
	{
		var ret:SFolder = new SFolder();
		
		ret.execute = F.execute;
		ret.read = F.read;
		ret.write = F.write;
		ret.name = F.name;
		ret.path = F.path;
		if (toReplace != null)
			ret.path = StringTools.replace(ret.path, toReplace, "");
		
		for (c in F.children.iterator())
		{
			ret.children.push(getItem(c));
		}
		
		return ret;
	}
	
	static private function getFile(F:File):SFile
	{
		var ret:SFile = new SFile();
		
		ret.execute = F.execute;
		ret.read = F.read;
		ret.write = F.write;
		ret.name = F.name;
		ret.path = F.path;
		if (toReplace != null)
			ret.path = StringTools.replace(ret.path, toReplace, "");
		
		ret.content = F.content;
		
		return ret;
	}
}

class Base
{
	public var execute:Bool;
	public var read:Bool;
	public var write:Bool;
	
	public var name:String;
	public var path:String;
	
	public function new()
	{
		
	}
}

class SFile extends Base
{
	public var content:String;
	
	public function new()
	{
		super();
	}
}

class SFolder extends Base
{
	public var children:Array<Base>;
	
	public function new()
	{
		super();
		
		children = [];
	}
}