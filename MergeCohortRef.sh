## !/bin/sh

## Merge processed cohort data files with reference files
## Written by Elizabeth Atkinson. 1/23/18

## Input data should be fully QCed (have run CohortData QC.sh already) and be in plink binary format. Input only the stem of the name, no suffix
## Usage: MergeCohort1000G.sh <QCed plink file stem> <reference panel binary plink file stem>
# the 1000 genomes reference file of >= 85% Native American ancestry individuals is here: /home/atkinson/PGC-PTSD/LAI/AdmixRef/1000G_AAref/85anc/SNPsonly/1000G_85ancAdmixRef_snps_auto1
DATA=$1
REF=$2

module load plink2
plink --bfile $REF --bmerge $DATA --make-bed --out $DATA.1kmerge

###some of these are just strand errors. Try flipping and then attempt the merge again. 
plink --bfile $DATA --flip $DATA.1kmerge-merge.missnp --make-bed --out $DATA1
plink --bfile $REF --bmerge $DATA1 --make-bed --out $DATA1.1kmerge

#exclude any sites that are still being fussy
plink --bfile  $DATA1 --exclude $DATA1.1kmerge-merge.missnp --make-bed --out $DATA2

##merge this with 1000G reference file
plink --bfile $REF --bmerge $DATA2 --make-bed --out $DATA2.1kmerge

##filter merged file to include only well-genotyped sites present on both platforms. Filtering for at least 90% genotype rate and MAF >=0.5%
plink --bfile $DATA2.1kmerge --make-bed --geno 0.1 --maf 0.005 --out $DATA.1kmerge.filt
##this is the final merged data file that can be used in downstream processing
