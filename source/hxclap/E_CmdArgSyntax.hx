package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class E_CmdArgSyntax
{
	public static inline var isOPT:Int       = 0x01;  // argument is optional
	public static inline var isREQ:Int       = 0x02;  // argument is required
	public static inline var isVALOPT:Int    = 0x04;  // argument value is optional
	public static inline var isVALREQ:Int    = 0x08;  // argument value is required
	public static inline var isHIDDEN:Int    = 0x10;  // argument is not to be printed in usage    
}