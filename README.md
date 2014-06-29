# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and an implementation of the Linux shell language.

For now, I've implemented the basic editing functionalities (writing, erasing with backspace, left/right arrow keys, command history with up/down keys, enter key to parse, tab, ctrl-left, ctrl-right, page up, page down, home, end), a part of the file system and a few linux commands. Also I'm done making the shell language parser and hscript integration.
I also wrote a command line argument parser (HxCLAP). There's still tons of work to do.

[DEMO](http://ohmnivore.elementfx.com/wp-content/uploads/2014/06/FlxShell2.swf) -> Out of date

Try ls and cd, no other commands are available at the moment.

The shell features |, >, >>, and < operators, but commands don't yet support it. Commands return objects, not strings, so redirection has huge potential.

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript

## Available commands:
* cd -> done
* cp -> done
* find
* grep
* help -> done
* ls -> done
* mkdir
* more
* mv
* pwd -> done
* rm
* rmdir
* touch -> done

## TODO:
* Simulated file system (saves and loads from JSON) -> almost done
* Threading/multiple consoles open at the same time
* Process layer -> kill/start processes
* Permissions -> chmod and such
* Networking protocol between systems (static network handler)
* Rethink shell print for arrays
