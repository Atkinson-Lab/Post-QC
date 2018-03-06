## !/bin/sh
### Elizabeth G. Atkinson 
### 2/22/18
## post-processing shapeit haps/sample files to be input into RFmix for cohort local ancestry inference

## Usage is sh PrepandrunRFmix.sh <data-stem>
## the script is assuming chromosomes have been split for phasing and are suffixed with "chr*", and will only consider the autosomes
## data stem is the core filename before "*chr{1-22}.haps/sample"

##  Unpack the parameters into labelled variables
DATA=$1

###output is in shapeit's haps/sample format. Weirdly it's putting the rsID instead of the chromosome number in for the first column (the rest of the columns look fine). I fixed this in a rather inelegant way that works but that has room for improvement. Then output to vcf format using shapeit 

awk '$1="1"' $DATA.chr1.haps > $DATA.temp.chr1.haps
cp $DATA.chr1.sample $DATA.temp.chr1.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr1 \
--output-vcf $DATA.chr1.vcf

awk '$1="2"' $DATA.chr2.haps > $DATA.temp.chr2.haps
cp $DATA.chr2.sample $DATA.temp.chr2.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr2 \
--output-vcf $DATA.chr2.vcf

awk '$1="3"' $DATA.chr3.haps > $DATA.temp.chr3.haps
cp $DATA.chr3.sample $DATA.temp.chr3.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr3 \
--output-vcf $DATA.chr3.vcf


awk '$1="4"' $DATA.chr4.haps > $DATA.temp.chr4.haps
cp $DATA.chr4.sample $DATA.temp.chr4.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr4 \
--output-vcf $DATA.chr4.vcf

awk '$1="5"' $DATA.chr5.haps > $DATA.temp.chr5.haps
cp $DATA.chr5.sample $DATA.temp.chr5.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr5 \
--output-vcf $DATA.chr5.vcf

awk '$1="6"' $DATA.chr6.haps > $DATA.temp.chr6.haps
cp $DATA.chr6.sample $DATA.temp.chr6.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr6 \
--output-vcf $DATA.chr6.vcf

awk '$1="7"' $DATA.chr7.haps > $DATA.temp.chr7.haps
cp $DATA.chr7.sample $DATA.temp.chr7.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr7 \
--output-vcf $DATA.chr7.vcf

awk '$1="8"' $DATA.chr8.haps > $DATA.temp.chr8.haps
cp $DATA.chr8.sample $DATA.temp.chr8.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr8 \
--output-vcf $DATA.chr8.vcf

awk '$1="9"' $DATA.chr9.haps > $DATA.temp.chr9.haps
cp $DATA.chr9.sample $DATA.temp.chr9.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr9 \
--output-vcf $DATA.chr9.vcf

awk '$1="10"' $DATA.chr10.haps > $DATA.temp.chr10.haps
cp $DATA.chr10.sample $DATA.temp.chr10.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr10 \
--output-vcf $DATA.chr10.vcf

awk '$1="11"' $DATA.chr11.haps > $DATA.temp.chr11.haps
cp $DATA.chr11.sample $DATA.temp.chr11.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr11 \
--output-vcf $DATA.chr11.vcf

awk '$1="12"' $DATA.chr12.haps > $DATA.temp.chr12.haps
cp $DATA.chr12.sample $DATA.temp.chr12.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr12 \
--output-vcf $DATA.chr12.vcf

awk '$1="13"' $DATA.chr13.haps > $DATA.temp.chr13.haps
cp $DATA.chr13.sample $DATA.temp.chr13.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr13 \
--output-vcf $DATA.chr13.vcf

awk '$1="14"' $DATA.chr14.haps > $DATA.temp.chr14.haps
cp $DATA.chr14.sample $DATA.temp.chr14.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr14 \
--output-vcf $DATA.chr14.vcf

awk '$1="15"' $DATA.chr15.haps > $DATA.temp.chr15.haps
cp $DATA.chr15.sample $DATA.temp.chr15.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr15 \
--output-vcf $DATA.chr15.vcf

awk '$1="16"' $DATA.chr16.haps > $DATA.temp.chr16.haps
cp $DATA.chr16.sample $DATA.temp.chr16.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr16 \
--output-vcf $DATA.chr16.vcf

awk '$1="17"' $DATA.chr17.haps > $DATA.temp.chr17.haps
cp $DATA.chr17.sample $DATA.temp.chr17.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr17 \
--output-vcf $DATA.chr17.vcf

awk '$1="18"' $DATA.chr18.haps > $DATA.temp.chr18.haps
cp $DATA.chr18.sample $DATA.temp.chr18.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr18 \
--output-vcf $DATA.chr18.vcf

awk '$1="19"' $DATA.chr19.haps > $DATA.temp.chr19.haps
cp $DATA.chr19.sample $DATA.temp.chr19.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr19 \
--output-vcf $DATA.chr19.vcf

awk '$1="20"' $DATA.chr20.haps > $DATA.temp.chr20.haps
cp $DATA.chr20.sample $DATA.temp.chr20.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr20 \
--output-vcf $DATA.chr20.vcf

awk '$1="21"' $DATA.chr21.haps > $DATA.temp.chr21.haps
cp $DATA.chr21.sample $DATA.temp.chr21.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr21 \
--output-vcf $DATA.chr21.vcf

awk '$1="22"' $DATA.chr22.haps > $DATA.temp.chr22.haps
cp $DATA.chr22.sample $DATA.temp.chr22.sample
/home/atkinson/progs/shapeit -convert \
--input-haps $DATA.temp.chr22 \
--output-vcf $DATA.chr22.vcf


###separate out the Promis individuals from the VCF again. VCFtools keeps phasing intact
#ref individuals are present here: /home/atkinson/PGC-PTSD/LAI/AdmixRef/1000G_AAref/85ancphasedRefIndivs.txt
# previous pipeline step should have made an individual ID list assuming col 2 of the plink file is the IID

module load vcftools
#make a vcf file of just the data individuals
for i in {1..22}; do vcftools --vcf $DATA.chr${i}.vcf --keep $DATA.indivs.txt --recode --out $DATA.cohort.chr${i} ;done

#make a vcf file of just the ref individuals
for i in {1..22}; do vcftools --vcf $DATA.chr${i}.vcf --keep /home/atkinson/PGC-PTSD/LAI/AdmixRef/1000G_AAref/85ancphasedRefIndivs.txt --recode --out $DATA.85anc1k.chr${i} ;done

#bgzip these
for i in {1..22}; do bgzip $DATA.85anc1k.chr${i}.recode.vcf ;done
for i in {1..22}; do bgzip $DATA.cohort.chr${i}.recode.vcf ;done

#and run RFmix
for i in {1..22}; do \
/home/atkinson/PGC-PTSD/LAI/rfmix/rfmix -f $DATA.cohort.chr${i}.recode.vcf.gz -r $DATA.85anc1k.chr${i}.recode.vcf.gz --chromosome=${i} -m /home/atkinson/PGC-PTSD/LAI/AdmixRef/1000G_AAref/85shared.map -g /home/atkinson/recombination_rates_hapmap_b37/HapMapcomb_genmap_chr${i}.txt -n 5 -e 1 --reanalyze-reference --num-threads 32 -o $DATA.rfmix.chr${i} ;done


