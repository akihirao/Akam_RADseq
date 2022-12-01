#!/usr/bin/perl
#Extract_ID_list_from_PED.pl
#how to use
#$ perl Extract_ID_from_PED.pl < input.ped


while($line=<>){
	chomp $line;
	($ID, @info) = split /\s+/,$line;
	
	print $ID, "\t", $ID, "\n";

}
