#!/usr/bin/env perl
use strict;
use warnings;

use HTML::TreeBuilder;

my $CLANURL = 
	'http://nethack.devnull.net/cgi-bin/tournament/claninfo.pl?mode=show&clan=';
my $CLANFILE = 'clan-info.tsv';
my $DEBUG = 1;


my %clans;

for my $clan_id (1..150) {
	debug("Getting info for clan ID $clan_id...");
	my $url = $CLANURL . $clan_id;

	my $tree = HTML::TreeBuilder->new_from_content(`lynx -source '$url'`);
	
	## find the beginning of the Clan Info table
	my $claninfo_th = $tree->look_down(
		_tag => 'th',
		align => 'left',
		colspan => '4',
		bgcolor => '#3f3f3f',
	);
	next unless $claninfo_th;
	die unless $claninfo_th->as_text =~ /Clan Info for \S+/;
	debug('  ', trim($claninfo_th->as_text));

	## find clan name
	my $clanname_th = ($claninfo_th->parent->right->descendants)[0]->right;
	my $clanname = trim($clanname_th->as_text);
	debug('  Clan name is ', $clanname);

	## find display name 
	my $displayname_th = $clanname_th->right->right;
	my $displayname = trim($displayname_th->as_text);
	debug('  Clan display name is ', $displayname);

	## find membership list
	my $membership_th = $tree->look_down(
		_tag => 'th',
		align => 'left',
		valign => 'top',
		colspan => '2',
		bgcolor => '#3f3f3f',
	);
	die unless $membership_th->as_text =~ /Membership for $displayname/;

	## record members
	my @members;
	for (my $member_tr = $membership_th->parent->right->right;
			 $member_tr;
			 $member_tr = $member_tr->right) {
		my $member_th = ($member_tr->descendants)[0];
		my $member = trim($member_th->as_text);
		next unless $member;
		push @members, $member;
		debug("    Found member '$member'");
	}
	
	## store member list for clan
	$clans{$clanname} = {
		name => $clanname,
		display_name => $displayname,
		members => \@members,
	};	
	
	## we must manually delete the HTML tree, because it is a hellishly 
	## interlinked list which will confound garbage collection
	$tree->delete;
}


open CLANS, '>', $CLANFILE or die $!;
for my $clan (keys %clans) {
	my $displayname = $clans{$clan}{display_name};
	for my $member (@{$clans{$clan}{members}}) {
		print CLANS "$clan\t$displayname\t$member\n";
	}
}
close CLANS;



sub debug {
	print STDERR @_, "\n" if $DEBUG;
}

sub trim {
	my ($str) = @_;
	$str =~ s/^\s+//;
	$str =~ s/\s+$//;
	return $str;
}

