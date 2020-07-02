#!/bin/bash
#Vcf2STRUCTURE.PGDSpider.sh
#2020,6.13


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

PGDSpider_path=/usr/local/PGDSpider_2.1.1.5
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
plink_folder=$main_folder/plink_filtering
vcf_folder=$main_folder/vcf_out
structure_folder=$main_folder/STRUCTURE_work
vcf_folder=$main_folder/vcf_out

work_folder=$structure_folder

input_vcf_head="Akm.snp.maf001.LDpruned"


mkdir -p $work_folder
cd $work_folder


cp $SCRIPT_DIR/Pop_info.txt $work_folder

plink --ped $plink_folder/$input_vcf_head.A.ped --map $plink_folder/$input_vcf_head.A.map --recode structure --out $work_folder/$input_vcf_head

head -n 1 $work_folder/$input_vcf_head.recode.strct_in  > $work_folder/$input_vcf_head.start.str
tail -n +3 $work_folder/$input_vcf_head.recode.strct_in  >> $work_folder/$input_vcf_head.start.str

perl $SCRIPT_DIR/STRUCTURE_lab_edit.pl < $work_folder/$input_vcf_head.start.str > $structure_folder/$input_vcf_head.str.edit.str

head -n 1 $structure_folder/$input_vcf_head.str.edit.str > $structure_folder/$input_vcf_head.str

tail -n +2 $structure_folder/$input_vcf_head.str.edit.str > $structure_folder/$input_vcf_head.base.str 
sort -k 2n,2 -k 1,1 $structure_folder/$input_vcf_head.base.str >> $structure_folder/$input_vcf_head.str

cd $SCRIPT_DIR
