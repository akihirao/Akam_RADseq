#!/usr/bin/perl
#RAW_FID_lab_edit.pl
#Modification of FID in ped (Popxxx -> Pop)
#how to use 
#$ perl PED_FID_lab_edit.pl < input.ped

$line=<>;
chomp $line;
print $line, "\n";

while($line=<>){
	chomp $line;
	($FID, @info) = split /\s+/,$line;
	$PopID = substr($FID, 0, 3);
	
	$last_info = pop(@info);
	print $PopID, "\t";
  	foreach $out_info (@info){
  			print $out_info, " ";
  		}
	print $last_info, "\n";
}
