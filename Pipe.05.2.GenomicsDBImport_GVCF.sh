#!/bin/bash -i
#Pipe.05.2.GenomicsDBImport_GVCF.sh
#for L homeologs

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=4

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle

output_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/


module load samtools/1.10
module load gatk/4.1.7.0


cd $output_folder

input_sample_ahal=""
input_sample_alyr=""
option_lab="-V "
gvcf_folder="/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk/SNV_call/"
ahal_gvcf_lab=".ahal.g.vcf.gz"
alyr_gvcf_lab=".alyr.g.vcf.gz"
one_space=" "


while read MID_no; do

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
	
	input_sample_ahal=$input_sample_ahal$option_lab$gvcf_folder$MID_no$ahal_gvcf_lab$one_space
	input_sample_alyr=$input_sample_alyr$option_lab$gvcf_folder$MID_no$alyr_gvcf_lab$one_space

done < $SCRIPT_DIR/MID_list.txt #list of kam_MID


target_ID_ahal="ahal"
target_ID_alyr="alyr"

genomicsDB_folder_ahal=genomicsDB.$target_ID_ahal
genomicsDB_folder_alyr=genomicsDB.$target_ID_alyr

DB_folder_ahal=$output_folder/$genomicsDB_folder_ahal
DB_folder_alyr=$output_folder/$genomicsDB_folder_alyr

#Prepair priori Ref_alyr.list (header list of reference fasta)
gatk GenomicsDBImport \
$input_sample_alyr \
--genomicsdb-workspace-path  $DB_folder_alyr \
--intervals $SCRIPT_DIR/Ref_alyr.list \
--reader-threads $CPU

cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0

