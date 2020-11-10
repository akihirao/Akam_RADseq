#!/usr/bin/perl
#ExcessHe.BED.range.edited.pl
#Edit BED file with Excess Heterozygosity for estimate pi
#how to use 
#$ perl ExcessHe.BED.range.edited.pl < input.bed


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
$output_start = $start_position_pre1 - $read_length;
if($output_start < 0 ){
	$output_start = 1;
}
$output_end = $start_position_pre1 + 1 + $read_length;


while($line=<>){
	chomp $line;
	($chromosome, $start_position, $end_position) = split /\s+/,$line;

	if($chromosome ne $chromosome_pre1){
		$output_end = $start_position_pre1 + 1 + $read_length;
		print $chromosome_pre1, "\t", $output_start, "\t", $output_end, "\n";
		$output_start = $start_position - $read_length;
		if($output_start < 0 ){
			$output_start = 1;
		}
	}else{
		$dif_len_positions = $start_position - $start_position_pre1;
		if($dif_len_positions > $pair_read_length){
			$output_end = $start_position_pre1 + 1 + $read_length;

			print $chromosome_pre1, "\t", $output_start, "\t", $output_end, "\n";
			$output_start = $start_position - $read_length;
			if($output_start < 0 ){
				$output_start = 1;
			}
		}else{
			$output_end = $start_position_pre1 + 1 + $read_length;
		}
	}

	$chromosome_pre2 = $chromosome_pre1;
	$chromosome_pre1 = $chromosome;	
	$start_position_pre2 = $start_position_pre1;
	$start_position_pre1 = $start_position;

}

if($chromosome ne $chromosome_pre1){
	$last_output_start = $start_position - $read_length;
	if($last_output_start < 0 ){
		$last_output_start = 1;
	}
	$last_output_end = $start_position + 1 + $read_length;
	print $chromosome, "\t", $last_output_start, "\t", $last_output_end, "\n";

}else{
	$dif_len_positions = $start_position - $start_position_pre1;
	if($dif_len_positions > $pair_read_length){

		$last_output_start = $start_position - $read_length;
		if($last_output_start < 0 ){
			$last_output_start = 1;
		}
		$last_output_end = $start_position + 1 + $read_length;

		print $chromosome, "\t", $last_output_start, "\t", $last_output_end, "\n";	
	}else{
		$last_output_end = $start_position + 1 + $read_length;		
		print $chromosome, "\t", $output_start, "\t", $last_output_end, "\n";	

	}
}
