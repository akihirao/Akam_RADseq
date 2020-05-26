#!/usr/bin/perl
#Select_ID_PED.pl
#2020,5.25
#Plink PEDファイルのIDをセレクト
#how to use 
#$ perl Select_ID_PED.pl < input.ped


while($line=<>){
	chomp $line;
	($family_ID, $indv_ID, @info) = split /\s+/,$line;
	print "$indv_ID\n";
}