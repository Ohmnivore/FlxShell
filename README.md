# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and a very basic implementation of the Linux shell language.

[DEMO](http://ohmnivore.elementfx.com/FlxShell.swf) -> Out of date by a few commits

Try the 'help' command to get started.

The shell features |, >, >>, and < operators, but commands don't yet support it. Commands return objects, not strings, so redirection has huge potential.

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript

## Available commands:
* cd -> done
* cp -> done
* find -> done
* grep
* help -> done
* ls -> done
* mkdir -> done
* more
* mv -> done
* pwd -> done
* rename -> done
* rm -> done
* rmdir -> done
* touch -> done

## Keyboard shortcuts:
* Command history: up arrow/down arrow
* Enter command: enter
* Auto-complete file names: tab
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* First/last command in command history: page up / page down
* Skip to beginning/end of line: home/end

## TODO:
* Simulated file system (saves and loads from JSON) -> almost done
* Threading/multiple consoles open at the same time
* Permissions -> chmod and such
* Networking protocol between systems (static network handler)
* Wired communication protocol between systems
* Shell prompt for input
* Shell copy & paste support (especially paste)
