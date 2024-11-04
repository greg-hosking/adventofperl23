use strict;
use warnings;

my $filename = "input.txt";
open (my $fh, "<:encoding(UTF-8)", $filename)
    or die "Could not open file '$filename' $!";

my $sum = 0;
while (my $game = <$fh>) {
    chomp $game;
    $game =~ s/Game //g;
    my ($id, $rest) = split(/: /, $game, 2);
    my @sets = split(/; /, $rest);
    my %minBagCounts = (
        "red" => 0,
        "green" => 0,
        "blue" => 0,
    );
    foreach my $subset (@sets) {
        foreach my $element (split(/, /, $subset)) {
            my ($count, $color) = split(/ /, $element);
            if ($count > $minBagCounts{$color}) {
                $minBagCounts{$color} = $count;
            }
        }
    }
    my $power = $minBagCounts{"red"} * $minBagCounts{"green"} * $minBagCounts{"blue"};
    $sum += $power;
}

print "Sum is $sum.\n";

close($fh);
