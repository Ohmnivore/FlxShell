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
	
	override public function copy(NewPath:String, Shell:FlxShell):Void 
	{
		super.copy(NewPath, Shell);
		
		var newName:String = Path.withoutDirectory(NewPath);
		var par:String = Path.directory(NewPath);
		
		var folder:Folder = Shell.drive.readFolder(par, Shell.curDir.path);
		
		var newFile:File = new File(content, newName, execute, read, write);
		folder.addChild(newFile);
	}
}