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
$pair_read_length = $read_length * 2;

$line_pre2 = "Ahal_v2_2_scaffold_0\t1\t2";
$chromosome_pre2 = Ahal_v2_2_scaffold_0;
$start_position_pre2 = 1;
$end_position_pre2 = 2;


$line=<>;
chomp $line;
$line_pre1 = $line;
($chromosome_pre1, $start_position_pre1, $end_position_pre1) = split /\s+/,$line;


while($line=<>){
	chomp $line;
	($chromosome, $start_position, $end_position) = split /\s+/,$line;

	if($chromosome_pre2 ne $chromosome_pre1){
		if($chromosome_pre1 ne $chromosome){

			$output_start_position = $start_position_pre1 - $read_length;
			if($output_start_position < 0){
				$output_start_position = 1
			}
			$output_end_position = $end_position_pre1 + $read_length;
			print $chromosome_pre1, "\t", $output_start_position, "\t", $output_end_position, "\n";

			$chromosome_pre2 = $chromosome_pre1;
			$start_position_pre2 = $start_position_pre1;
			$end_position_pre2 = $end_position_pre1;
			$chromosome_pre1 = $chromosome;
			$start_position_pre1 = $start_position;
			$end_position_pre1 = $end_position;

		#前のCHRとは異なるが後ろのCHRとは同じ
		}else{
			$post_diff_position = $start_position - $start_position_pre1;

			if($post_diff_position  > $pair_read_length){
				$output_start_position = $start_position_pre1 - $read_length;
				if($output_start_position < 0){
					$output_start_position = 1
				}
				$output_end_position = $end_position_pre1 + $read_length;
				print $chromosome_pre1, "\t", $output_start_position, "\t", $output_end_position, "\n";

				$chromosome_pre2 = $chromosome_pre1;
				$start_position_pre2 = $start_position_pre1;
				$end_position_pre2 = $end_position_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_pre1 = $start_position;
				$end_position_pre1 = $end_position;
		
			}else{
				$chromosome_pre2 = $chromosome_pre1;
				$start_position_pre2 = $start_position_pre1;
				$end_position_pre2 = $end_position_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_pre1 = $start_position;
				$end_position_pre1 = $end_position;
			}
		}

	#前のCHRと同じ
	}else{
		if($chromosome_pre1 eq $chromosome){
			$pre_diff_position = $start_position_pre1 - $start_position_pre2;
			$post_diff_position = $start_position - $start_position_pre1;

			if()

		}
				$output_start_position = $start_position_pre1 - $read_length;
				if($output_start_position < 0){
					$output_start_position = 1
				}
				$output_end_position = $end_position_pre1 + $read_length;
				print $chromosome_pre1, "\t", $output_start_position, "\t", $output_end_position, "\n";

	 			$chromosome_pre2 = $chromosome_pre1;
				$start_position_pre2 = $start_position_pre1;
				$end_position_pre2 = $end_position_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_pre1 = $start_position;
				$end_position_pre1 = $end_position;

			}else{
				$chromosome_pre2 = $chromosome_pre1;
				$start_position_pre2 = $start_position_pre1;
				$end_position_pre2 = $end_position_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_pre1 = $start_position;
				$end_position_pre1 = $end_position;

			}

		#行の前後でCHRが変わる場合
		}else{
		
		}

	#前と同じCHRの場合
	}else{ 

		if($chromosome_pre1 eq $chromosome){
			$pre_diff_position = $start_position_pre1 - $start_position_pre2;
			$post_diff_position = $start_position - $start_position_pre1;

			if($post_diff_position  > $pair_read_length){
				
				$output_start_position = $start_position_pre1 - $read_length;
				if($output_start_position < 0){
					$output_start_position = 1
				}
				$output_end_position = $end_position_pre1 - $read_length;
				print $chromosome_pre1, "\t", $output_start_position, "\t", $output_end_position, "\n";

	 			$chromosome_pre2 = $chromosome_pre1;
				$start_position_pre2 = $start_position_pre1;
				$end_position_pre2 = $end_position_pre1;
				$chromosome_pre1 = $chromosome;
				$start_position_pre1 = $start_position;
				$end_position_pre1 = $end_position;

			}else{

			}

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
