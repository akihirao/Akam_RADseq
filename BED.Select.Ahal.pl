#! /usr/bin/perl
#BED.Select.Ahal.pl
#2018,7.23
#BEDファイルの中でL-homeologを抽出するBED
#how to use 
#>perl BED.Select.Ahal < input.map

while($line=<>){
	chomp $line;
	if ($line =~ /^Ahal/m) {
	print "$line\n";
	}
}