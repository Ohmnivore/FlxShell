package flxsys.frontends;

import flxsys.net.Bus;
import flxsys.net.DeviceInfo;
import flxsys.net.Msg;

/**
 * ...
 * @author Ohmnivore
 */
class BusFront
{
	static public function listDevices():Array<DeviceInfo>
	{
		return Bus.listDevices();
	}
	
	static public function getDeviceInfo(Address:Int):Null<DeviceInfo>
	{
		return Bus.getDeviceInfo(Address);
	}
	
	static public function sendMsg(M:Msg):Void
	{
		Bus.sendMsg(M);
	}
}