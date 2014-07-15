package flxsys;

import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */

class File extends FileBase
{
	public var content:String;
	
	public function new(Content:String, Name:String, Execute:Bool = true, Read:Bool = true, Write:Bool = true) 
	{
		super(false, Name, Execute, Read, Write);
		
		content = Content;
	}
	
	override public function copy(NewPath:String, Shell:FlxShell, ?Source:Drive):Void 
	{
		super.copy(NewPath, Shell);
		
		var newName:String = Path.withoutDirectory(NewPath);
		var par:String = Path.directory(NewPath);
		
		var folder:Folder;
		if (Source == null)
			folder = Shell.drive.readFolder(par, Shell.curDir.path);
		else
			folder = Source.readFolder(par, Shell.curDir.path);
		
		var newFile:File = new File(content, newName, execute, read, write);
		folder.addChild(newFile);
	}
}