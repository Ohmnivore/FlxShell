package flxsys.net;

/**
 * ...
 * @author Ohmnivore
 */
class Bus
{
	static private var addrAssign:Int = 0;
	static private var devices:Map<Int, INetworked> = new Map<Int, INetworked>();
	
	static public function clearAll():Void
	{
		addrAssign = 0;
		devices = new Map<Int, INetworked>();
	}
	
	static public function connect(Device:INetworked, Name:String, Description:String):Int
	{
		addrAssign++;
		
		Device.info = new DeviceInfo(Name, Description, addrAssign);
		devices.set(Device.info.address, Device);
		
		return addrAssign;
	}
	
	static public function disconnect(Device:INetworked):Void
	{
		if (devices.exists(Device.info.address))
		{
			devices.remove(Device.info.address);
		}
	}
	
	static public function listDevices():Array<DeviceInfo>
	{
		var ret:Array<DeviceInfo> = [];
		
		for (d in devices.iterator())
		{
			ret.push(d.info);
		}
		
		return ret;
	}
	
	static public function getDeviceInfo(Address:Int):Null<DeviceInfo>
	{
		return devices.get(Address).info;
	}
	
	static public function sendMsg(M:Msg):Void
	{
		var dest:INetworked = devices.get(M.dest);
		
		if (dest != null)
		{
			dest.onReceive(M);
		}
	}
}