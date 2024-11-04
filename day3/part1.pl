use strict;
use warnings;

sub isDigit {
    my ( $input, @etc ) = @_;
    if (length($input) > 1) {
        return 0;
    }
    my $isDigit = $input =~ /[0-9]/;
    return $isDigit;
}

sub printSchematic {
    my ( @schematic ) = @_;
    my $rows = scalar(@schematic);
    my $cols = scalar(@{$schematic[0]});

    for (my $r = 0; $r < $rows; $r++) {
        for (my $c = 0; $c < $cols; $c++) {
            print $schematic[$r][$c];
        }
        print "\n";
    }
}

# Returns 1 if any of the cells surrounding a subset of a row 
# between $colStart and $colEnd contain a character that is not "." (else 0)
# Example 1: @schematic below, $row=1, $colStart=2, $colEnd=4
# Example 2: @schematic below, $row=0, $colStart=7, $colEnd=8
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
# Result 1: 1
# Result 2: 0
sub checkAdjacentCells {
    my ( $schematic_ref, $row, $colStart, $colEnd ) = @_;
    my @schematic = @$schematic_ref;
    my $rows = scalar(@schematic);
    my $cols = scalar(@{$schematic[0]});

    if ($row > $rows || $colStart > $cols || $colEnd > $cols) {
        die "Invalid arguments given to checkAdjacentCells";
    }

    my $colLeft = $colStart;
    if ($colStart > 0) {
        $colLeft--;
    }
    my $colRight = $colEnd;
    if ($colEnd < $cols - 1) {
        $colRight++;
    }
    # Check above
    if ($row > 0) {
        for (my $col = $colLeft; $col <= $colRight; $col++) {
            if ($schematic[$row - 1][$col] ne "." && isDigit($schematic[$row - 1][$col]) == 0) {
                return 1;
            }
        }
    }
    # Check below
    if ($row < $rows - 1) {
        for (my $col = $colLeft; $col <= $colRight; $col++) {
            if ($schematic[$row + 1][$col] ne "." && isDigit($schematic[$row + 1][$col]) == 0) {
                return 1;
            }
        }
    }

    # Check to the left 
    if ($colLeft < $colStart) {
        if ($row > 0) {
            if ($schematic[$row - 1][$colLeft] ne "." && isDigit($schematic[$row - 1][$colLeft]) == 0) {
                return 1;
            }
        }
        if ($schematic[$row][$colLeft] ne "." && isDigit($schematic[$row][$colLeft]) == 0) {
            return 1;
        }
        if ($row < $rows - 1) {
            if ($schematic[$row + 1][$colLeft] ne "." && isDigit($schematic[$row + 1][$colLeft]) == 0) {
                return 1;
            }
        }
    }

    # Check to the right
    if ($colRight > $colEnd) {
        if ($row > 0) {
            if ($schematic[$row - 1][$colRight] ne "." && isDigit($schematic[$row - 1][$colRight]) == 0) {
                return 1;
            }
        }
        if ($schematic[$row][$colRight] ne "." && isDigit($schematic[$row][$colRight]) == 0) {
            return 1;
        }
        if ($row < $rows - 1) {
            if ($schematic[$row + 1][$colRight] ne "." && isDigit($schematic[$row + 1][$colRight]) == 0) {
                return 1;
            }
        }
    }

    return 0;
}

# my $filename = "example.txt";
my $filename = "input.txt";
open (my $fh, "<:encoding(UTF-8)", $filename) 
    or die "Could not open file '$filename' $!";

my @schematic = ();
while (my $line = <$fh>) {
    chomp $line;
    my @chars = split(//, $line);
    push(@schematic, \@chars);
}
close($fh);

my $sum = 0;
my $rows = scalar(@schematic);
my $cols = scalar(@{$schematic[0]});
for (my $r = 0; $r < $rows; $r++) {
    my $start = -1;
    my $end = -1;
    my @digits = ();

    for (my $c = 0; $c < $cols; $c++) {
        if (isDigit($schematic[$r][$c])) {
            if ($start == -1) {
                $start = $c;
            } 
            $end = $c;
            push(@digits, $schematic[$r][$c]);
        } else {
            if ($start != -1 && $end != -1 && @digits) {
                if (checkAdjacentCells(\@schematic, $r, $start, $end) == 1) {
                    $sum += join("", @digits) + 0;
                } 
            }
            $start = -1;
            $end = -1;
            @digits = ();
        }
    }

    # Check the last subset in the row if it's a valid one
    if ($start != -1 && $end != -1 && @digits) {
        if (checkAdjacentCells(\@schematic, $r, $start, $end) == 1) {
            $sum += join("", @digits) + 0;
        } 
    }
}

print "Sum is $sum.\n";
