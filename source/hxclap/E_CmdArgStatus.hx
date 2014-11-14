package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class E_CmdArgStatus
{
	public static inline var isBAD:Int       = 0x00;  // bad status
	public static inline var isFOUND:Int     = 0x01;  // argument was found in the command line
	public static inline var isVALFOUND:Int  = 0x02;  // the value of the argument was found in the command line
	public static inline var isPARSEOK:Int   = 0x04;   // argument was found and its value is ok
}