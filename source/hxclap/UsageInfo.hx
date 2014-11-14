package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class UsageInfo
{
	/**
	 * Program's name as passed when the CmdLine object was constructed
	 */
	public var name:String;
	/**
	 * List of all CmdArgs added to the CmdLine object that don't have the HIDDEN flag set to true
	 */
	public var args:Array<ArgInfo>;
	
	public function new(Name:String)
	{
		name = Name;
		args = [];
	}
}