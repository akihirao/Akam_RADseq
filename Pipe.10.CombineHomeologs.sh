#!/bin/bash
#Pipe.10.CombineHomeologs.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20/Akm/reanalysis/Reference
main_folder=/mnt/WD20/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load gatk4/4.3.0.0
module load vcftools/0.1.16



#Convering from vcf to plink ped/map: SNPs on H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp
cp  $plink_folder/Akm.ahal.snp.map $plink_folder/Akm.ahal.snp.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.ahal.snp.origin.map > $plink_folder/Akm.ahal.snp.map
no_sites_Akm_ahal=`wc -l < $plink_folder/Akm.ahal.snp.map`

#Convering from vcf to plink ped/map: SNPs+Non-variants on H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.non_variant.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp.non_variant
cp  $plink_folder/Akm.ahal.snp.non_variant.map $plink_folder/Akm.ahal.snp.non_variant.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.ahal.snp.non_variant.origin.map > $plink_folder/Akm.ahal.snp.non_variant.map
no_sites_Akm_ahal_snp_nonvariant=`wc -l < $plink_folder/Akm.ahal.snp.non_variant.map`


#Convering from vcf to plink ped/map: SNPs on L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp
cp  $plink_folder/Akm.alyr.snp.map $plink_folder/Akm.alyr.snp.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.alyr.snp.origin.map > $plink_folder/Akm.alyr.snp.map
no_sites_Akm_alyr=`wc -l < $plink_folder/Akm.alyr.snp.map`

#Convering from vcf to plink ped/map: SNPs+Non-variants on L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp.non_variant
cp  $plink_folder/Akm.alyr.snp.non_variant.map $plink_folder/Akm.alyr.snp.non_variant.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.alyr.snp.non_variant.origin.map > $plink_folder/Akm.alyr.snp.non_variant.map
no_sites_Akm_alyr_snp_nonvariant=`wc -l < $plink_folder/Akm.alyr.snp.non_variant.map`


#Combing H- and L- plink ped/map files: SNPs
plink --file $plink_folder/Akm.ahal.snp --merge $plink_folder/Akm.alyr.snp.ped $plink_folder/Akm.alyr.snp.map --recode --out $plink_folder/Akm.snp

#Combing H- and L- plink ped/map files: SNPs+Non-variants
plink --file $plink_folder/Akm.ahal.snp.non_variant --merge $plink_folder/Akm.alyr.snp.non_variant.ped $plink_folder/Akm.alyr.snp.non_variant.map --recode --out $plink_folder/Akm.snp.non_variant

module unload vcftools
module unload gatk4

