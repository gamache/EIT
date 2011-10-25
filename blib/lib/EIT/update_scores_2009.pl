#!/usr/bin/env perl

use strict;
use warnings;


unless (-f '/tmp/eit2009.update') {
  
  system('touch /tmp/eit2009.update');
  
  my $this_pid   = $$;
  my $server_pid = `cat /tmp/eit2009.pid.*`;
  chomp $server_pid;
  
  chdir '/home/gamache/Code/EIT2009' or die $!;
  
  #system('lynx -source http://nethack.devnull.net/tournament/scores.xlogfile > scores.xlogfile.2009');
   
  system("script/eit_fastcgi.pl -l /tmp/eit2009.socket.$this_pid -n 3 -p /tmp/eit2009.pid.$this_pid -d");
  
  system("ln -fs /tmp/eit2009.socket.$this_pid /tmp/eit2009.socket");
  
  system("kill $server_pid") if $server_pid;
  
  # clean up /tmp
  for (glob "/tmp/eit2009.socket.*") {
  	system("rm $_") unless /$this_pid$/;
  }
  
  system('rm /tmp/eit2009.update');
  
}
