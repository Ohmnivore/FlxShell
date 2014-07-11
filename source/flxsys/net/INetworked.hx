package flxsys.net;

/**
 * ...
 * @author Ohmnivore
 */
interface INetworked
{
	public var info:DeviceInfo;
	public function onReceive(M:Msg):Void;
}