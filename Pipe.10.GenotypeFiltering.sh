#!/bin/bash
#Pipe.10.GenotypeFiltering.sh
#by HIRAO Akira

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

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

#maf 0.01: removing minor alleles with p < 0.01 
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_06 --maf 0.005 --allow-no-sex --out $plink_folder/$output.$lab_06maf0005 --recode --missing
#maf 0.05: removing minor alleles with p < 0.05
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_06 --maf 0.01 --allow-no-sex --out $plink_folder/$output.$lab_06maf001 --recode --missing

#maf 0.01: removing minor alleles with p < 0.01 
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_06 --maf 0.005 --allow-no-sex --out $plink_folder/$output.$lab_06maf0005A --recodeA --missing
#maf 0.05: removing minor alleles with p < 0.05
plink --noweb --allow-extra-chr --file $plink_folder/$output.$lab_06 --maf 0.01 --allow-no-sex --out $plink_folder/$output.$lab_06maf001A --recodeA --missing


perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$output.$lab_05.map > $plink_folder/$output.$lab_05.bed
perl $SCRIPT_DIR/BED.Select.Ahal.pl < $plink_folder/$output.$lab_05.bed > $plink_folder/$output.ahal.$lab_05.bed
perl $SCRIPT_DIR/BED.Select.Alyr.pl < $plink_folder/$output.$lab_05.bed > $plink_folder/$output.alyr.$lab_05.bed

perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$output.$lab_05maf0005.map > $plink_folder/$output.$lab_05maf0005.bed
perl $SCRIPT_DIR/BED.Select.Ahal.pl < $plink_folder/$output.$lab_05maf0005.bed > $plink_folder/$output.ahal.$lab_05maf0005.bed
perl $SCRIPT_DIR/BED.Select.Alyr.pl < $plink_folder/$output.$lab_05maf0005.bed > $plink_folder/$output.alyr.$lab_05maf0005.bed

perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$output.$lab_05maf001.map > $plink_folder/$output.$lab_05maf001.bed
perl $SCRIPT_DIR/BED.Select.Ahal.pl < $plink_folder/$output.$lab_05maf001.bed > $plink_folder/$output.ahal.$lab_05maf001.bed
perl $SCRIPT_DIR/BED.Select.Alyr.pl < $plink_folder/$output.$lab_05maf001.bed > $plink_folder/$output.alyr.$lab_05maf001.bed

#extracting ID from final.ped
perl $SCRIPT_DIR/Select_ID_PED.pl < $plink_folder/$output.$lab_06.ped > $SCRIPT_DIR/Akm.$lab_06.indiv.args


gatk SelectVariants \
-R $reference_folder/Ahal_v2_2_1.fa \
-V $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz \
-L $plink_folder/Akm.ahal.05maf001.bed \
--sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args \
-O $vcf_folder/Akm.ahal.snp.final05maf001.vcf

vcftools --vcf $vcf_folder/Akm.ahal.snp.final05maf001.vcf --thin 10000 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.thin_10K.vcf
vcftools --vcf $vcf_folder/Akm.ahal.snp.thin_10K.vcf\
 --plink --out $plink_folder/Akm.ahal.snp.thin_10K


gatk SelectVariants \
-R $reference_folder/Alyr_v2_2_1.fa \
-V $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz \
-L $plink_folder/Akm.alyr.05maf001.bed \
--sample-name $SCRIPT_DIR/Akm.$lab_06.indiv.args \
-O $vcf_folder/Akm.alyr.snp.final05maf001.vcf

vcftools --vcf $vcf_folder/Akm.alyr.snp.final05maf001.vcf --thin 10000 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.thin_10K.vcf
vcftools --vcf $vcf_folder/Akm.alyr.snp.thin_10K.vcf\
 --plink --out $plink_folder/Akm.alyr.snp.thin_10K
 

plink --file $plink_folder/Akm.ahal.snp.thin_10K --merge $plink_folder/Akm.alyr.snp.thin_10K.ped $plink_folder/Akm.alyr.snp.thin_10K.map --indiv-sort 'natural'/'n' --recode --out $plink_folder/Akm.snp.thin_10K
plink --noweb --allow-extra-chr --file $plink_folder/Akm.snp.thin_10K --allow-no-sex --out $plink_folder/Akm.snp.thin_10K.A --indiv-sort 'natural'/'n' --recodeA --missing





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

echo $output.$lab_06maf0005.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_06maf0005.ped
echo

echo $output.$lab_06maf001.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < $output.$lab_06maf001.ped

echo Akm.snp.thin_10K.ped
perl $SCRIPT_DIR/Calc.GenotypingRatePed_total.pl < Akm.snp.thin_10K.ped


cd $SCRIPT_DIR



module unload vcftools/0.1.15
module unload samtools/1.10
module unload gatk/4.1.7.0
