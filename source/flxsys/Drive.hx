package flxsys;
import haxe.Json;

/**
 * ...
 * @author Ohmnivore
 */
class Drive
{
	public var root:Folder;
	
	public function new() 
	{
		
	}
	
	public function readFolder(P:String):Folder
	{
		var item:FileBase = readItem(P);
		
		if (!item.isDirectory)
		{
			throw(Error.UNEXPECTED_FILE);
		}
		
		return cast (item, Folder);
	}
	
	public function readFile(P:String):File
	{
		var item:FileBase = readItem(P);
		
		if (item.isDirectory)
		{
			throw(Error.UNEXPECTED_FOLDER);
		}
		
		return cast (item, File);
	}
	
	public function readItem(P:String):FileBase
	{
		var par:Folder = root;
		
		var paths:Array<String> = P.split("/");
		
		for (p in paths)
		{
			if (p.length < 1)
			{
				paths.remove(p);
			}
		}
		
		if (paths.length < 1)
		{
			throw(Error.INCORRECT_PATH);
		}
		
		var i:Int = 0;
		while (i < paths.length - 1)
		{
			var subpath:String = paths[i];
			
			if (par.children.exists(subpath))
			{
				var item:FileBase = par.children.get(subpath);
				
				if (item.isDirectory)
				{
					par = cast item;
				}
				else
				{
					throw(Error.INCORRECT_PATH);
				}
			}
			
			i++;
		}
		
		var name:String = paths.pop();
		
		if (!par.children.exists(name))
		{
			throw(Error.INCORRECT_PATH);
		}
		
		return par.children.get(name);
	}
	
	//Loading functions
	public function loadJSON(S:String):Void
	{
		var all:Dynamic = Json.parse(S);
		
		root = getFolder(all, null);
	}
	
	static private function getItem(Item:Dynamic, Parent:Folder):FileBase
	{
		if (!Reflect.hasField(Item, "content"))
		{
			return getFolder(Item, Parent);
		}
		
		return getFile(Item, Parent);
	}
	
	static private function getFolder(F:Dynamic, Parent:Folder):Folder
	{
		var ret:Folder = new Folder([], "");
		
		ret.execute = Reflect.field(F, "execute");
		ret.read = Reflect.field(F, "read");
		ret.write = Reflect.field(F, "write");
		ret.name = Reflect.field(F, "name");
		ret.path = Reflect.field(F, "path");
		
		for (c in cast (Reflect.field(F, "children"), Array<Dynamic>).iterator())
		{
			var item:FileBase = getItem(c, ret);
			ret.children.set(item.name, item);
		}
		
		if (Parent != null)
		{
			Parent.addChild(ret);
		}
		
		return ret;
	}
	
	static private function getFile(F:Dynamic, Parent:Folder):File
	{
		var ret:File = new File("", "");
		
		ret.execute = Reflect.field(F, "execute");
		ret.read = Reflect.field(F, "read");
		ret.write = Reflect.field(F, "write");
		ret.name = Reflect.field(F, "name");
		ret.path = Reflect.field(F, "path");
		
		ret.content = Reflect.field(F, "content");
		
		if (Parent != null)
		{
			Parent.addChild(ret);
		}
		
		return ret;
	}
}