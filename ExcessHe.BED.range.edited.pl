#!/usr/bin/perl
#ExcessHe.BED.range.edited.pl
#Edit BED file with Excess Heterozygosity for estimate pi
#how to use 
#$ perl ExcessHe.BED.range.edited.pl < input.bed


#==================================================
# making hash from ID-pop labeling file
#open (IN, "/home/walnut/work/work_stacks/Akm_stacks/Ref_v2_2_26pops/Akm_26pops_OUTG_lab_arb.txt");

# initializing hash
#%snp_identifier_chr = ();
#%snp_identifier_position = ();


$chromosome_pre = Ahal_v2_2_scaffold_0;
$start_position_pre = -1;
$end_position_pre = 0;
$read_length = 100;


while($line=<>){
	chomp $line;
	($chromosome, $start_position, $end_position) = split /\s+/,$line;

	$output_start_position = $start_position - 100;
	$output_end_position = $end_position + 100;
	
	print $chromosome, "\t", $output_start_position, "\t", $output_end_position "\n", 
}

