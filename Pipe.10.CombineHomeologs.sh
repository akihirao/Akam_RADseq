#!/bin/bash
#Pipe.10.CombineHomeologs.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load vcftools/0.1.15
module load gatk/4.1.7.0
 

#Convering from vcf to plink ped/map
vcftools --gzvcf vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp

#Convering from vcf to plink ped/map
vcftools --gzvcf vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp

#Combing H- and L- plink ped/map files
plink --file $plink_folder/Akm.ahal.snp --merge $plink_folder/Akm.alyr.snp.ped $plink_folder/Akm.alyr.snp.map --recode --out $plink_folder/Akm.snp


module unload vcftools/0.1.15
module unload gatk/4.1.7.0
