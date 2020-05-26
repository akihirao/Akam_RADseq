#!/usr/bin/perl
#Calc.GenotypingRatePed_total.pl
#2018,7.17
#ped formatのSNPtableからジェノタイピング率を算出する
#パスが通った~/analtools/に本スクリプトを置き、実行
#How2use
# $ Calc.GenotypingRatePed.pl < input.ped
#縮重コードはジェノタイピングされていないとみなす

$i = 0;
@genotying_rate_vec = ();
@total_base = 0;
@total_genotyping_base = 0;

while($line = <>){
	chomp $line;
	($pop_lab, $indiv_lab, $lab1, $lab2, $lab3, $lab4, @base_info) = split (/\s+/,$line);
	$count_genotyped = 0;
	$no_loci = @base_info / 2;
	
#	print $no_loci,  "\n";

	foreach $each_base (@base_info){
	    if($each_base =~ m/[A,G,C,T]/){
	      ++$count_genotyped;
	    }
	}

#	print $no_loci, "\t", $count_genotyped,  "\n";

	$total_base = $total_base + @base_info;
	$total_genotyping_base = $total_genotyping_base + $count_genotyped;

#	print $total_genotyping_base,  "\n";
	
	$genotyping_rate_indiv = ($count_genotyped /2)/$no_loci;
	$genotyping_rate_vec[$i] = $genotyping_rate_indiv;
	++$i;
}


foreach $g_rate (@genotyping_rate_vec){
#  printf "%.3f\n", $g_rate;
}

#print "\n";

print "No. SNPs", "\t";
print $no_loci, "\n";

$overall_g_rate = $total_genotyping_base / $total_base;
print "Overall genotyping rate", "\t";
printf "%.3f\n", $overall_g_rate;

