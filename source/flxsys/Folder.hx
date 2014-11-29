package flxsys;

import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */

class Folder extends FileBase
{
	public var children:Map<String, FileBase>;
	
	public function new(Children:Array<FileBase>, Name:String, Execute:Bool = true, Read:Bool = true, Write:Bool = true) 
	{
		super(true, Name, Execute, Read, Write);
		
		children = new Map<String, FileBase>();
		
		for (c in Children)
		{
			c.path = path + "/" + c.name;
			c.parent = this;
			
			children.set(c.name, c);
		}
	}
	
	public function addChild(C:FileBase):Void
	{
		C.path = path + "/" + C.name;
		C.parent = this;
		
		children.set(C.name, C);
		
		if (C.path.substr(0, 2) == "//")
			C.path = C.path.substr(1);
	}
	
	override public function copy(NewPath:String, Shell:FlxShell, ?Source:Drive):Void
	{
		super.copy(NewPath, Shell);
		
		var par:String = NewPath;
		
		var folder:Folder;
		if (Source == null)
			folder = Shell.drive.readFolder(par, Shell.curDir.path);
		else
			folder = Source.readFolder(par, Shell.curDir.path);
		
		doCopy(this, folder, Shell, Source);
	}
	
	private function doCopy(OldFolder:Folder, NewPar:Folder, Shell:FlxShell, ?Source:Drive):Void
	{
		var newFolder:Folder = new Folder([], OldFolder.name,
			OldFolder.execute, OldFolder.read, OldFolder.write);
		NewPar.addChild(newFolder);
		
		for (c in OldFolder.children.iterator())
		{
			c.copy(newFolder.path + "/" + c.name, Shell, Source);
		}
	}
}