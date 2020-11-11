#!/bin/bash -i
#Make.Pi.Vcf.NonHetExcess.sh
#by HIRAO Akira


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

#reference_folder=/media/walnut/cranberry/data/Akm_RAD/Reference/Ahal_Alyr_v2_2_1/eagle
#main_folder=/media/walnut/cranberry2/data/Akm_RAD_eagle_gatk
#cd $main_folder

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load samtools/1.10
module load gatk/4.1.7.0
module load vcftools/0.1.15

mkdir -p $main_folder/pi_work
cd $main_folder/pi_work


#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"
ExcessHet_param_under="ExcessHet < ${ExcessHet_Q}"
echo $ExcessHet_param
echo $ExcessHet_param_under


<< COMMENTOUT1

#========================================================================
#H-subgenome
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $main_folder/vcf_out/Akm.ahal.nonvariable.raw.vcf.gz\
 --max-nocall-fraction 0.8\
 --exclude-filtered\
  -O Akm.ahal.nonvariable.called.vcf.gz

gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.called.vcf.gz\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -O Akm.ahal.nonvariable.ExHet.Marked.vcf.gz

gunzip -c Akm.ahal.nonvariable.ExHet.Marked.vcf.gz > Akm.ahal.nonvariable.ExHet.Marked.vcf

#ExHet siteのみのvcfを抽出
grep -E '^#|ExHet' Akm.ahal.nonvariable.ExHet.Marked.vcf > Akm.ahal.nonvariable.ExHetOver.vcf
#conversion from vcf to bed
perl $SCRIPT_DIR/Vcf2BED_chr_start_end.pl < Akm.ahal.nonvariable.ExHetOver.vcf > Akm.ahal.nonvariable.ExHetOver.bed

#popレベルでのExHetOverのsite情報bedと統合する
cat Akm.ahal.nonvariable.ExHetOver.bed $mainf_folder/$vcf_folder/Akm.ahal.ExcessHe.bed > Akm.ahal.combined.ExHetOver.unsorted.bed
cat Akm.ahal.combined.ExHetOver.unsorted.bed |  tr "_" " " | sort -k 5n -k 6n | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > Akm.ahal.combined.ExHetOver.bed


#non-variable vcfからExHetOverのsiteを取り除く
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.called.vcf.gz\
 -XL Akm.ahal.combined.ExHetOver.bed\
 -O Akm.ahal.nonvariable.NoExHet.vcf.gz

#Depth Filtering (DP < 5)
gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.NoExHet.vcf.gz\
 -G-filter "DP < 5"\
 -G-filter-name "DP5"\
 -O Akm.ahal.nonvariable.NoExHet.DPfilter.vcf.gz


#Set filtered sites to no call (DP < 5)
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.NoExHet.DPfilter.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O Akm.ahal.nonvariable.NoExHet.DPNoCall.vcf.gz


#Select variants with max-nocall-fraction ()
gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.NoExHet.DPNoCall.vcf.gz\
 --max-nocall-fraction 0.70\
 --exclude-filtered\
 -O Akm.ahal.nonvariable.NoExHet.ForPi.vcf.gz

gunzip -c Akm.ahal.nonvariable.NoExHet.ForPi.vcf.gz > Akm.ahal.nonvariable.NoExHet.ForPi.vcf
#========================================================================

COMMENTOUT1


#========================================================================
#L-subgenome
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V $main_folder/vcf_out/Akm.alyr.nonvariable.raw.vcf.gz\
 --max-nocall-fraction 0.8\
 --exclude-filtered\
  -O Akm.alyr.nonvariable.called.vcf.gz

gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.nonvariable.called.vcf.gz\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -O Akm.alyr.nonvariable.ExHet.Marked.vcf.gz

gunzip -c Akm.alyr.nonvariable.ExHet.Marked.vcf.gz > Akm.alyr.nonvariable.ExHet.Marked.vcf

#ExHet siteのみのvcfを抽出
grep -E '^#|ExHet' Akm.alyr.nonvariable.ExHet.Marked.vcf > Akm.alyr.nonvariable.ExHetOver.vcf
#conversion from vcf to bed
perl $SCRIPT_DIR/Vcf2BED_chr_start_end.pl < Akm.alyr.nonvariable.ExHetOver.vcf > Akm.alyr.nonvariable.ExHetOver.bed

#popレベルでのExHetOverのsite情報bedと統合する
cat Akm.alyr.nonvariable.ExHetOver.bed $mainf_folder/$vcf_folder/Akm.alyr.ExcessHe.bed > Akm.alyr.combined.ExHetOver.unsorted.bed
cat Akm.alyr.combined.ExHetOver.unsorted.bed |  tr "_" " " | sort -k 5n -k 6n | sed -e 's/Alyr v2 2 scaffold /Alyr_v2_2_scaffold_/' > Akm.alyr.combined.ExHetOver.bed



#non-variable vcfからExHetOverのsiteを取り除く
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.nonvariable.called.vcf.gz\
 -XL Akm.alyr.combined.ExHetOver.bed\
 -O Akm.alyr.nonvariable.NoExHet.vcf.gz

#Depth Filtering (DP < 5)
gatk VariantFiltration\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.nonvariable.NoExHet.vcf.gz\
 -G-filter "DP < 5"\
 -G-filter-name "DP5"\
 -O Akm.alyr.nonvariable.NoExHet.DPfilter.vcf.gz


#Set filtered sites to no call (DP < 5)
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.nonvariable.NoExHet.DPfilter.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O Akm.alyr.nonvariable.NoExHet.DPNoCall.vcf.gz

#Select variants with max-nocall-fraction ()
gatk SelectVariants\
 -R $reference_folder/Alyr_v2_2_1.fa\
 -V Akm.alyr.nonvariable.NoExHet.DPNoCall.vcf.gz\
 --max-nocall-fraction 0.70\
 --exclude-filtered\
 -O Akm.alyr.nonvariable.NoExHet.ForPi.vcf.gz

gunzip -c Akm.alyr.nonvariable.NoExHet.ForPi.vcf.gz > Akm.alyr.nonvariable.NoExHet.ForPi.vcf
#========================================================================


cd $SCRIPT_DIR

module unload samtools/1.10
module unload gatk/4.1.7.0
module unload vcftools/0.1.15

