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
 -inputfile $vcf_folder/Akm.snp.maf001.LDpruned.vcf\
 -inputformat VCF\
 -outputfile Akm.snp.maf001.LDpruned.phy\
 -outputformat PHYLIP\
 -spid $SCRIPT_DIR/VCF2PHYLIP.spid

#phy2nex
java -Xmx1024m -Xms512m -jar $PGDSpider_path/PGDSpider2-cli.jar\
 -inputfile Akm.snp.maf001.LDpruned.phy\
 -inputformat PHYLIP\
 -outputfile Akm.snp.maf001.LDpruned.nex\
 -outputformat NEXUS\
 -spid $SCRIPT_DIR/PHYLIP2NEXUS.spid


cd $SCRIPT_DIR
