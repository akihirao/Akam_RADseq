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
module load samtools/1.10
module load vcftools/0.1.16


if [ ! -e $reference_folder/Akm_v2_2_1.fa.bwt ]; then
    bwa index $reference_folder/Akm_v2_2_1.fa
fi

if [ ! -e $reference_folder/Akm_v2_2_1.dict ]; then
    gatk CreateSequenceDictionary -R $reference_folder/Akm_v2_2_1.fa -O $reference_folder/Akm_v2_2_1.dict
fi


#Checking for fasta index (samtools)
if [ ! -e $reference_folder/Akm_v2_2_1.fa.fai ]; then
    samtools faidx $reference_folder/Akm_v2_2_1.fa
fi


#Convering from vcf to plink ped/map: SNPs on H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp
cp  $plink_folder/Akm.ahal.snp.map $plink_folder/Akm.ahal.snp.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.ahal.snp.origin.map > $plink_folder/Akm.ahal.snp.map
no_sites_Akm_ahal_snp=`wc -l < $plink_folder/Akm.ahal.snp.map`

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
perl $script_folder/PlinkMAP_modified2A.pl $no_sites_Akm_ahal_snp <  $plink_folder/Akm.alyr.snp.origin.map > $plink_folder/Akm.alyr.snp.map
no_sites_Akm_alyr_snp=`wc -l < $plink_folder/Akm.alyr.snp.map`

#Convering from vcf to plink ped/map: SNPs+Non-variants on L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.non_variant.NonExcessHe.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp.non_variant
cp  $plink_folder/Akm.alyr.snp.non_variant.map $plink_folder/Akm.alyr.snp.non_variant.origin.map
perl $script_folder/PlinkMAP_modified2A.pl $no_sites_Akm_ahal_snp_nonvariant <  $plink_folder/Akm.alyr.snp.non_variant.origin.map > $plink_folder/Akm.alyr.snp.non_variant.map
no_sites_Akm_alyr_snp_nonvariant=`wc -l < $plink_folder/Akm.alyr.snp.non_variant.map`


#-----------------------
#Preparing Non-variants on H subgenome before final filtering
perl $script_folder/PlinkMAP2BED.pl < $plink_folder/Akm.ahal.snp.non_variant.map > $plink_folder/Akm.ahal.snp.non_variant.bed
perl $script_folder/BED.Select.Ahal.pl < $plink_folder/Akm.ahal.snp.non_variant.bed | tr "_" " " | sort -k 5n -k 6n | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > $plink_folder/Akm.ahal.snp.non_variant.sorted.bed

gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf.gz\
 -L $plink_folder/Akm.ahal.snp.non_variant.sorted.bed\
 -select-type NO_VARIATION\
 -O $vcf_folder/Akm.ahal.non_variant.DPfilterNoCall.NonExcessHet.vcf.gz

#Convering from vcf to plink ped/map: Non-variants on H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.non_variant.DPfilterNoCall.NonExcessHet.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.non_variant
cp  $plink_folder/Akm.ahal.non_variant.map $plink_folder/Akm.ahal.non_variant.origin.map
perl $script_folder/PlinkMAP_modified2A.pl 0 <  $plink_folder/Akm.ahal.non_variant.origin.map > $plink_folder/Akm.ahal.non_variant.map
no_sites_Akm_ahal_nonvariant=`wc -l < $plink_folder/Akm.ahal.non_variant.map`


#Preparing Non-variants on L subgenome before final filtering
perl $script_folder/PlinkMAP2BED.pl < $plink_folder/Akm.alyr.snp.non_variant.map > $plink_folder/Akm.alyr.snp.non_variant.bed
perl $script_folder/BED.Select.Alyr.pl < $plink_folder/Akm.alyr.snp.non_variant.bed | tr "_" " " | sort -k 5n -k 6n | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > $plink_folder/Akm.alyr.snp.non_variant.sorted.bed

gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf.gz\
 -L $plink_folder/Akm.alyr.snp.non_variant.sorted.bed\
 -select-type NO_VARIATION\
 -O $vcf_folder/Akm.alyr.non_variant.DPfilterNoCall.NonExcessHet.vcf.gz

#Convering from vcf to plink ped/map: Non-variants on L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.non_variant.DPfilterNoCall.NonExcessHet.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.non_variant
cp  $plink_folder/Akm.alyr.non_variant.map $plink_folder/Akm.alyr.non_variant.origin.map
perl $script_folder/PlinkMAP_modified2A.pl $no_sites_Akm_ahal_nonvariant <  $plink_folder/Akm.alyr.non_variant.origin.map > $plink_folder/Akm.alyr.non_variant.map
no_sites_Akm_alyr_nonvariant=`wc -l < $plink_folder/Akm.alyr.non_variant.map`

#-----------------------

#Combing H- and L- plink ped/map files: SNPs
plink --file $plink_folder/Akm.ahal.snp --merge $plink_folder/Akm.alyr.snp.ped $plink_folder/Akm.alyr.snp.map --recode --out $plink_folder/Akm.snp

#Combing H- and L- plink ped/map files: Non-variants
plink --file $plink_folder/Akm.ahal.non_variant --merge $plink_folder/Akm.alyr.non_variant.ped $plink_folder/Akm.alyr.non_variant.map --recode --out $plink_folder/Akm.non_variant

#Combing H- and L- plink ped/map files: SNPs+Non-variants
plink --file $plink_folder/Akm.ahal.snp.non_variant --merge $plink_folder/Akm.alyr.snp.non_variant.ped $plink_folder/Akm.alyr.snp.non_variant.map --recode --out $plink_folder/Akm.snp.non_variant

module unload vcftools
module unload samtools
module unload gatk4

