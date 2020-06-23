#!/usr/bin/perl
#PlinkMAP_modified2A.pl
#modifying Plink MAP to convert plink raw format
#how to use 
#$ perl PlinkMAP_modified2A.pl < input.map


#==================================================
$i = 0;
while($line=<>){
	chomp $line;
	$i = $i +1;
	($chromosome, $snp_identifier, $genetic_distance, $bp_position) = split /\s+/,$line;
	print "$chromosome\t$snp_identifier\t$genetic_distance\t$i\n";
}
