#!/usr/bin/env perl

use strict;
use warnings;


unless (-f '/tmp/eit.update') {
  
  system('touch /tmp/eit.update');
  
  my $this_pid   = $$;
  my $server_pid = `cat /tmp/eit.pid.*`;
  chomp $server_pid;
  
  chdir '/home/gamache/Code/EIT' or die $!;
  
  system('lynx -source http://nethack.devnull.net/tournament/scores.xlogfile > scores.xlogfile.2009');
   
  system("script/eit_fastcgi.pl -l /tmp/eit.socket.$this_pid -n 3 -p /tmp/eit.pid.$this_pid -d");
  
  system("ln -fs /tmp/eit.socket.$this_pid /tmp/eit.socket");
  
  system("kill $server_pid") if $server_pid;
  
  # clean up /tmp
  for (glob "/tmp/eit.socket.*") {
  	system("rm $_") unless /$this_pid$/;
  }
  
  system('rm /tmp/eit.update');
  
}
