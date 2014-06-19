# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and an implementation of the Linux shell language.

For now, I've implemented the basic editing functionalities (writing, erasing with backspace, left/right arrow keys, command history with up/down keys, enter key to parse).
I also wrote a command line argument parser (HxCLAP). There's still tons of work to do.

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript
* hxparse

## TODO:
* Shell language implementation with hxparse
* Interpreted Haxe language with hscript
* Simulated file system (saves and loads from JSON)
* Threading/multiple console open at the same time
* Process layer -> kill/start processes
* Permissions -> chmod and such
* Networking protocol between systems (static network handler)
* Port some essential Linux commands to interpreted Haxe (ex: ls, cd, touch, makedir, etc)