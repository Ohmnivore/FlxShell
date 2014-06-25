package flxsys;

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
	}
	
}