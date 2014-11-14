package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class CmdArgTypeList<T> extends CmdArg
{
	public var list:Array<T>;
	public var index:Int;
	public var max:Int;
	public var min:Int;
	
	public function new(optChar:String, keyword:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ),
		minSize:Int = 1,
		maxSize:Int = 100)
	{
		super(optChar, keyword, valueName, description, syntaxFlags);
		
		min = minSize;
		max = maxSize;
		list = [];
		isList = true;
		
		var buf:String = "";
		buf = valueName;
		if (buf.length == 0)
			buf += " ";
		buf += " " + " ..." + " " + " " + valueName + ' (Min: $min Max: $max)';
		valueName = buf;
		
		buf = "";
		buf += '$description';
		description = buf;
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
	{
		return true;
	}
	
	override public function getList(argv:Array<String>):Bool 
	{
		return true;
	}
	
	public function getItem(Index:Int):T
	{
		Index = Index % list.length;
		while (index != Index)
		{
			if (index < Index)
			{
				index++;
			}
			else
			{
				index++;
			}
		}
		
		return list[index];
	}
	
	public function reset():Void
	{
		index = 0;
	}
	
	public function size():Int
	{
		return list.length;
	}
	
	public function insert(Item:T):Void
	{
		if (list.length < max)
		{
			list.push(Item);
		}
	}
	
	public function validate():Bool
	{
		if (list.length < min)
		{
			parseError(ArgError.TOO_FEW_ARGS, this, ArgType.ARG_LIST_INT, "");
			return false;
		}
		
		if (list.length > max)
		{
			parseError(ArgError.TOO_MANY_ARGS, this, ArgType.ARG_LIST_INT, "");
			return false;
		}
		
		reset();
		setParseOK();
		return true;
	}
}