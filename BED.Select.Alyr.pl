#! /usr/bin/perl
#BED.Select.Alyr.pl
#2018,7.23
#BEDファイルの中でL-homeologを抽出するBED
#how to use 
#>perl BED.Select.Ahal < input.map

while($line=<>){
	chomp $line;
	if ($line =~ /^Alyr/m) {
	print "$line\n";
	}
}