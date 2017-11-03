#!/usr/bin/env perl

use strict;
use warnings;


unless (-f '/tmp/eit2017.update') {
  
  system('touch /tmp/eit2017.update');
  
  my $this_pid   = $$;
  my $server_pid = `cat /tmp/eit2017.pid.*`;
  chomp $server_pid;
  
  chdir '/home/gamache/sites/EIT2017' or die $!;
  
  system('curl https://www.hardfought.org/devnull/xlogfiles/xlogfile.dnt > scores.xlogfile.2017');
   
  system("script/eit_fastcgi.pl -l /tmp/eit2017.socket.$this_pid -n 3 -p /tmp/eit2017.pid.$this_pid -d");
  
  system("ln -fs /tmp/eit2017.socket.$this_pid /tmp/eit2017.socket");
  
  system("kill $server_pid") if $server_pid;
  
  # clean up /tmp
  for (glob "/tmp/eit2017.socket.*") {
  	system("rm $_") unless /$this_pid$/;
  }
  
  system('rm /tmp/eit2017.update');
  
}
