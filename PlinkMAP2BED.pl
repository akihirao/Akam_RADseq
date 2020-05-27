#!/usr/bin/perl
#PlinkMAP2BED.pl
#conversion from Plink MAP to BED
#how to use 
#$ perl PlinkMAP2BED.pl < input.map


#==================================================
# making hash from ID-pop labeling file
#open (IN, "/home/walnut/work/work_stacks/Akm_stacks/Ref_v2_2_26pops/Akm_26pops_OUTG_lab_arb.txt");

# initializing hash
%snp_identifier_chr = ();
%snp_identifier_position = ();

$i = 0;
while($line=<>){
	chomp $line;
	($chromosome, $snp_identifier, @info) = split /\s+/,$line;
	($chr_identifier, $position_identifier) = split /:/,$snp_identifier;
	$snp_identifier_chr{$snp_identifier} = $chr_identifier;
	$snp_identifier_position{$snp_identifier} = $position_identifier;
}

foreach $ID (sort keys %snp_identifier_chr){
	$start_position = $snp_identifier_position{$ID} - 1;
	$end_position = $snp_identifier_position{$ID};
	print "$snp_identifier_chr{$ID}\t$start_position\t$end_position\n";
}
