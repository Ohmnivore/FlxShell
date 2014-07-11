package hxclap;

class E_CmdArgSyntax
{
	public static var isOPT:Int       = 0x01;  // argument is optional
	public static var isREQ:Int       = 0x02;  // argument is required
	public static var isVALOPT:Int    = 0x04;  // argument value is optional
	public static var isVALREQ:Int    = 0x08;  // argument value is required
	public static var isHIDDEN:Int    = 0x10;  // argument is not to be printed in usage   
	public static inline var isDefault:Int   = 10;  // argument is not to be printed in usage   
}