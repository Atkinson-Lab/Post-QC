## !/bin/sh

## A script for processing cohort data files for use in LAI with 1000 genomes reference individuals
## Written by Elizabeth Atkinson. 1/23/18
#sub-scripts for some particular processing steps courtesy of Meng Lin and Chris Gignoux

## Required parameters:
## 1. Binary plink files for the cohort data in question. Will just have to put in the bed stem (not including file extension)
## 2. plink installed and on the path
## 3. R installed and on the path
## 4. python installed and on the path
## Result: A new set of binary plink files where all allele rsIDs are renamed to dbsnp144, sites are oriented to 1000 genomes, with non-matching sites, indels, duplicates, sex chromosomes, and triallelic sites removed. Output plink files will be the input DATA name suffixed with QC.

## Usage is CohortDataQC.sh <data-bed-stem>


##  Unpack the parameters into labelled variables
DATA=$1

#keep only the autosomes in the data file
module load plink2
plink --bfile $DATA --chr 1-22 --make-bed --out $DATA.auto

#cd ./output_NSS2_2
## Find and get rid of duplicate loci in the bim file
#then keep the good SNPs in the plink file

cut -f2,4 $DATA.auto.bim| uniq -f1 > $DATA.NonDupSNPs
cut -f2,4 $DATA.auto.bim| uniq -D -f1 > $DATA.DuplicateSNPs
cat $DATA.DuplicateSNPs | uniq -f1 > $DATA.FirstDup
cat $DATA.NonDupSNPs $DATA.FirstDup > $DATA.SNPstoKeep

#set up environment to run plink again
plink --bfile $DATA.auto --extract $DATA.SNPstoKeep --make-bed --out $DATA.auto.nodup


## Update SNP IDs to dbsnp 144
#PBS -S /bin/bash
#PBS -lnodes=1:ppn=16:mem64gb
#PBS -lwalltime=24:00:00

module load python
pip install --user pandas
pip install --user numpy
pip install --user argparse

python /home/atkinson/Scripts/update_rsID_bim_ega.py --bim $DATA.auto.nodup.bim --bed /home/atkinson/Scripts/snp144_snpOnly_noContig.bed --format T --codechr F --out $DATA.auto.nodup.dbsnp.bim

#copy the other files over to this name
cp $DATA.auto.nodup.bed $DATA.auto.nodup.dbsnp.bed
cp $DATA.auto.nodup.fam $DATA.auto.nodup.dbsnp.fam

#orient to 1000G
python /home/atkinson/Scripts/match_against_1000g_v2.py --bim $DATA.auto.nodup.dbsnp.bim --legend /home/atkinson/Scripts/autosome_1000GP_Phase3_GRCh37_combined.legend --out $DATA.1kg
# This script has three outputs: ##modified to be suffixed to allow for full paths to be input
# 1) [outfile].Indel.txt: a bim file of indels 
# 2) [outfile].NonMatching.txt: a bim file containing loci not found in 1000 genome, or has different coding alleles than 1000 genome (tri-allelic, for example). They should be removed.
# 3) [outfile].FlipStrand.txt: a bim file containing loci to flip. 

#combine the lists of indels and triallelic/non-matching sites into one list of bad SNPs to remove
cat $DATA.1kg.Indel.txt $DATA.1kg.NonMatching.txt > $DATA.1kg.badsites.txt

## Flip strands for flipped sites and remove non-matching loci using plink. 
module unload python
module load plink2
plink --bfile $DATA.auto.nodup.dbsnp --exclude $DATA.1kg.badsites.txt --make-bed --out $DATA.auto.nodup.dbsnp.1ksites
plink --bfile $DATA.auto.nodup.dbsnp.1ksites --flip $DATA.1kg.FlipStrand.txt --make-bed --out $DATA.auto.nodup.dbsnp.1ksites.flip

##export a warning flag if there are too many mismatched sites compared to 1000 genomes

wc -l $DATA.1kg.NonMatching.txt > nonCount
wc -l $DATA.1kg.FlipStrand.txt > flipcount
wc -l $DATA.auto.nodup.dbsnp.bim > totalsites
paste nonCount flipcount totalsites > SiteCounts

awk '{if ($1/$5 > 0.01) print "WARNING: "$1/$5*100"% of sites are problematic when compared to 1000G. This could be indicative of a different reference build or other date file incompatibility." }' SiteCounts > Warnings.out


## Find and remove A/T C/G loci
module load python
python /home/atkinson/Scripts/find_cg_at_snps.py $DATA.auto.nodup.dbsnp.1ksites.flip.bim > $DATA.ATCGsites

module unload python
module load plink2
plink --bfile $DATA.auto.nodup.dbsnp.1ksites.flip --exclude $DATA.ATCGsites --make-bed --out $DATA.QCed

#cohort data is now formatted to merge properly with the 1000G reference panel
