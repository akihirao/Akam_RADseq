#!/bin/bash
#Pipe.09.FilteringExcessHePop.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20/Akm/reanalysis/Reference
main_folder=/mnt/WD20/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering

cluster_size=200

module load samtools/1.10
module load gatk4/4.3.0.0
module load vcftools/0.1.16
module load bcftools/1.16

 

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: SNPs on H-homeologs
zcat $vcf_folder/Akm.ahal.snp.DPfilterNoCall.vcf.gz | perl $script_folder/vcf_lab_change.pl  > $vcf_folder/Akm.ahal.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.lab_edit.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: SNPs+Non-variants on H-homeologs
zcat $vcf_folder/Akm.ahal.snp.non_variant.DPfilterNoCall.vcf.gz | perl $script_folder/vcf_lab_change.pl  > $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf > $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf.gz

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: SNPs on L-homeologs
zcat $vcf_folder/Akm.alyr.snp.DPfilterNoCall.vcf.gz | perl $script_folder/vcf_lab_change.pl > $vcf_folder/Akm.alyr.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.lab_edit.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: SNPs+Non-variants on L-homeologs
zcat $vcf_folder/Akm.alyr.snp.non_variant.DPfilterNoCall.vcf.gz | perl $script_folder/vcf_lab_change.pl > $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf > $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf.gz

echo -n > $vcf_folder/Akm.ahal.ExcessHe.list.txt
echo -n > $vcf_folder/Akm.alyr.ExcessHe.list.txt


while read Pop; do
	
	work_folder=$vcf_folder/Pops
	mkdir -p $work_folder
	cd $work_folder

	echo $Pop
	mkdir -p $Pop
	echo -n > $work_folder/$Pop/$Pop.samples.list
	grep "${Pop}[0-9][0-9][0-9]" $script_folder/PopID.Code.list.txt >> $work_folder/$Pop/$Pop.samples.list

	vcftools --gzvcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
	 --keep $work_folder/$Pop/$Pop.samples.list\
	 --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.ahal.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.ahal.$Pop.vcf\
	 --hardy --out $work_folder/$Pop/Akm.ahal.$Pop.hardy
	perl $script_folder/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.ahal.$Pop.hardy.hwe > $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.ahal.ExcessHe.list.txt

	vcftools --gzvcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
	 --keep $work_folder/$Pop/$Pop.samples.list\
	 --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.alyr.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.alyr.$Pop.vcf\
	 --hardy --out $work_folder/$Pop/Akm.alyr.$Pop.hardy
	perl $script_folder/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.alyr.$Pop.hardy.hwe > $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.alyr.ExcessHe.list.txt

done < $script_folder/pop_list.txt #list of 25 populations 


cd $CURRENT_DIR


cat $vcf_folder/Akm.ahal.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.ahal.ExcessHe.unique.list.txt
cat $vcf_folder/Akm.alyr.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.alyr.ExcessHe.unique.list.txt

perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.ahal.ExcessHe.unique.list.txt | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > $vcf_folder/Akm.ahal.ExcessHe.bed
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.alyr.ExcessHe.unique.list.txt | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > $vcf_folder/Akm.alyr.ExcessHe.bed


#filtering out ExcessHe sites: SNPs on H-homeologs
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.ahal.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf > $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz

#filtering out ExcessHe sites: SNPs+Non-variants on H-homeologs
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.ahal.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.non_variant.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.non_variant.NonExcessHe.vcf > $vcf_folder/Akm.ahal.snp.non_variant.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.non_variant.NonExcessHe.vcf.gz

#filtering out ExcessHe sites: SNPs on L-homeologs
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.alyr.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf > $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz

#filtering out ExcessHe sites: SNPs+Non on L-homeologs
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.alyr.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf > $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf.gz

module unload vcftools
module unload gatk4
module unload samtools
module unload bcftools
