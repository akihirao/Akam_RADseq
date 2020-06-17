#!/usr/bin/perl
#LDpruned2BED.pl
#conversion from LD-prune.in to BED
#how to use 
#$ perl LDpruned2BED < input.prune.in


#==================================================
while($line=<>){
	chomp $line;
	($chr, $position) = split /:/,$line;
	$start_position = $position -1;
	$end_position = $position;
	print "$chr\t$start_position\t$end_position\n";
}
