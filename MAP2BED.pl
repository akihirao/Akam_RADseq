#! /usr/bin/perl
#MAP2BED.pl
#Conversion from *.map to *.bed
#how to use 
#>perl *.map < input.map

while($line=<>){
	chomp $line;
	if($line !~ m/^#/){	    
		($head_mark, $CHR_POS, $start_zero, $end) = split /\s+/, $line;
		($CHR, $POS) = split /:/, $CHR_POS;
		$start = $end -1;
		print $CHR, "\t", $start, "\t", $POS, "\n"; 
	}
}
