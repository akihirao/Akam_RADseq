#!/bin/bash
#Pipe.05.2.GenomicsDBImport_GVCF.sh
#Handling L homeologous varinats
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20v1/Akm/reanalysis/Reference
main_folder=/mnt/WD20v1/Akm/reanalysis
script_folder=$main_folder/Scripts

module load samtools/1.10
module load gatk4/4.3.0.0


cd $main_folder

input_sample_ahal=""
input_sample_alyr=""
option_lab="-V "
gvcf_folder=$main_folder/SNV_call
slash_lab="/"
ahal_gvcf_lab=".ahal.g.vcf.gz"
alyr_gvcf_lab=".alyr.g.vcf.gz"
one_space=" "


while read MID_no; do

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
	
	input_sample_ahal=$input_sample_ahal$option_lab$gvcf_folder$slash_lab$MID_no$ahal_gvcf_lab$one_space
	input_sample_alyr=$input_sample_alyr$option_lab$gvcf_folder$slash_lab$MID_no$alyr_gvcf_lab$one_space

done < $script_folder/MID_list.txt #list of kam_MID


target_ID_ahal="ahal"
target_ID_alyr="alyr"

genomicsDB_folder_ahal=genomicsDB.$target_ID_ahal
genomicsDB_folder_alyr=genomicsDB.$target_ID_alyr

DB_folder_ahal=$main_folder/$genomicsDB_folder_ahal
DB_folder_alyr=$main_folder/$genomicsDB_folder_alyr


#Prepair priori Ref_alyr.list (header list of reference fasta)
gatk GenomicsDBImport\
 $input_sample_alyr\
 --genomicsdb-workspace-path  $DB_folder_alyr\
 --intervals $script_folder/Ref_alyr.list\
 --reader-threads $no_threads


cd $CURRENT_DIR

module unload samtools/1.10
module unload gatk4/4.3.0.0

