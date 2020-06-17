#!/bin/bash
#Vcf2STRUCTURE.PGDSpider.sh
#2020,6.13


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

PGDSpider_path=/usr/local/PGDSpider_2.1.1.5
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
work_folder=$main_folder/splitstree
vcf_folder=$main_folder/vcf_out
structure_folder=$main_folder/STRUCTURE_work
#module load vcftools

mkdir -p $work_folder
cd $work_folder

cp $SCRIPT_DIR/Pop_info.txt $work_folder

#vcf2STRUCTURE
java -Xmx1024m -Xms512m -jar $PGDSpider_path/PGDSpider2-cli.jar\
 -inputfile $vcf_folder/Akm.snp.thin_10K.vcf\
 -inputformat VCF\
 -outputfile $structure_folder/Akm.snp.thin_10K.str\
 -outputformat STRUCTURE\
 -spid $SCRIPT_DIR/VCF2STRUCTURE.spid


perl $SCRIPT_DIR/STRUCTURE_lab_edit.pl < $structure_folder/Akm.snp.thin_10K.str > $structure_folder/Akm.snp.thin_10K.edit.str

head -n 1 $structure_folder/Akm.snp.thin_10K.edit.str > $structure_folder/Akm.snp.thin_10K.sort.str

tail -n +2 $structure_folder/Akm.snp.thin_10K.edit.str > $structure_folder/Akm.snp.thin_10K.base.str 
sort -k 2n,2 -k 1,1 $structure_folder/Akm.snp.thin_10K.base.str >> $structure_folder/Akm.snp.thin_10K.sort.str

cd $SCRIPT_DIR
