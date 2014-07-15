# Work in progress
I'm planning to make a game that will allow players to interact with consoles/shells/command lines/whatever you wanna call them.
So FlxShell is like a simulated Linux-like mini-OS where the sole interface is a shell and where the two scripting languages are an interpreted version of Haxe and a very basic implementation of the Linux shell language.

[DEMO](https://rawgit.com/Ohmnivore/FlxShell/master/export/flash/bin/FlxShell.swf)

Try the 'help' command to get started.

The shell features |, >, >>, and < operators, but not all commands support it yet. Commands return objects, not strings, so redirection has huge potential.
Also the shell allows you to use strings (ex: 'this is a string'). They can be used with <, >, and | operators, but not yet as command arguments.

## Powered by:
* HaxeFlixel
* HxCLAP
* hscript

## Available commands (Not all commands support redirection operators yet, even if they are marked as done):
* backup -> done
* cat -> done
* cd -> done
* clip -> done
* cp -> done
* echo -> done
* edit (minimalistic text editor) -> done
* find
* grep
* help -> done
* ls -> done
* mkdir -> done
* mv -> done
* netstat -> done
* pwd -> done
* rename -> done
* rm -> done
* rmdir -> done
* send -> done
* touch -> done

## Keyboard shortcuts for shell:
* Command history: up arrow/down arrow
* Enter command: enter
* Auto-complete file names: tab
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* First/last command in command history: page up / page down
* Skip to beginning/end of line: home/end
* Copy on-screen text: ctrl + 1

## Keyboard shortcuts for text editor:
* Save: ctrl + s
* Quit: ctrl + d
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* Move cursor to end or beginning of file: ctrl + down arrow / ctrl + up arrow
* Move cursor to end or beginning of line: ctrl + end / ctrl + home
* Auto-scroll down / up: page down / page up
This is a regular AS3 input TextField so most editing tricks on your OS should work, the ones I listed are just the ones I found, there's most likely more.

## TODO:
* Save/load silently from flixel save
* Make every command work with redirection operators
