#!/usr/bin/perl
#PlinkMAP2BED.pl
#2018,7.23
#Plink MAPファイルをBEDに変換する
#how to use 
#$ perl PlinkMAP2BED.pl < input.map


#==================================================
# Akm_26popsのラベルとIDファイルを読み込み、ヘッダーをハッシュ化
#open (IN, "/home/walnut/work/work_stacks/Akm_stacks/Ref_v2_2_26pops/Akm_26pops_OUTG_lab_arb.txt");

# ハッシュ初期化
%snp_identifier_chr = ();
%snp_identifier_position = ();

$i = 0;
while($line=<>){
	chomp $line;
	($chromosome, $snp_identifier, @info) = split /\s+/,$line;
	($chr_identifier, $position_identifier) = split /:/,$snp_identifier;
	 # ハッシュはキーと値を同時に格納しないといけない
	$snp_identifier_chr{$snp_identifier} = $chr_identifier;
	$snp_identifier_position{$snp_identifier} = $position_identifier;
}

foreach $ID (sort keys %snp_identifier_chr){
	$start_position = $snp_identifier_position{$ID} - 1;
	$end_position = $snp_identifier_position{$ID};
	print "$snp_identifier_chr{$ID}\t$start_position\t$end_position\n";
}