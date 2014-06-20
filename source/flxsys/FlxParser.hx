package flxsys;

/**
 * ...
 * @author ...
 */
class FlxParser
{
	public var shell:FlxShell;
	private var _history:Array<String>;
	private var _hist_index:Int = 0;
	
	public function new(Shell:FlxShell) 
	{
		shell = Shell;
		
		_history = [""];
	}
	
	public function getHistPrevious():String
	{
		_hist_index--;
		if (_hist_index < 0)
			_hist_index = 0;
		
		return _history[_hist_index];
	}
	
	public function getHistNext():String
	{
		_hist_index++;
		if (_hist_index >= _history.length)
			_hist_index = _history.length - 1;
		
		return _history[_hist_index];
	}

	public function parseStringInput(Input:String):Void
	{
		_history.push(Input);
		_hist_index = _history.length;
		shell.print("shell: " + Input.split(" ")[0] + " not found", true);
		shell.printPrompt();
	}
}