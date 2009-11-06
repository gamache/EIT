package NHT::Trophy::BestOf13;

use Data::Dumper;
use List::Util qw{max min reduce sum};

sub name { "best_of_13" }

sub results {
  my ($class, $nht) = @_;
  
  my %best;
  for my $player (@{$nht->players}) {
    my $games = [ grep { $_->{trickery}==0 } @{$nht->games($player)} ];
    $best{$player} = best_of_13($games);
  }

  my @b13 = map { {player => $_, value => $best{$_} } }
    sort { $best{$b} <=> $best{$a} } keys %best;

  return \@b13;
}

sub best_of_13 {
  my ($games) = @_;

  my $ngames = scalar @$games;

  sub _rrga_string {
    my ($game) = @_;
    return join ':', @$game{qw/race role gender0 align0/};
  }
  
  sub _best_of_13 {
    my ($start_index, $best_result, $games, $ngames) = @_;
    return $best_result if $start_index >= $ngames;

    my $asc_rrga = {
      map { _rrga_string($_) => 1 }
	  grep { $_->{ascended} } @$games[$start_index..$start_index+12]
    };
    my $nasc = scalar keys %$asc_rrga;

    return _best_of_13($start_index+1, max($best_result, $nasc), $games, $ngames);
  }

  return _best_of_13(0, 0, $games, $ngames);
}

13;
