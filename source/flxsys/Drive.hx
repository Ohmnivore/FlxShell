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
		if (P == "/")
			return root;
		
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
	
	private function replaceDot(S:String):String
	{
		if (S.substr(0, 2) == "./")
			S = S.substr(2);
		S = StringTools.replace(S, "/./", "/");
		
		return S;
	}
	
	public function readItem(P:String, Relative:String = null):FileBase
	{
		var par:Folder = root;
		
		P = replaceDot(P);
		if (Relative != null)
			Relative = replaceDot(Relative);
		
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
			
			if (i < paths.length && subpath != "..")
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
				par = par.parent;
				if (i == paths.length - 1)
					return par;
				//par = par.parent;
			}
			
			i++;
		}
		
		var name:String = paths.pop();
		if (name == "..")
		{
			if (par.parent == null)
				throw(Error.INCORRECT_PATH);
			else
				return par.parent;
		}
		if (name == ".")
		{
			if (par == null)
				throw(Error.INCORRECT_PATH);
			else
				return par;
		}
		if (!par.children.exists(name))
		{
			throw(Error.INCORRECT_PATH);
		}
		
		return par.children.get(name);
	}
	
	//Loading functions
	public function loadJSON(S:String, Sub:String = null, AddTo:Folder = null, Merge:Bool = true):Void
	{
		var all:Dynamic = Json.parse(S);
		
		if (Sub == null)
		{
			root = getFolder(all, null);
			root.path = "/";
		}
		else
		{
			var subJSON:Dynamic = null;
			var tocheck:Array<Dynamic> = all.children;
			var i:Int = 0;
			while (i < tocheck.length)
			{
				if (tocheck[i].name == Sub)
				{
					subJSON = tocheck[i];
					break;
				}
			}
			if (subJSON == null)
				return;
			var subDir:Folder = getFolder(subJSON, null);
			
			if (Merge)
			{
				for (c in subDir.children.keys())
				{
					var realSubDir:Folder = cast AddTo.children.get(Sub);
					realSubDir.addChild(subDir.children.get(c));
				}
			}
			else
			{
				AddTo.addChild(subDir);
				
			}
		}
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
		if (ret.path.substr(0, 1) == "//")
			ret.path = ret.path.substr(1);
		
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
		if (ret.path.substr(0, 1) == "//")
			ret.path = ret.path.substr(1);
		
		ret.content = Reflect.field(F, "content");
		
		if (Parent != null)
		{
			Parent.addChild(ret);
		}
		
		return ret;
	}
}