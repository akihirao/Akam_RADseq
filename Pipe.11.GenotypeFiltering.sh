#!/bin/bash
#Pipe.11.GenotypeFiltering.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24

reference_folder=/mnt/WD20/Akm/reanalysis/Reference
main_folder=/mnt/WD20/Akm/reanalysis
script_folder=$main_folder/Scripts
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load samtools/1.10
module load gatk4/4.3.0.0
module load vcftools/0.1.16
module load bcftools/1.16


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
plink --threads $no_threads -noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp --mind 0.99 --geno 0.99 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_01 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_01.ped > $plink_folder/$Akm_lab.snp.$lab_01.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant --geno 0.99 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_01.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_01 --recode

#mind 0.95 geno 0.95: removing >95% missing individuals and/or sites
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp.$lab_01 --mind 0.95 --geno 0.95 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_02 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_02.ped > $plink_folder/$Akm_lab.snp.$lab_02.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant.$lab_01 --geno 0.95 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_02.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_02 --recode

#mind 0.9 geno 0.9: removing >90% missing individuals and/or sites
plink --threads $no_threads -noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp.$lab_02 --mind 0.9 --geno 0.9 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_03 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_03.ped > $plink_folder/$Akm_lab.snp.$lab_03.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant.$lab_02 --geno 0.9 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_03.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_03 --recode

#mind 0.8 geno 0.8: removing >80% missing individuals and/or sites
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp.$lab_03 --mind 0.8 --geno 0.8 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_04 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_04.ped > $plink_folder/$Akm_lab.snp.$lab_04.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant.$lab_03 --geno 0.8 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_04.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_04 --recode

#mind 0.7 geno 0.7: removing >70% missing individuals and/or sites
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp.$lab_04 --mind 0.7 --geno 0.7 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_05 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_05.ped > $plink_folder/$Akm_lab.snp.$lab_05.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant.$lab_04 --geno 0.7 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_05.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_05 --recode

#mind 0.6 geno 0.6: removing >60% missing individuals and/or sites
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.snp.$lab_05 --mind 0.6 --geno 0.6 --allow-no-sex --out $plink_folder/$Akm_lab.snp.$lab_06 --recode
perl $script_folder/Extract_ID_list_from_PED.pl < $plink_folder/$Akm_lab.snp.$lab_06.ped > $plink_folder/$Akm_lab.snp.$lab_06.list.txt
plink --threads $no_threads --noweb --allow-extra-chr --file $plink_folder/$Akm_lab.non_variant.$lab_05 --geno 0.6 --allow-no-sex --keep $plink_folder/$Akm_lab.snp.$lab_06.list.txt --out $plink_folder/$Akm_lab.non_variant.$lab_06 --recode

perl $script_folder/PlinkMAP2BED.pl < $plink_folder/$Akm_lab.snp.$lab_06.map > $plink_folder/$Akm_lab.snp.$lab_06.bed
perl $script_folder/PlinkMAP2BED.pl < $plink_folder/$Akm_lab.non_variant.$lab_06.map > $plink_folder/$Akm_lab.non_variant.$lab_06.bed

#Conbining SNPs+Non-variants bed-files
cat $plink_folder/$Akm_lab.snp.$lab_06.bed $plink_folder/$Akm_lab.non_variant.$lab_06.bed | sort > $plink_folder/$Akm_lab.snp.non_variant.$lab_06.bed

perl $script_folder/BED.Select.Ahal.pl < $plink_folder/$Akm_lab.snp.$lab_06.bed | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > $plink_folder/$Akm_lab.ahal.snp.$lab_06.bed
perl $script_folder/BED.Select.Alyr.pl < $plink_folder/$Akm_lab.snp.$lab_06.bed  | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > $plink_folder/$Akm_lab.alyr.snp.$lab_06.bed

perl $script_folder/BED.Select.Ahal.pl < $plink_folder/$Akm_lab.snp.non_variant.$lab_06.bed | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > $plink_folder/$Akm_lab.ahal.snp.non_variant.$lab_06.bed
perl $script_folder/BED.Select.Alyr.pl < $plink_folder/$Akm_lab.snp.non_variant.$lab_06.bed  | tr 	"_" " " | sort -k 5n -k 6n  | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > $plink_folder/$Akm_lab.alyr.snp.non_variant.$lab_06.bed

#extracting ID from final.ped
perl $script_folder/Select_ID_PED.pl < $plink_folder/$Akm_lab.snp.$lab_06.ped > $script_folder/Akm.$lab_06.indiv.args


#--------------------------------------------------------------------------------------------------------------------
##Ahal homeologs
#setting SNPs samples including singleton (= filter06.ped/map): H-subgenome
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.ahal.snp.06.bed\
 -O $vcf_folder/Akm.ahal.snp.singleton.vcf.gz

#set SNPs + Non-variants samples including singleton (=filter06.ped/map): H-subgenome
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.non_variant.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.ahal.snp.non_variant.06.bed\
 -O $vcf_folder/Akm.ahal.snp.non_variant.singleton.vcf.gz


#Setting samples including singleton after thining 5000bp: H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.singleton.vcf.gz --thin 5000 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.singleton.thin.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.singleton.thin.vcf > $vcf_folder/Akm.ahal.snp.singleton.thin.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.ahal.snp.singleton.thin.vcf.gz

#...................................
#LD-pruning for including singleton: H-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.ahal.snp.singleton.vcf.gz\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.ahal.snp.singleton.LD

#convert from LD-prune.in to BED: H-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.ahal.snp.singleton.LD.prune.in > $plink_folder/Akm.ahal.snp.singleton.LDpruned.bed

gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.singleton.vcf.gz\
 -L $plink_folder/Akm.ahal.snp.singleton.LDpruned.bed\
 -O $vcf_folder/Akm.ahal.snp.singleton.LDpruned.vcf.gz

gunzip -d -f -k $vcf_folder/Akm.ahal.snp.singleton.LDpruned.vcf.gz
# To convert to SFS with using easySFS: H-subgenome
#...................................

#Setting samples excluding singleton: H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.singleton.vcf.gz --singletons --stdout > $vcf_folder/Akm.ahal.snp.filter06.singletons.txt
perl $script_folder/Singletons2BED.pl < $vcf_folder/Akm.ahal.snp.filter06.singletons.txt > $plink_folder/Akm.ahal.snp.filter06.singletons.bed

vcftools --gzvcf $vcf_folder/Akm.ahal.snp.singleton.vcf.gz --recode --recode-INFO-all --stdout --exclude-bed $plink_folder/Akm.ahal.snp.filter06.singletons.bed > $vcf_folder/Akm.ahal.snp.non_singleton.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.non_singleton.vcf > $vcf_folder/Akm.ahal.snp.non_singleton.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.ahal.snp.non_singleton.vcf.gz

#...................................
#LD-pruning for non_singleton: H-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.ahal.snp.non_singleton.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.ahal.snp.non_singleton

#convert from LD-prune.in to BED: H-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.ahal.snp.non_singleton.prune.in > $plink_folder/Akm.ahal.snp.non_singleton.LDpruned.bed

gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.non_singleton.vcf.gz\
 -L $plink_folder/Akm.ahal.snp.non_singleton.LDpruned.bed\
 -O $vcf_folder/Akm.ahal.snp.non_singleton.LDpruned.vcf.gz

gunzip -d -f -k $vcf_folder/Akm.ahal.snp.non_singleton.LDpruned.vcf.gz 
# To convert to SFS with using easySFS: H-subgenome
#...................................


#filtering out MAF < 0.01: H-subgenome
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.singleton.vcf.gz --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.ahal.snp.maf001.vcf
bgzip -c $vcf_folder/Akm.ahal.snp.maf001.vcf > $vcf_folder/Akm.ahal.snp.maf001.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.ahal.snp.maf001.vcf.gz

#Convering from vcf to plink ped/map
vcftools --vcf $vcf_folder/Akm.ahal.snp.maf001.vcf\
 --plink --out $plink_folder/Akm.ahal.06maf001

#LD-pruning: H-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.ahal.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.ahal.snp.maf001

#convert from LD-prune.in to BED: H-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.ahal.snp.maf001.prune.in > $plink_folder/Akm.ahal.LDpruned.bed
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $vcf_folder/Akm.ahal.snp.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.ahal.LDpruned.bed\
 -O $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf

bgzip -c $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz

#output H-subgenome plink ped/bed format 
#************************************************************************************
vcftools --gzvcf $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz\
 --plink --out $plink_folder/Akm.ahal.snp.maf001.LDpruned

#modification of FID in plink pedmap (Popxxx -> Pop)
perl $script_folder/PED_FID_lab_edit.pl <  $plink_folder/Akm.ahal.snp.maf001.LDpruned.ped > $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.ped

#modification of plink map for converting plink raw format. Be careful to Add 1 as @ARGV
perl $script_folder/PlinkMAP_modified2A.pl 1 <  $plink_folder/Akm.ahal.snp.maf001.LDpruned.map > $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.map

plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.ahal.snp.maf001.LDpruned.A\
 --recodeA --missing

plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.ahal.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.ahal.snp.maf001.LDpruned.A\
 --make-bed
#************************************************************************************



##Alyr homeologs
#setting SNPs samples including singleton (= filter06.ped/map): L-subgenome
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.alyr.snp.06.bed\
 -O $vcf_folder/Akm.alyr.snp.singleton.vcf.gz

#set SNPs + Non-variants samples including singleton (=filter06.ped/map): L-subgenome
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.non_variant.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.alyr.snp.non_variant.06.bed\
 -O $vcf_folder/Akm.alyr.snp.non_variant.singleton.vcf.gz


#Setting samples including singleton after thining 5000bp: L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.singleton.vcf.gz --thin 5000 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.singleton.thin.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.singleton.thin.vcf > $vcf_folder/Akm.alyr.snp.singleton.thin.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.alyr.snp.singleton.thin.vcf.gz

#...................................
#LD-pruning for including singleton: L-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.alyr.snp.singleton.vcf.gz\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.alyr.snp.singleton.LD

#convert from LD-prune.in to BED: L-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.alyr.snp.singleton.LD.prune.in > $plink_folder/Akm.alyr.snp.singleton.LDpruned.bed

gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.singleton.vcf.gz\
 -L $plink_folder/Akm.alyr.snp.singleton.LDpruned.bed\
 -O $vcf_folder/Akm.alyr.snp.singleton.LDpruned.vcf.gz

gunzip -d -f -k $vcf_folder/Akm.alyr.snp.singleton.LDpruned.vcf.gz
# To convert to SFS with using easySFS: L-subgenome
#...................................

#Setting samples excluding singleton: L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.singleton.vcf.gz --singletons --stdout > $vcf_folder/Akm.alyr.snp.filter06.singletons.txt
perl $script_folder/Singletons2BED.pl < $vcf_folder/Akm.alyr.snp.filter06.singletons.txt > $plink_folder/Akm.alyr.snp.filter06.singletons.bed

vcftools --gzvcf $vcf_folder/Akm.alyr.snp.singleton.vcf.gz --recode --recode-INFO-all --stdout --exclude-bed $plink_folder/Akm.alyr.snp.filter06.singletons.bed > $vcf_folder/Akm.alyr.snp.non_singleton.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.non_singleton.vcf > $vcf_folder/Akm.alyr.snp.non_singleton.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.alyr.snp.non_singleton.vcf.gz

#...................................
#LD-pruning for non_singleton: L-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.alyr.snp.non_singleton.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.alyr.snp.non_singleton

#convert from LD-prune.in to BED: L-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.alyr.snp.non_singleton.prune.in > $plink_folder/Akm.alyr.snp.non_singleton.LDpruned.bed

gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.non_singleton.vcf.gz\
 -L $plink_folder/Akm.alyr.snp.non_singleton.LDpruned.bed\
 -O $vcf_folder/Akm.alyr.snp.non_singleton.LDpruned.vcf.gz

gunzip -d -f -k $vcf_folder/Akm.alyr.snp.non_singleton.LDpruned.vcf.gz 
# To convert to SFS with using easySFS: L-subgenome
#...................................



#filtering out MAF < 0.01: L-subgenome
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.singleton.vcf.gz --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/Akm.alyr.snp.maf001.vcf
bgzip -c $vcf_folder/Akm.alyr.snp.maf001.vcf > $vcf_folder/Akm.alyr.snp.maf001.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.alyr.snp.maf001.vcf.gz

#Convering from vcf to plink ped/map
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.maf001.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.06maf001


#LD-pruning: L-subgenome
plink2 --allow-extra-chr\
 --vcf $vcf_folder/Akm.alyr.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/Akm.alyr.snp.maf001

#convert from LD-prune.in to BED: L-subgenome
perl $script_folder/LDpruned2BED.pl < $vcf_folder/Akm.alyr.snp.maf001.prune.in > $plink_folder/Akm.alyr.LDpruned.bed
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $vcf_folder/Akm.alyr.snp.lab_edit.vcf.gz\
 --sample-name $script_folder/Akm.$lab_06.indiv.args\
 -L $plink_folder/Akm.alyr.LDpruned.bed\
 -O $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf

bgzip -c $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz

#output L-subgenome plink ped/bed format 
#************************************************************************************
vcftools --gzvcf $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz\
 --plink --out $plink_folder/Akm.alyr.snp.maf001.LDpruned
#modification of FID in plink pedmap (Popxxx -> Pop)
perl $script_folder/PED_FID_lab_edit.pl <  $plink_folder/Akm.alyr.snp.maf001.LDpruned.ped > $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.ped
#modification of plink map for converting plink raw format. Be careful to Add 1 as @ARGV
perl $script_folder/PlinkMAP_modified2A.pl 1 <  $plink_folder/Akm.alyr.snp.maf001.LDpruned.map > $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.map
plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.alyr.snp.maf001.LDpruned.A\
 --recodeA --missing
plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.alyr.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.alyr.snp.maf001.LDpruned.A\
 --make-bed
#************************************************************************************


#--------------------------------------------------------------------------------------------------------------------

#Combing H- and L- plink ped/map files 06maf001
cd $vcf_folder

#SNPs (singleton)
vcf-concat Akm.ahal.snp.singleton.vcf.gz Akm.alyr.snp.singleton.vcf.gz > Akm.snp.singleton.vcf
bgzip -c Akm.snp.singleton.vcf > Akm.snp.singleton.vcf.gz
tabix -f -p vcf Akm.snp.singleton.vcf.gz

#SNPs (singleton) + Non-variants
vcf-concat Akm.ahal.snp.non_variant.singleton.vcf.gz Akm.alyr.snp.non_variant.singleton.vcf.gz > Akm.snp.non_variant.singleton.vcf
bgzip -c Akm.snp.non_variant.singleton.vcf > Akm.snp.non_variant.singleton.vcf.gz
tabix -f -p vcf Akm.snp.non_variant.singleton.vcf.gz

#SNPs (thin)
vcf-concat Akm.ahal.snp.singleton.thin.vcf.gz Akm.alyr.snp.singleton.thin.vcf.gz > Akm.snp.singleton.thin.vcf
bgzip -c Akm.snp.singleton.thin.vcf > Akm.snp.singleton.thin.vcf.gz
tabix -f -p vcf Akm.snp.singleton.thin.vcf.gz

#SNPs (LDpruned)
vcf-concat Akm.ahal.snp.singleton.LDpruned.vcf.gz Akm.alyr.snp.singleton.LDpruned.vcf.gz > Akm.snp.singleton.LDpruned.vcf
bgzip -c Akm.snp.singleton.LDpruned.vcf > Akm.snp.singleton.LDpruned.vcf.gz
tabix -f -p vcf Akm.snp.singleton.LDpruned.vcf.gz

vcf-concat Akm.ahal.snp.non_singleton.LDpruned.vcf.gz Akm.alyr.snp.non_singleton.LDpruned.vcf.gz > Akm.snp.non_singleton.LDpruned.vcf
bgzip -c Akm.snp.non_singleton.LDpruned.vcf > Akm.snp.non_singleton.LDpruned.vcf.gz
tabix -f -p vcf Akm.snp.non_singleton.LDpruned.vcf.gz

vcf-concat Akm.ahal.snp.maf001.LDpruned.vcf.gz Akm.alyr.snp.maf001.LDpruned.vcf.gz > Akm.snp.maf001.LDpruned.vcf
bgzip -c Akm.snp.maf001.LDpruned.vcf > Akm.snp.maf001.thin.vcf.gz
tabix -f -p vcf Akm.snp.maf001.LDpruned.vcf.gz

cd $plink_folder

plink --file $plink_folder/Akm.ahal.06maf001 --merge $plink_folder/Akm.alyr.06maf001.ped $plink_folder/Akm.alyr.06maf001.map --recode --out $plink_folder/Akm.06.maf001

vcf-concat $vcf_folder/Akm.ahal.snp.maf001.LDpruned.vcf.gz $vcf_folder/Akm.alyr.snp.maf001.LDpruned.vcf.gz > $vcf_folder/Akm.snp.maf001.LDpruned.vcf
bgzip -c $vcf_folder/Akm.snp.maf001.LDpruned.vcf > $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz
tabix -f -p vcf $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz

vcftools --gzvcf $vcf_folder/Akm.snp.maf001.LDpruned.vcf.gz\
 --plink --out $plink_folder/Akm.snp.maf001.LDpruned

#modification of FID in plink pedmap (Popxxx -> Pop)
perl $script_folder/PED_FID_lab_edit.pl <  $plink_folder/Akm.snp.maf001.LDpruned.ped > $plink_folder/Akm.snp.maf001.LDpruned.A.ped

#modification of plink map for converting plink raw format. Be careful to Add 1 as @ARGV
perl $script_folder/PlinkMAP_modified2A.pl 1 <  $plink_folder/Akm.snp.maf001.LDpruned.map > $plink_folder/Akm.snp.maf001.LDpruned.A.map

plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.snp.maf001.LDpruned.A\
 --recodeA --missing

 plink --noweb --allow-extra-chr -allow-no-sex\
 --ped $plink_folder/Akm.snp.maf001.LDpruned.A.ped\
 --map $plink_folder/Akm.snp.maf001.LDpruned.A.map\
 --out $plink_folder/Akm.snp.maf001.LDpruned.A\
 --make-bed


#conversion from map to bed (position bed)
perl $script_folder/MAP2BED.pl < Akm.snp.maf001.LDpruned.map > Akm.snp.maf001.LDpruned.map.bed

cd $CURRENT_DIR



module unload vcftools
module unload samtools
module unload gatk
