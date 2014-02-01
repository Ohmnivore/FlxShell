Work in progress.

The plan is to simulate a Linux environment
using Haxe. I plan to use it for a HaxeFlixel
game where hacking will be part of the gameplay.

What really gives it power is an interpreted
version of Haxe, hscript.
https://code.google.com/p/hscript/

This is meant to be an abstraction, a simulation
even of a Linux environment as it will be used in
a game, with oftentimes a couple of systems open.
Thus many things will not be perfectly emulated,
but their spirit will subsist. For instance, there
will only be one networking protocol since real-world
constraints such as delay, packet loss, etc. won't
apply in the game world. Further abstractions include
the file system, and, well you get the idea.

Done:
JSONed file system (directories + files)
Shell
Shell history

TODO:
Shell tab completion
Command line args parsing (docopt style)
Add shell redirection/pipes (<, >, |)
Simulated network protocol
Threading/processes

Implement useful linux commands using
  interpreted Haxe:
ls
cd
man
cp
mv
mkdir
rmdir
touch
pwd
locate
ipconfig equivalent
chmod
grep
find
ssh equivalent
simple text editor (mostly for copy paste)
diff
shutdown
ftp equivalent
ps
top
kill
rm
cat
chown
passwd
uname equivalent
whereis
whatis
tail
less
su
wget equivalent