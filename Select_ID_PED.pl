#!/usr/bin/perl
#Select_ID_PED.pl
#Selecting individual ID from a Plink PED file
#how to use 
#$ perl Select_ID_PED.pl < input.ped


while($line=<>){
	chomp $line;
	($family_ID, $indv_ID, @info) = split /\s+/,$line;
	print "$indv_ID\n";
}
