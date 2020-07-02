#!/bin/bash
#Pipe.09.FilteringExcessHePop.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load vcftools/0.1.15
module load gatk/4.1.7.0
 

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: H-homeologs
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.ahal.snp.DPfilterNoCall.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.lab_edit.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz

#Edting sample name to replace individual_ID with Pop_ID + individual_ID: L-homeologs
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.alyr.snp.DPfilterNoCall.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.lab_edit.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz


echo -n > $vcf_folder/Akm.ahal.ExcessHe.list.txt
echo -n > $vcf_folder/Akm.alyr.ExcessHe.list.txt


while read Pop; do
	
	work_folder=$vcf_folder/Pops
	mkdir -p $work_folder
	cd $work_folder

	echo $Pop
	mkdir -p $Pop
	echo -n > $work_folder/$Pop/$Pop.samples.list
	grep "${Pop}[0-9][0-9][0-9]" $SCRIPT_DIR/PopID.Code.list.txt >> $work_folder/$Pop/$Pop.samples.list

	vcftools --vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf\
	 --keep $work_folder/$Pop/$Pop.samples.list\
	 --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.ahal.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.ahal.$Pop.vcf\
	 --hardy --out $work_folder/$Pop/Akm.ahal.$Pop.hardy
	perl $SCRIPT_DIR/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.ahal.$Pop.hardy.hwe > $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.ahal.ExcessHe.list.txt

	vcftools --vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf\
	 --keep $work_folder/$Pop/$Pop.samples.list\
	 --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.alyr.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.alyr.$Pop.vcf\
	 --hardy --out $work_folder/$Pop/Akm.alyr.$Pop.hardy
	perl $SCRIPT_DIR/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.alyr.$Pop.hardy.hwe > $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.alyr.ExcessHe.list.txt

done < $SCRIPT_DIR/pop_list.txt #list of 25 populations 


cd $SCRIPT_DIR


cat $vcf_folder/Akm.ahal.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.ahal.ExcessHe.unique.list.txt
cat $vcf_folder/Akm.alyr.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.alyr.ExcessHe.unique.list.txt

perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/Akm.ahal.ExcessHe.unique.list.txt | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > $vcf_folder/Akm.ahal.ExcessHe.bed
perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/Akm.alyr.ExcessHe.unique.list.txt | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > $vcf_folder/Akm.alyr.ExcessHe.bed


#filtering out ExcessHe sites: H-homeologs
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.ahal.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf > $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz

#filtering out ExcessHe sites: L-homeologs
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --exclude-bed $vcf_folder/Akm.alyr.ExcessHe.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf > $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz


module unload vcftools/0.1.15
module unload gatk/4.1.7.0
