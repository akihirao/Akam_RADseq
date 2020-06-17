#!/usr/bin/perl
#STRUCTURE_lab_edit.pl
#Selecting individual ID from a Plink PED file
#how to use 
#$ perl STRUCTURE_lab_edit.pl < input.str

open (POP_IN, "/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/shell_script/Pop_info.txt");

%PopID_PopNo = ();


$line=<POP_IN>;

while($line=<POP_IN>){
	chomp $line;
	($PopID, $PopNo, $PopName, $NoSamples, $latitude, $longitude) = split /\s+/,$line;
	$PopID_PopNo{$PopID} = $PopNo;
}

close (POP_IN);


#output header lline
$line=<>;
chomp $line;
print $line, "\n";

while($line=<>){
	chomp $line;
	($sample_ID, $PopNo_pre, @info) = split /\s+/,$line;
	$target_PopID = substr($sample_ID, 0, 3);
	$target_PopNo = $PopID_PopNo{$target_PopID} ;

	$last_info = pop(@info);
	print $sample_ID, "\t", $target_PopNo, "\t";
  	foreach $out_info (@info){
  			print $out_info, " ";
  		}
	print $last_info, "\n";
}
