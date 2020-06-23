#!/bin/bash
#split.pops.vcf.sh


while read Pop; do


	#ファイル入出力用のラベルなどを定義
	#MID_no="kam008"
	echo $Pop

	vcftools --vcf populations.snps.ahal.vcf --keep $Pop.txt --recode --recode-INFO-all --out $Pop.ahal

	vcftools --vcf $Pop.ahal.recode.vcf --hardy --out $Pop.ahal.hardy
	perl listup_FixedHe_locus.pl < $Pop.ahal.hardy.hwe > $Pop.ahal.FixedHe.list.txt
	vcftools --vcf $Pop.ahal.recode.vcf --exclude-positions $Pop.ahal.FixedHe.list.txt --recode --recode-INFO-all --out $Pop.ahal.NoFixedHe
	bgzip $Pop.ahal.NoFixedHe.recode.vcf
	vcf-sort $Pop.ahal.NoFixedHe.recode.vcf.gz | bgzip -c > $Pop.ahal.NoFixedHe.sorted.vcf.gz
	tabix -p vcf $Pop.ahal.NoFixedHe.sorted.vcf.gz
done < ./pop_list.txt #list of kam_MID
#done < ./pop_list_test.txt #list of kam_MID
