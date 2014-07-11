package flxsys.net;

/**
 * ...
 * @author Ohmnivore
 */
class Msg
{
	public var source:Int;
	public var dest:Int;
	public var content:String;
	
	public function new(Source:Int, Dest:Int, Content:String) 
	{
		source = Source;
		dest = Dest;
		content = Content;
	}
}