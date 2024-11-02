use strict;
use warnings;

my $filename = "input.txt";
open(my $fh, "<:encoding(UTF-8)", $filename)
    or die "Could not open file '$filename' $!";

my $sum = 0;
while (my $row = <$fh>) {
    chomp $row;
    $row =~ s/[a-zA-Z]//g;
    my $value = (substr($row, 0, 1) * 10) + substr($row, length($row) - 1, 1);
    $sum += $value;
}

print "Sum is $sum.\n";

close($fh);
