#!/bin/bash
#Vcf2phy2nex.PGDSpider.sh
#2020,6.13


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

PGDSpider_path=/usr/local/PGDSpider_2.1.1.5
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
work_folder=$main_folder/splitstree
vcf_folder=$main_folder/vcf_out
#module load vcftools

mkdir -p $work_folder
cd $work_folder

#vcf2phy
java -Xmx1024m -Xms512m -jar $PGDSpider_path/PGDSpider2-cli.jar\
 -inputfile $vcf_folder/Akm.snp.thin_10K.vcf\
 -inputformat VCF\
 -outputfile Akm.snp.thin_10K.phy\
 -outputformat PHYLIP\
 -spid $SCRIPT_DIR/VCF_to_PHYLIP.spid

#phy2nex
java -Xmx1024m -Xms512m -jar $PGDSpider_path/PGDSpider2-cli.jar\
 -inputfile Akm.snp.thin_10K.phy\
 -inputformat PHYLIP\
 -outputfile Akm.snp.thin_10K.nex\
 -outputformat NEXUS\
 -spid $SCRIPT_DIR/PHYLIP_to_NEXUS.spid


cd $SCRIPT_DIR
