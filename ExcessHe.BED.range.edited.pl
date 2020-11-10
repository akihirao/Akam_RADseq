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

$read_length = 100;

$chromosome_pre2 = Ahal_v2_2_scaffold_0;
$start_position_read_pre2 = 1;
$end_position_read_pre2 = 200;

$line=<>;
chomp $line;
($chromosome_pre1, $start_position_pre1, $end_position_pre1) = split /\s+/,$line;
$start_position_read_pre1 =  $start_position_pre1  - $read_length;
$end_position_read_pre1 =  $end_position_pre1  + $read_length;
if($start_position_read_pre1 < 0){
		$start_position_read_pre1 = 1;
}


while($line=<>){
	chomp $line;
	($chromosome, $start_position, $end_position) = split /\s+/,$line;

	$start_position_read = $start_position - $read_length;
	if($start_position_read < 0){
		$start_position_read = 1;
	}
	$end_position_read = $end_position + $read_length;


	if($chromosome_pre2 ne $chromosome_pre1){
		if($chromosome_pre1 eq $chromosome){
			if($start_position_read > $end_position_read_pre1){
				
				print $chromosome_pre1, "\t", $start_position_read_pre1, "\t", $end_position_read_pre1, "\n";

	 			$chromosome_pre2 = $chromosome_pre1;
				$start_position_read_pre2 = $start_position_read_pre2;
				$end_position_read_pre2 = $end_position_read_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_read_pre1 = $start_position_read_pre1;
				$end_position_read_pre1 = $end_position_read;

			}else{

			}

		#行の前後でCHRが変わる場合
		}else{
			print $chromosome_pre1, "\t", $start_position_read_pre1, "\t", $end_position_read_pre1, "\n";

			$chromosome_pre2 = $chromosome_pre1;
			$start_position_read_pre2 = $start_position_read_pre2;
			$end_position_read_pre2 = $end_position_read_pre1;
			$chromosome_pre1 = $chromosome;
			$start_position_read_pre1 = $start_position_read1;
			$end_position_read_pre1 = $end_position_read;
		}

	}else{ 

		if($start_position_read > $end_position_read_pre1){
			
			print $chromosome_pre1, "\t", $start_position_read_pre2, "\t", $end_position_read_pre1, "\n";

	 		$chromosome_pre2 = $chromosome_pre1;
			$start_position_read_pre2 = $start_position_read_pre1;
			$end_position_read_pre2 = $end_position_read_pre1;
			$chromosome_pre1 = $chromosome;
			$start_position_read_pre1 = $start_position_read1;
			$end_position_read_pre1 = $end_position_read;

		}else{

	 		$chromosome_pre2 = $chromosome_pre1;
			$start_position_read_pre2 = $start_position_read_pre1;
			$end_position_read_pre2 = $end_position_read_pre1;
			$chromosome_pre1 = $chromosome;
			$start_position_read_pre1 = $start_position_read;
			$end_position_read_pre1 = $end_position_read;

		}


	}

}
