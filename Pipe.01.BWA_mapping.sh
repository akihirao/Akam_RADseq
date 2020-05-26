#!/bin/bash -i
#Pipe.01.BWA_mapping.sh

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

CPU=16

#foloder stored for read data as fastq.gz
source_data_folder=/zfs/Akm/data/QC_Trimmomatic_RADseq_2018-12-12

#source_data_folder=data
reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
reference_ahal=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle/Ahal_v2_2_1.fa
reference_alyr=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle/Alyr_v2_2_1.fa

module load samtools/1.10
module load bwa

while read MID_no; do

	mkdir -p bwa_out

	#input fileの名前を定義
	R1_tag="-R1.trimmed.edited.fastq.gz"
	R2_tag="-R2.trimmed.edited.fastq.gz"

	#defining labels for input/output files
	#MID_no="kamxxx"
	echo $MID_no
	ahal_lab="_ahal"
	alyr_lab="_alyr"
		
	R1_fastq_gz=$MID_no$R1_tag #input_R1 fastq.gz 
	R2_fastq_gz=$MID_no$R2_tag #input_R2 fastq.gz
	output_ahal=$MID_no$ahal_lab
	output_alyr=$MID_no$alyr_lab

	R1=$source_data_folder/$R1_fastq_gz
	R2=$source_data_folder/$R1_fastq_gz

	#setting RG: @RG\tID:AkmRAD\tSM:$MID_no\tPL:Illumina
	tag_read_group_part1="@RG\tID:"
	tag_read_group_part2="\tSM:"
	tag_read_group_part3="\tPL:Illumina"
	#careful $specific_ID
	specific_ID="AkmRAD"
	tag_read_group_ahal=$tag_read_group_part1$specific_ID$tag_read_group_part2$MID_no$ahal_lab$tag_read_group_part3
	tag_read_group_alyr=$tag_read_group_part1$specific_ID$tag_read_group_part2$MID_no$alyr_lab$tag_read_group_part3



	which bwa
	# /usr/local/bin/bwa
	# Version: 0.7.17-r1188

	# module load Tools/samtools/1.5
	which samtools
	#/usr/local/bin/samtools
	samtools --version
	#ssamtools 1.10; Using htslib 1.10

	if [ ! -e $reference_folder/Ahal_v2_2_1.fa.bwt ]; then
		bwa index $reference_folder/Ahal_v2_2_1.fa
	fi
	if [ ! -e $reference_folder/Alyr_v2_2_1.fa.bwt ]; then
		bwa index $reference_folder/Alyr_v2_2_1.fa
	fi

	mkdir -p bwa_out
	if [ ! -e bam_out/$output_ahal.bam ]; then
	  bwa mem -t $CPU -M -R $tag_read_group_ahal $reference_folder/Ahal_v2_2_1.fa $R1 $R2 | samtools view -Shb - > bwa_out/$output_ahal.pre_sorted.bam
	fi
	if [ ! -e bam_out/$output_alyr.bam ]; then
	  bwa mem -t $CPU -M -R $tag_read_group_alyr $reference_folder/Alyr_v2_2_1.fa $R1 $R2 | samtools view -Shb - > bwa_out/$output_alyr.pre_sorted.bam
	fi

	samtools sort --threads $CPU bwa_out/$output_ahal.pre_sorted.bam > bwa_out/$output_ahal.bam
	rm bwa_out/$output_ahal.pre_sorted.bam
	samtools index -@ $CPU bwa_out/$output_ahal.bam

	samtools sort --threads $CPU bwa_out/$output_alyr.pre_sorted.bam > bwa_out/$output_alyr.bam
	rm bwa_out/$output_alyr.pre_sorted.bam
	samtools index -@ $CPU bwa_out/$output_alyr.bam

	
	echo

done < $SCRIPT_DIR/MID_list.txt #list of kam_MID


module unload samtools/1.10
module unload bwa
