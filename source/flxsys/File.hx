package flxsys;

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
	
}