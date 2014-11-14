package hxclap;

/**
 * ...
 * @author Ohmnivore
 */

class CmdTargTypeList<T> extends CmdTarget
{
	public var list:Array<T>;
	public var index:Int;
	public var delimiters:String;
	public var max:Int;
	public var min:Int;
	
	public function new(keyWord:String, valueName:String, description:String,
		syntaxFlags:Int = (E_CmdArgSyntax.isREQ | E_CmdArgSyntax.isVALREQ),
		minSize:Int = 1,
		maxSize:Int = 100,
		delim:String = ",-~/.")
	{
		super(keyWord, valueName, description, syntaxFlags);
		
		delimiters = delim;
		min = minSize;
		max = maxSize;
		list = [];
		
		var buf:String = "";
		buf = valueName;
		if (buf.length == 0)
			buf += " ";
		buf += " ..." + " " + valueName + ' (Min: $min Max: $max)';
		valueName = buf;
		
		buf = "";
		buf += '$description';
		description = buf;
		
		var i:Int = 0;
		while (i < delim.length)
		{
			if (delim.charAt(i) == ' ')
			{
				parseError(ArgError.SPACE_DELIMITER, this, ArgType.ARG_LIST_STRING, "");
			}
			
			i++;
		}
	}
	
	override public function getValue(i:Int, argc:Int, argv:Array<String>):Bool
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