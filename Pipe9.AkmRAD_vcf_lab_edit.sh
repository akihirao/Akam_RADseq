#!/bin/bash
#Pipe9.Vcf_lab_edit.sh


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load vcftools/0.1.15
 
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.ahal.snp.DPfilterNoCall.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.lab_edit.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp

 
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.alyr.snp.DPfilterNoCall.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.lab_edit.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp


plink --file $plink_folder/Akm.ahal.snp --merge $plink_folder/Akm.alyr.snp.ped $plink_folder/Akm.alyr.snp.map --recode --out $plink_folder/Akm.snp


module unload vcftools/0.1.15
