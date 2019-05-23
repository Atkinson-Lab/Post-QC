## !/bin/sh
### Elizabeth G. Atkinson 
### 2/22/18
## post-processing shapeit haps/sample files to be input into RFmix for cohort local ancestry inference

## Usage is sh PrepandrunRFmix.sh <data-stem> <ref-stem> <genetic-recomb-map> <ancestry-ref-map>
## the script will only consider the autosomes unless modified
## data stem is the core filename before "*chr{1-22}.haps/sample"
## shapeit2, RFMix v2, plink, and vcftools are expected to be in the path 
## GEN expected to be in the format of the hapmap recombination map
## ancestry reference map assigns reference individuals to their ancestral populations of origin, as described in the RFMix manual

##  Unpack the parameters into labelled variables
DATA=$1
REF=$2
GEN=$3
MAP=$4

#cohort data is now formatted to merge properly with the 1000G reference panel from step 1 - suffixed .QCed
#merge 1000G and cohort data
plink --bfile $REF --bmerge $DATA.QCed --make-bed --out $DATA.QCed.1kmerge

#filter merged dataset to only include well-genotyped sites present on both the cohort and 1000G platforms - 90% genotyping rate and MAF >= 0.5%
plink --bfile $DATA.QCed.1kmerge --allow-no-sex --make-bed --geno 0.1 --maf 0.005 --out $DATA.QCed.1kmerge.filt

#separate out the chromosomes for phasing
for i in {1..22}; do plink --bfile $DATA.QCed.1kmerge.filt --allow-no-sex --chr ${i} --make-bed --out $DATA.QCed.1kmerge.filt.chr${i} ;done

#then phase them with SHAPEIT2
#assuming all chroms are present in the same genetic map file linked to in initial command
for i in {1..22}; do \
shapeit --input-bed $DATA.QCed.1kmerge.filt.chr${i} -M $GEN -O $DATA.QCed.1kmerge.filt.phased.chr${i} --thread 8 ;done

##also make a list of the individuals 
cut -d' ' -f2 $DATA.fam > $DATA.indivs.txt

#convert the shapeit output into VCF format to put into RFmixv2...
for i in {1..22}; do shapeit -convert --input-haps $DATA.chr$i --output-vcf $DATA.chr${i}.vcf ;done

#make a vcf file of just the cohort individuals
for i in {1..22}; do vcftools --vcf $DATA.chr${i}.vcf --keep $DATA.indivs.txt --recode --out $DATA.cohort.chr${i} ;done

#make a vcf file of just the ref individuals, assuming they're everyone who wasn't in the cohort
for i in {1..22}; do vcftools --vcf $DATA.chr${i}.vcf --remove $DATA.indivs.txt --recode --out $DATA.ref.chr${i} ;done

#bgzip these
for i in {1..22}; do bgzip $DATA.ref.chr${i}.recode.vcf ;done
for i in {1..22}; do bgzip $DATA.cohort.chr${i}.recode.vcf ;done

#and run RFmix. Split for each chromosome separately
#the recombination map might need to be further processed to make RFMix happy depending on the format
for i in {1..22}; do \
rfmix -f $DATA.cohort.chr${i}.recode.vcf.gz -r $DATA.ref.chr${i}.recode.vcf.gz --chromosome=${i} -m $MAP -g $GEN -n 5 -e 1 --reanalyze-reference --num-threads 8 -o $DATA.rfmix.chr${i} ;done


