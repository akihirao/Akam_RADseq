#!/usr/bin/perl
#Singletons2BED.pl
#conversion from a singletons file extracted by vcftools to BED
#how to use 
#$ perl VCFsingleton2BED.pl < input.singletons


$line=<>; #cutting off a header line

while($line=<>){
	chomp $line;
	($Chr, $end, @info) = split /\s+/,$line;
	$start = $end -1;
	print $Chr, "\t", $start, "\t", $end, "\n";
}
