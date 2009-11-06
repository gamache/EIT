#!/bin/sh
cd /home/gamache/Code/EIT
lynx -source http://nethack.devnull.net/tournament/scores.xlogfile > scores.xlogfile.2009
kill `cat /tmp/eit.pid`
script/eit_fastcgi.pl -l /tmp/eit.socket -n 3 -p /tmp/eit.pid -d
