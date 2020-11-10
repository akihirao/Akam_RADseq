 #Make.Pi.Vcf.NonHetExcess.sh


SCRIPT_DIR=$(cd $(dirname $0) && pwd)

reference_folder=/media/walnut/cranberry/data/Akm_RAD/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/media/walnut/cranberry2/data/Akm_RAD_eagle_gatk
cd $main_folder
mkdir -p pi_work
cd pi_work

<< COMMENTOUT1

reference_folder=/zfs/Akm/data/Reference/Ahal_Alyr_v2_2_1/eagle
main_folder=/zfs/Akm/work/work_homeolog/Akm_RAD_eagle_gatk
work_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering


module load samtools/1.10
module load gatk/4.1.7.0
module load vcftools/0.1.15

cd $work_folder

COMMENTOUT1


#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"
ExcessHet_param_under="ExcessHet < ${ExcessHet_Q}"
echo $ExcessHet_param
echo $ExcessHet_param_under

#========================================================================
#H-subgenome
#gatk SelectVariants\
~/bin/gatk-4.1.7.0/gatk SelectVariants\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V $main_folder/vcf_out/Akm.ahal.nonvariable.raw.vcf.gz\
 --max-nocall-fraction 0.8\
 --exclude-filtered\
  -O Akm.ahal.nonvariable.called.vcf.gz

~/bin/gatk-4.1.7.0/gatk VariantFiltration\
 -R $reference_folder/Ahal_v2_2_1.fa\
 -V Akm.ahal.nonvariable.called.vcf.gz\
 --filter-expression "${ExcessHet_param}"\
 --filter-name "ExHet"\
 -O Akm.ahal.nonvariable.ExHet.Marked.vcf.gz

#COMMENTOUT2

gunzip -c Akm.ahal.nonvariable.ExHet.Marked.vcf.gz > Akm.ahal.nonvariable.ExHet.Marked.vcf


#ExHet siteのみのvcfを抽出
grep -E '^#|ExHet' Akm.ahal.nonvariable.ExHet.Marked.vcf > Akm.ahal.nonvariable.ExHetOver.vcf
#conversion from vcf to bed
perl $main_folder/shell_scripts/Vcf2BED_chr_start_end.pl < Akm.ahal.nonvariable.ExHetOver.vcf > Akm.ahal.nonvariable.ExHetOver.bed

#popレベルでのExHetOverのsite情報bedと統合する
cat Akm.ahal.nonvariable.ExHetOver.bed $mainf_folder/vcf_out/Akm.ahal.ExcessHe.bed > Akm.ahal.combined.ExHetOver.unsorted.bed
cat Akm.ahal.combined.ExHetOver.unsorted.bed |  tr "_" " " | sort -k 5n -k 6n | sed -e 's/Ahal v2 2 scaffold /Ahal_v2_2_scaffold_/' > Akm.ahal.combined.ExHetOver.bed


cd $SCRIPT_DIR
#module unload gatk

