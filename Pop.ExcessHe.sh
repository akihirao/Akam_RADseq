#!/bin/bash
#Pop.ExcessHe.sh

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

module load vcftools/0.1.15

CPU=1

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
work_folder=$vcf_folder/Pops

mkdir -p $work_folder

cd $work_folder


echo -n > $vcf_folder/Akm.ahal.ExcessHe.list.txt
echo -n > $vcf_folder/Akm.alyr.ExcessHe.list.txt


while read Pop; do

	echo $Pop
	mkdir -p $Pop
	echo -n > $work_folder/$Pop/$Pop.samples.list
	grep "${Pop}[0-9][0-9][0-9]" $SCRIPT_DIR/PopID.Code.list.txt >> $work_folder/$Pop/$Pop.samples.list

	vcftools --vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf --keep $work_folder/$Pop/$Pop.samples.list --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.ahal.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.ahal.$Pop.vcf --hardy --out $work_folder/$Pop/Akm.ahal.$Pop.hardy
	perl $SCRIPT_DIR/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.ahal.$Pop.hardy.hwe > $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.ahal.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.ahal.ExcessHe.list.txt

	vcftools --vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf --keep $work_folder/$Pop/$Pop.samples.list --recode --recode-INFO-all --stdout > $work_folder/$Pop/Akm.alyr.$Pop.vcf
	vcftools --vcf $work_folder/$Pop/Akm.alyr.$Pop.vcf --hardy --out $work_folder/$Pop/Akm.alyr.$Pop.hardy
	perl $SCRIPT_DIR/Listup_ExcessHe_locus.pl < $work_folder/$Pop/Akm.alyr.$Pop.hardy.hwe > $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt
	cat $work_folder/$Pop/Akm.alyr.$Pop.ExcessHe.list.txt >> $vcf_folder/Akm.alyr.ExcessHe.list.txt


done < $SCRIPT_DIR/pop_list.txt #list of 25 populations 


cat $vcf_folder/Akm.ahal.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.ahal.ExcessHe.unique.list.txt
cat $vcf_folder/Akm.alyr.ExcessHe.list.txt | sort | uniq > $vcf_folder/Akm.alyr.ExcessHe.unique.list.txt


cd $SCRIPT_DIR

module unload vcftools/0.1.15
