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
	
	public function newFileAt(ParentString:String, Name:String):File
	{
		var f:File = new File("", Name);
		
		var parent:Folder = readFolder(ParentString);
		parent.addChild(f);
		
		return f;
	}
	
	public function newFile(Parent:Folder, Name:String):File
	{
		var f:File = new File("", Name);
		
		Parent.addChild(f);
		
		return f;
	}
	
	public function readFolder(P:String, Relative:String = null):Folder
	{
		var item:FileBase = readItem(P, Relative);
		
		if (!item.isDirectory)
		{
			throw(Error.UNEXPECTED_FILE);
		}
		
		return cast (item, Folder);
	}
	
	public function readFile(P:String, Relative:String = null):File
	{
		var item:FileBase = readItem(P, Relative);
		
		if (item.isDirectory)
		{
			throw(Error.UNEXPECTED_FOLDER);
		}
		
		return cast (item, File);
	}
	
	public function readItem(P:String, Relative:String = null):FileBase
	{
		var par:Folder = root;
		
		if (P == "/")
			return root;
		
		if (P.charAt(0) == "/")
		{
			par = root;
		}
		else
		{
			if (Relative != null)
			{
				P = Relative + "/" + P;
			}
			else
			{
				throw(Error.INCORRECT_PATH);
			}
		}
		
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
			
			if (i < paths.length - 1 && paths[i + 1] != "..")
			{
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
			}
			else
			{
				if (i == paths.length - 2)
					return par;
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
		root.path = "/";
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
		
		//for (x in ret.children.keys())
		//{
			//if (ret.children.get(x).name == null)
			//{
				//ret.children.remove(x);
			//}
		//}
		
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