use strict;
use warnings;

my $filename = "input.txt";
open(my $fh, "<:encoding(UTF-8)", $filename)
    or die "Could not open file '$filename' $!";

my %digits = (
    'one' => 'o1e',
    'two' => 't2o',
    'three' => 't3e',
    'four' => 'f4',
    'five' => 'f5e',
    'six' => 's6',
    'seven' => 's7n',
    'eight' => 'e8t',
    'nine' => 'n9e',
);

my $sum = 0;
while (my $row = <$fh>) {
    chomp $row;
    print "\$row: $row\n";
    for my $key (keys %digits) {
        $row =~ s/$key/$digits{$key}/g;
    }
    $row =~ s/[a-zA-Z]//g;
    my $value = (substr($row, 0, 1) * 10) + substr($row, length($row) - 1, 1);
    print "\$value: $value\n";
    $sum += $value;
}

print "Sum is $sum.\n";

close($fh);
