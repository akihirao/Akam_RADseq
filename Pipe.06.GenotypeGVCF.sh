#!/bin/bash -i
#Pipe.06.GenotypeGVCF.sh
#by Akira S. Hirao

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
work_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/


module load samtools/1.10
module load gatk/4.1.7.0

vcf_folder="vcf_out"
cd $work_folder
mkdir -p $vcf_folder


target_ID_ahal="ahal"
target_ID_alyr="alyr"

genomicsDB_folder_ahal=genomicsDB.$target_ID_ahal
genomicsDB_folder_alyr=genomicsDB.$target_ID_alyr

DB_folder_ahal=$work_folder/$genomicsDB_folder_ahal
DB_folder_alyr=$work_folder/$genomicsDB_folder_alyr


#Genotype for ahal
gatk GenotypeGVCFs \
-R $reference_folder/Ahal_v2_2_1.fa \
-V gendb://$DB_folder_ahal \
-O $work_folder/$vcf_folder/Akm.ahal.raw.vcf.gz


#Genotype for alyr
gatk GenotypeGVCFs \
-R $reference_folder/Alyr_v2_2_1.fa \
-V gendb://$DB_folder_alyr \
-O $work_folder/$vcf_folder/Akm.alyr.raw.vcf.gz


cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0

