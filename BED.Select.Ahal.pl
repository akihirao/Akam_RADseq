#! /usr/bin/perl
#BED.Select.Ahal.pl
#Extracting H-homeologous sites from BED
#how to use 
#>perl BED.Select.Ahal < input.map

while($line=<>){
	chomp $line;
	if ($line =~ /^Ahal/m) {
	print "$line\n";
	}
}
