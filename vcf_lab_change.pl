#! /usr/bin/perl
#vcf_lab_change.pl
#replacing from individual ID in vcf file to combined ID (pop+individual)
#how to use 
#$ perl vcf_lab_change.pl < input.vcf


#==================================================
# making hash from ID-pop labeling file
open (IN, "POP_ID_list.txt");


%pop_ID_list = ();

while($line=<IN>){
	chomp $line;
	($kam_ID, $pop_ID, $pop) = split /\s+/,$line;
	$pop_ID_list{$kam_ID} = $pop_ID;
}
close(IN);
#==================================================


while($line_vcf = <>){
	chomp $line_vcf;
	
	if ($line_vcf =~ /^#CHROM/m) {
  		
  		($CHROM	, $POS, $ID, $REF, $ALT, $QUAL, $FILTER, $INFO, $FORMAT, @kam_sample) = split (/\s+/,$line_vcf);
  		$no_sample = @kam_sample;
  		@kam_kam_sample_revised = @kam_sample;
  		for ($i = 0; $i < $no_sample; $i++){
  			$target_kam_ID = $kam_sample[$i];
  			$target_kam_ID =~ s/_a...//; #delete "_ahal" or "_alyr"
  			push @pop_ID_sample, $pop_ID_list{$target_kam_ID};
  		}
  		$last_pop_ID_sample = pop(@pop_ID_sample);
  		print $CHROM, "\t", $POS, "\t", $ID, "\t", $REF, "\t", $ALT, "\t", $QUAL, "\t", $FILTER, "\t", $INFO, "\t", $FORMAT, "\t";
  		foreach $out_sample (@pop_ID_sample){
  			print $out_sample, "\t";
  		}
  		print $last_pop_ID, "\n";  
  	
	}else{
		print $line_vcf, "\n";
	}

}

