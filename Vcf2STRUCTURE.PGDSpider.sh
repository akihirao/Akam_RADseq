#!/bin/bash
#Vcf2STRUCTURE.PGDSpider.sh
#2020,6.13


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

PGDSpider_path=/usr/local/PGDSpider_2.1.1.5
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
work_folder=$main_folder/splitstree
vcf_folder=$main_folder/vcf_out
structure_folder=$main_folder/STRUCTURE_work

input_vcf_head="Akm.snp.maf001.LDpruned"


mkdir -p $work_folder
cd $work_folder


cp $SCRIPT_DIR/Pop_info.txt $work_folder

#vcf2STRUCTURE
java -Xmx1024m -Xms512m -jar $PGDSpider_path/PGDSpider2-cli.jar\
 -inputfile $vcf_folder/$input_vcf_head.vcf\
 -inputformat VCF\
 -outputfile $structure_folder/$input_vcf_head.raw.str\
 -outputformat STRUCTURE\
 -spid $SCRIPT_DIR/VCF2STRUCTURE.spid


perl $SCRIPT_DIR/STRUCTURE_lab_edit.pl < $structure_folder/$input_vcf_head.raw.str > $structure_folder/$input_vcf_head.str.edit.str

head -n 1 $structure_folder/$input_vcf_head.str.edit.str > $structure_folder/$input_vcf_head.str

tail -n +2 $structure_folder/$input_vcf_head.str.edit.str > $structure_folder/$input_vcf_head.base.str 
sort -k 2n,2 -k 1,1 $structure_folder/$input_vcf_head.base.str >> $structure_folder/$input_vcf_head.str

cd $SCRIPT_DIR
