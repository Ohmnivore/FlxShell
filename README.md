# There are probably features I can add, but otherwise this is complete
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
# Commands marked with "|" support the | operator as input
# Commands marked with "<" support the < operator as input
# All commands can output to a file with the ">" operator
* backup -> done
* cat -> done |<
* cd -> done |<
* clip -> done |<
* cp -> done
* echo -> done |<
* edit (minimalistic text editor) -> done |<
* find
* grep
* help -> done
* ls -> done |<
* mkdir -> done
* mv -> done
* netstat -> done
* pwd -> done
* rename -> done
* rm -> done
* rmdir -> done
* send -> done |<
* touch -> done

## Keyboard shortcuts for shell:
* Command history: up arrow/down arrow
* Enter command: enter
* Auto-complete file names: tab
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* First/last command in command history: page up / page down
* Skip to beginning/end of line: home/end
* Copy on-screen text: ctrl + 1
* Save drive: F1
* Toggle shell: escape

## Keyboard shortcuts for text editor:
* Save: ctrl + s
* Quit: ctrl + d
* Move cursor one word: ctrl + left arrow / ctrl + right arrow
* Move cursor to end or beginning of file: ctrl + down arrow / ctrl + up arrow
* Move cursor to end or beginning of line: ctrl + end / ctrl + home
* Auto-scroll down / up: page down / page up
* Toggle editor: escape
* This is a regular AS3 input TextField so most editing tricks on your OS should work, the ones I listed are just the ones I found, there's most likely more.

## Saving
* Export your drive as a JSON file with "backup -s"
* Load a JSON file into your drive with "backup -l"

Now this is where it gets complicated. In debug mode, FlxShell will initially load the "assets/data/FlxOS.txt" file.
In release mode, it loads your last saved drive. To save your drive, hit F1 while in the shell.
This save/load mechanism is not the same as the above export/load mechanism.
It's not the best idea to leave saving entirely up to the user, so in your implementation call FlxShell object.save() when appropriate.

## TODO:
* Startup script

### Shell examples:
* cd bin
* cd ..
* ls
* help -b
* help -bin
* edit -s /bin/ls
* edit -s bin/ls
* bin/ls < edit
* pwd
* pwd > test
* pwd >> test
* pwd | echo
* pwd | echo | echo | echo | echo | echo | echo
* 'I think you get the idea' | echo
* 'Oh watch this' >> testfile

### Script examples:
Take a look at the scripts in the bin folder:
* cd bin -> navigate to the bin directory which contains all the commands
* ls -> list all available commands
* bin/command name < edit -> open the command source code in the editor (notice how I use bin/command name, otherwise the shell would execute the command instead of opening the file)
