#! /usr/bin/perl
#VCF.add.Ref.GT.pl
#how to use 
#$ perl VCF_add_AhalRef.pl < input.vcf >  output.vcf

#GT:AD:DP:FT:GQ:PL


while($line = <>){
	chomp $line;
  
  if ($line !~ /^#/m ){ 
      ($CHROM_site , $POS_site, $ID_site, $REF_site, $ALT_site, $QUAL_site, $FILTER_site, $INFO_site, $FORMAT_site, @sample_site) = split (/\s+/,$line);
      $Ref_info=$sample_site[0];

      $Ref_GT = "0/0";

      (@Ref_info_element)= split  (/:/,$Ref_info);
      $Ref_info_element[0] = "0/0";
      $Ref_info_element[1] = "50,0";
      $Ref_info_element[2] = "50";
      $Ref_info_element[3] = "PASS";
      $Ref_info_element[4] = "99";
      
      print $CHROM_site, "\t", $POS_site, "\t", $ID_site, "\t", $REF_site, "\t", $ALT_site, "\t", $QUAL_site, "\t", $FILTER_site, "\t", $INFO_site, "\t", $FORMAT_site, "\t";

      $last_Ref_info_element= pop(@Ref_info_element);
      foreach $out_Ref_info (@Ref_info_element){
        print $out_Ref_info, ":";  
      }
      print $last_Ref_info_element, "\t";

      $last_sample_site = pop(@sample_site);     
      foreach $out_sample_site (@sample_site){
        print $out_sample_site, "\t";
      }
      print $last_sample_site, "\n";  
  
  }elsif($line =~ /^#CHROM/m){
    ($CHROM , $POS, $ID, $REF, $ALT, $QUAL, $FILTER, $INFO, $FORMAT, @sample) = split (/\s+/,$line);
    unshift @sample, "AHAL";
    $last_sample = pop(@sample);

    print $CHROM, "\t", $POS, "\t", $ID, "\t", $REF, "\t", $ALT, "\t", $QUAL, "\t", $FILTER, "\t", $INFO, "\t", $FORMAT, "\t";
      
    foreach $out_sample (@sample){
      print $out_sample, "\t";
    }
    print $last_sample, "\n";


  }else{
    print $line, "\n"; 
  }

}


#print $Ref_GT, "\n"