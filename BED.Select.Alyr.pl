#! /usr/bin/perl
#BED.Select.Alyr.pl
#Extracting L-homeologous sites from BED
#how to use 
#>perl BED.Select.Ahal < input.map

while($line=<>){
	chomp $line;
	if ($line =~ /^Alyr/m) {
	print "$line\n";
	}
}
