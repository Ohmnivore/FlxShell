package flxsys;

/**
 * ...
 * @author Ohmnivore
 */

class FileBase
{
	//Permissions for non-root users
	public var execute:Bool;
	public var read:Bool;
	public var write:Bool;
	
	public var name:String;
	public var path:String;
	public var extension:String;
	public var basename:String;
	
	public var isDirectory:Bool;
	public var parent:Folder;
	
	public function new(IsDirectory:Bool, Name:String, Execute:Bool = true, Read:Bool = true, Write:Bool = true)
	{
		execute = Execute;
		read = Read;
		write = Write;
		
		isDirectory = IsDirectory;
		name = Name;
		
		//Parsing file extension and base name
		var dot_ind:Int = name.lastIndexOf(".");
		if (dot_ind < 0)
		{
			extension = "";
			basename = name;
		}
		else
		{
			extension = name.substring(dot_ind + 1, name.length);
			basename = name.substr(0, dot_ind - 1);
		}
	}
	
	public function delete():Void
	{
		if (parent != null)
		{
			parent.children.remove(name);
		}
	}
	
	public function rename(Name:String):Void
	{
		if (parent != null)
			parent.children.remove(name);
		
		name = Name;
		
		if (parent != null)
			parent.children.set(name, this);
		
		if (parent != null)
		{
			path = parent.path + "/" + name;
		}
		
		else
		{
			path = "/" + name;
		}
	}
}