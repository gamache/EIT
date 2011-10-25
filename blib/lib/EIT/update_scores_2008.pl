#!/usr/bin/env perl

use strict;
use warnings;


unless (-f '/tmp/eit2008.update') {
  
  system('touch /tmp/eit2008.update');
  
  my $this_pid   = $$;
  my $server_pid = `cat /tmp/eit2008.pid.*`;
  chomp $server_pid;
  
  chdir '/home/gamache/Code/EIT2008' or die $!;
  
  #system('lynx -source http://nethack.devnull.net/tournament/scores.xlogfile > scores.xlogfile.2008');
   
  system("script/eit_fastcgi.pl -l /tmp/eit2008.socket.$this_pid -n 3 -p /tmp/eit2008.pid.$this_pid -d");
  
  system("ln -fs /tmp/eit2008.socket.$this_pid /tmp/eit2008.socket");
  
  system("kill $server_pid") if $server_pid;
  
  # clean up /tmp
  for (glob "/tmp/eit2008.socket.*") {
  	system("rm $_") unless /$this_pid$/;
  }
  
  system('rm /tmp/eit2008.update');
  
}
