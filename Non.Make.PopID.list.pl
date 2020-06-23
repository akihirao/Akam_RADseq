#!/usr/bin/perl
#Make.PopID.list.pl
#Modification of FID in ped (Popxxx -> Pop)
#how to use 
#$ perl PED_FID_lab_edit.pl < input.ped




#==================================================
# making hash from ID-pop labeling file
open (IN, "pop_list.txt");


@pop_list = ();

while($line=<IN>){
	chomp $line;
	push @pop_list, $line;
}
close(IN);
#==================================================

$no_pop = @pop_list;

for ($i = 0; $i < $no_pop; $i++){

	$target_pop = $pop_list[$i];
	print $target_pop, "\n";

}

#==================================================

