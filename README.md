# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and a very basic implementation of the Linux shell language.

[DEMO](http://ohmnivore.elementfx.com/FlxShell.swf) -> Out of date by a lot of commits

Try the 'help' command to get started.

The shell features |, >, >>, and < operators, but not all commands support it yet. Commands return objects, not strings, so redirection has huge potential.
Also the shell allows you to use strings (ex: 'this is a string'). They can be used with <, >, and | operators, but not yet as command arguments.

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript

## Available commands (Not all commands support redirection operators yet, even if they are marked as done):
* cat -> done
* cd -> done
* clip -> done
* cp -> done
* echo -> done
* edit (minimalistic text editor) -> done
* find -> done
* grep
* help -> done
* ls -> done
* mkdir -> done
* mv -> done
* pwd -> done
* rename -> done
* rm -> done
* rmdir -> done
* send
* touch -> done

## Keyboard shortcuts:
* Command history: up arrow/down arrow
* Enter command: enter
* Auto-complete file names: tab
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* First/last command in command history: page up / page down
* Skip to beginning/end of line: home/end
* Copy on-screen text: ctrl + 1

## TODO:
* Simulated file system (saves and loads from JSON) -> almost done
* Wired communication protocol between systems
* Fix weird newline bug (happens when you hit enter)
