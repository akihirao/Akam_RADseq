#!/bin/bash
#AkmRAD_vcf_lab_edited.sh
#2020,5.22

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load vcftools/0.1.15


vcftools --gzvcf $vcf_folder/Akm.ahal.snp.DPfilterNoCall.vcf.gz\
 --remove-indv kam034_ahal\
 --remove-indv kam113_ahal\
 --remove-indv kam121_ahal\
 --remove-indv kam125_ahal\
 --remove-indv kam313_ahal\
 --remove-indv kam314_ahal\
 --remove-indv kam315_ahal\
 --remove-indv kam316_ahal\
 --remove-indv kam317_ahal\
 --remove-indv kam318_ahal\
 --remove-indv kam319_ahal\
 --remove-indv kam320_ahal\
 --remove-indv kam321_ahal\
 --remove-indv kam322_ahal\
 --remove-indv kam323_ahal\
 --remove-indv kam324_ahal\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.lab_rm.vcf
 
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.ahal.snp.lab_rm.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.lab_edit.vcf > $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp


vcftools --gzvcf $vcf_folder/Akm.alyr.snp.DPfilterNoCall.vcf.gz\
 --remove-indv kam034_ahal\
 --remove-indv kam113_ahal\
 --remove-indv kam121_ahal\
 --remove-indv kam125_ahal\
 --remove-indv kam313_ahal\
 --remove-indv kam314_ahal\
 --remove-indv kam315_ahal\
 --remove-indv kam316_ahal\
 --remove-indv kam317_ahal\
 --remove-indv kam318_ahal\
 --remove-indv kam319_ahal\
 --remove-indv kam320_ahal\
 --remove-indv kam321_ahal\
 --remove-indv kam322_ahal\
 --remove-indv kam323_ahal\
 --remove-indv kam324_ahal\
 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.lab_rm.vcf
 
perl $SCRIPT_DIR/vcf_lab_change.pl < $vcf_folder/Akm.alyr.snp.lab_rm.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.lab_edit.vcf > $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz
tabix -p vcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp


plink --file $plink_folder/Akm.ahal.snp --merge $plink_folder/Akm.alyr.snp.ped $plink_folder/Akm.alyr.snp.map --recode --out $plink_folder/Akm.snp


module unload vcftools/0.1.15
