# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and an implementation of the Linux shell language.

For now, I've implemented the basic editing functionalities (writing, erasing with backspace, left/right arrow keys, command history with up/down keys, enter key to parse, tab, ctrl-left, ctrl-right, page up, page down, home, end), a part of the file system and a few linux commands. Also I'm done making the shell language parser and hscript integration.
I also wrote a command line argument parser (HxCLAP). There's still tons of work to do.

[DEMO](http://ohmnivore.elementfx.com/wp-content/uploads/2014/06/FlxShell2.swf)

Try ls and cd, no other commands are available at the moment.

In the shell you can use >, >>, <, and | redirection operators. Interpreted haxe should be used for more complex needs (I'll make a tutorial later).

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript

## TODO:
* Simulated file system (saves and loads from JSON) -> almost done
* Threading/multiple consoles open at the same time
* Process layer -> kill/start processes
* Permissions -> chmod and such
* Networking protocol between systems (static network handler)
* Port some more Linux commands to interpreted Haxe (ex: touch, makedir, etc)
