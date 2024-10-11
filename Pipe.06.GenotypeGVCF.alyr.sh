#!/bin/bash
#Pipe.06.GenotypeGVCF.sh
#by HIRAO Akira


set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20v1/Akm/reanalysis/Reference
main_folder=/mnt/WD20v1/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out

module load samtools/1.10
module load gatk4/4.3.0.0


vcf_folder="vcf_out"
cd $main_folder
mkdir -p $vcf_folder


target_ID_ahal="ahal"
target_ID_alyr="alyr"

genomicsDB_folder_ahal=genomicsDB.$target_ID_ahal
genomicsDB_folder_alyr=genomicsDB.$target_ID_alyr

DB_folder_ahal=$main_folder/$genomicsDB_folder_ahal
DB_folder_alyr=$main_folder/$genomicsDB_folder_alyr


#Genotyping for ahal
#gatk GenotypeGVCFs\
# -R $reference_folder/Ahal_v2_2_1.fa\
# -V gendb://$DB_folder_ahal\
# -O $vcf_folder/Akm.ahal.raw.vcf.gz

#Genotyping for ahal including non-variant-sites
#gatk GenotypeGVCFs\
# -R $reference_folder/Ahal_v2_2_1.fa\
# -V gendb://$DB_folder_ahal\
# --include-non-variant-sites\
# -O $vcf_folder/Akm.ahal.raw.include_non_variant.vcf.gz

#Genotyping for alyr
gatk GenotypeGVCFs\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V gendb://$DB_folder_alyr\
 -O $vcf_folder/Akm.alyr.raw.vcf.gz

#Genotyping for alyr including non-variant-sites
gatk GenotypeGVCFs\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V gendb://$DB_folder_alyr\
 --include-non-variant-sites\
 -O $vcf_folder/Akm.alyr.raw.include_non_variant.vcf.gz


cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk4/4.3.0.0

