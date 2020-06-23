#!/usr/bin/perl
#PlinkMAP_modified2A.pl
#modifying Plink MAP to convert plink raw format
#how to use 
#$ perl PlinkMAP_modified2A.pl $i < input.map

$i = shift; #start no. sites
#==================================================
#$i = 0;
while($line=<>){
	$i = $i +1;
	chomp $line;
	($chromosome, $snp_identifier, $genetic_distance, $bp_position) = split /\s+/,$line;
	print "$chromosome\t$snp_identifier\t$genetic_distance\t$i\n";
}
