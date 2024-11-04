use strict;
use warnings;

my $filename = "input.txt";
open (my $fh, "<:encoding(UTF-8)", $filename)
    or die "Could not open file '$filename' $!";

my %bagCounts = (
    "red" => 12,
    "green" => 13,
    "blue" => 14,
);

my $sum = 0;
while (my $game = <$fh>) {
    chomp $game;
    $game =~ s/Game //g;
    my ($id, $rest) = split(/: /, $game, 2);
    my @sets = split(/; /, $rest);
    my $possible = 1;
    foreach my $subset (@sets) {
        foreach my $element (split(/, /, $subset)) {
            my ($count, $color) = split(/ /, $element);
            if ($count > $bagCounts{$color}) {
                $possible = 0;
            }
        }
    }
    if ($possible == 1) {
        $sum += $id;
    }
}

print "Sum is $sum.\n";

close($fh);
