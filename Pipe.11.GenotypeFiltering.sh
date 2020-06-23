#!/bin/bash
#Pipe.11.GenotypeFiltering.sh
#by HIRAO Akira

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

module load vcftools/0.1.15
module load samtools/1.10
module load gatk/4.1.7.0

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
plink_folder=$main_folder/plink_filtering
vcf_folder=$main_folder/vcf_out

Akm_lab="Akm"
snp_lab="snp"
lab_01="01"
lab_02="02"
lab_03="03"
lab_04="04"
lab_05="05"
lab_06="06"
lab_06maf0005="06maf0005"
lab_06maf001="06maf001"
lab_06maf0005A="06maf0005A"
lab_06maf001A="06maf001A"

cd $plink_folder

initial_input=$Akm_lab.$snp_lab
output=$Akm_lab

#mind 0.99 geno 0.99: removing >99% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$initial_input --mind 0.99 --geno 0.99 --allow-no-sex --out $plink_folder/$output.$lab_01 --recode

#mind 0.95 geno 0.95: removing >95% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_01 --mind 0.95 --geno 0.95 --allow-no-sex --out $plink_folder/$output.$lab_02 --recode

#mind 0.9 geno 0.9: removing >90% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_02 --mind 0.9 --geno 0.9 --allow-no-sex --out $plink_folder/$output.$lab_03 --recode

#mind 0.8 geno 0.8: removing >80% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_03 --mind 0.8 --geno 0.8 --allow-no-sex --out $plink_folder/$output.$lab_04 --recode

#mind 0.7 geno 0.7: removing >70% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_04 --mind 0.7 --geno 0.7 --allow-no-sex --out $plink_folder/$output.$lab_05 --recode

#mind 0.6 geno 0.6: removing >60% missing individuals and/or sites
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_05 --mind 0.6 --geno 0.6 --allow-no-sex --out $plink_folder/$output.$lab_06 --recode


perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$output.$lab_06.map > $plink_folder/$output.$lab_06.bed
perl $SCRIPT_DIR/BED.Select.Ahal.pl < $plink_folder/$output.$lab_06.bed | sort -n -t "_" -k 5 -k 2,2  > $plink_folder/$output.ahal.$lab_06.bed
perl $SCRIPT_DIR/BED.Select.Alyr.pl < $plink_folder/$output.$lab_06.bed | sort -n -t "_" -k 5 -k 2,2  > $plink_folder/$output.alyr.$lab_06.bed

#extracting ID from final.ped
perl $SCRIPT_DIR/Select_ID_PED.pl < $plink_folder/$output.$lab_06.ped > $SCRIPT_DIR/Akm.$lab_06.indiv.args


#--------------------------------------------------------------------------------------------------------------------
#set filtered data without considering linkage disequribrium and minor alleles: H-subgenome
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.ahal.06.bed\
 -O $vcf_folder/Akm.ahal.snp.filter06.vcf

#filtering out MAF < 0.01: H-subgenome
vcftools --vcf $vcf_folder/Akm.ahal.snp.filter06.vcf --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.maf001.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.maf001.vcf > $vcf_folder/Akm.ahal.snp.maf001.vcf.gz
tabix -p $vcf_folder/Akm.ahal.snp.maf001.vcf.gz

#Convering from vcf to plink ped/map
vcftools --vcf $vcf_folder/Akm.ahal.snp.maf001.vcf\
 --plink --out $plink_folder/Akm.ahal.06maf001

#LD-pruning: H-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.ahal.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.ahal.snp.maf001

#convert from LD-prune.in to BED: H-subgenome
perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/Akm.ahal.snp.maf001.prune.in > $plink_folder/Akm.ahal.LDpruned.bed
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.ahal.LDpruned.bed\
 -O $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf

bgzip -c $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz
tabix -p $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz


#set filtered data without considering linkage disequribrium and minor alleles: L-subgenome
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.alyr.06.bed\
 -O $vcf_folder/Akm.alyr.snp.filter06.vcf

#filtering out MAF < 0.01: H-subgenome
vcftools --vcf $vcf_folder/Akm.alyr.snp.filter06.vcf --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.maf001.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.maf001.vcf > $vcf_folder/Akm.alyr.snp.maf001.vcf.gz
tabix -p $vcf_folder/Akm.alyr.snp.maf001.vcf.gz

#Convering from vcf to plink ped/map
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.maf001.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.06maf001


#LD-pruning: L-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.alyr.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.alyr.snp.maf001

#convert from LD-prune.in to BED: H-subgenome
perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/Akm.alyr.snp.maf001.prune.in > $plink_folder/Akm.alyr.LDpruned.bed
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.alyr.LDpruned.bed\
 -O $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf

bgzip -c $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz
tabix -p $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz
#--------------------------------------------------------------------------------------------------------------------

#Combing H- and L- plink ped/map files 06maf001
plink --file $plink_folder/Akm.ahal.06maf001 --merge $plink_folder/Akm.alyr.06maf001.ped $plink_folder/Akm.alyr.06maf001.map --recode --out $plink_folder/Akm.06.maf001

vcf-concat $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz > $vcf_folder/Akm.snp.maf001.LDpruned.vcf
bgzip -c $vcf_folder/Akm.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz
tabix -p vcf $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz\
 --plink --out $plink_folder/Akm.snp.maf001.LDpruned

#modification of FID in plink pedmap (Popxxx -> Pop)
perl $SCRIPT_DIR/PED_FID_lab_edit.pl <  $plink_folder/Akm.snp.maf001.LDpruned.ped > $plink_folder/Akm.snp.maf001.LDpruned.A.ped

#modification of plink map for converting plink raw format. Be careful to Add 1 as @ARGV
perl $SCRIPT_DIR/PlinkMAP_modified2A.pl 1 <  $plink_folder/Akm.snp.maf001.LDpruned.map > $plink_folder/Akm.snp.maf001.LDpruned.A.map

plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.snp.maf001.LDpruned.A\
 --recodeA --missing

#Calculation of genotyping rate for each of filter_xx.ped
echo $initial_input.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $initial_input.ped
echo

echo $output.$lab_01.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_01.ped
echo

echo $output.$lab_02.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_02.ped
echo

echo $output.$lab_03.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_03.ped
echo

echo $output.$lab_04.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_04.ped
echo

echo $output.$lab_05.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_05.ped
echo

echo $output.$lab_06.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_06.ped
echo

echo Akm.06.maf001.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < Akm.06.maf001.ped

echo Akm.snp.maf001.LDpruned.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < Akm.snp.maf001.LDpruned.ped


cd $SCRIPT_DIR



module unload vcftools/0.1.15
module unload samtools/1.10
module unload gatk/4.1.7.0
