#!/gsc/bin/perl

use warnings;
use strict;
use IO::File;

#arg 0 = ensembl conversion table (transcript_id, gene_id, gene_name)
#arg 1 = expression estimates with gene_id as the first column

#appends gene name to the table in the last column

my %nameHash;
my $inFh = IO::File->new( $ARGV[0] ) || die "can't open file\n";
while( my $line = $inFh->getline )
{
    chomp($line);
    my @F = split("\t",$line);
    $nameHash{$F[1]} = $F[2];
}


my $inFh2 = IO::File->new( $ARGV[1] ) || die "can't open file\n";
while( my $line = $inFh2->getline )
{
    chomp($line);
    my @F = split("\t",$line);
    if($F[0] eq "gene"){ #header
        print "gene_name" . "\t" . $line . "\n";
        next;
    }

    if(exists($nameHash{$F[0]})){
        print join("\t",($nameHash{$F[0]},@F)) . "\n";
    } else {
        print join("\t",("NA",@F)) . "\n";
    }
}
