package flxsys.net;

/**
 * ...
 * @author Ohmnivore
 */
class DeviceInfo
{
	public var name:String;
	public var description:String;
	public var address:Int;
	
	public function new(Name:String, Description:String, Address:Int) 
	{
		name = Name;
		description = Description;
		address = Address;
	}
}