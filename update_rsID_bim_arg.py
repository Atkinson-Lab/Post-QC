n__author__= "mlin, adapted for specific use by egatkinson"
import argparse
import numpy as np
import pandas as pd 

USAGE = """
update_rsID_bim.py --bim <PLINK bim file to update SNP ID>
                             --bed <bed file containing newest ID>
                             --format <formatting unmatched ID as chr:bp>
                             --codechr < if need to use X, Y, XY, M in bed file, default T>
                             --out <new bim file name>
"""

parser = argparse.ArgumentParser()
parser.add_argument("--bim", help = "PLINK bim file to update SNP ID")
parser.add_argument("--bed", help = "e.g. dbSNP build bed file")
parser.add_argument("-f", "--format", default = "F", help = "T or F, formatting unmatched ID as chr:bp")
parser.add_argument("-c", "--codechr", default = "T", help = "T or F")
parser.add_argument("-o", "--out", default = "out")

args=parser.parse_args()

bimfile = args.bim
bedfile = args.bed
out = file(args.out,'w')

#read in 
bim = pd.read_csv(bimfile, header=-1, sep='\s+', dtype = str)
bed = pd.read_csv(bedfile, header=-1, sep='\s+', dtype = str)

bim['chr'] = bim[0] # temporarily store original chr values
if args.codechr=='T':
    for i in range(0,bim[0].size):
        if bim[0][i]=="23":
            bim[0][i] = "X"
        if bim[0][i]=="24":
            bim[0][i] = "Y"
        if bim[0][i]=="25":
            bim[0][i] = "XY"
        if bim[0][i]=="26":
            bim[0][i] = "M"

#creating an index according to chr and bp 
##bim['position'] = pd.Series(['chr%s']*len(bim[0]) % bim[0].astype(str)).str.cat(bim[3].astype(str),sep="_")
bim['position'] = pd.Series(bim[0].astype(str)).str.cat(bim[3].astype(str), sep=":") # key in the form of chr:bp
if 'chr' in bed[0][0]:
    ##bed['position'] = pd.Series(bed[0].astype(str)).str.cat(bed[2].astype(str),sep="_")
    bed['position'] = pd.Series(bed[0].astype(str).str.lstrip('chr')).str.cat(bed[2].astype(str),sep=":")
else:
    ##bed['position'] = pd.Series(['chr%s']*len(bed[0]) % bed[0].astype(str)).str.cat(bed[2].astype(str),sep="_")
    bed['position'] = pd.Series(bed[0].astype(str)).str.cat(bed[2].astype(str),sep=":")

#building a dictionary based on index and rsID of the reference
bed_dict = dict(zip(bed['position'],bed[3]))

# a mark of indels
bim['indel'] = 'NA'
for i in range(0, bim[0].size):
    bim['indel'][i] = int((bim[4][i]=='D') | (bim[4][i]=='I') | (bim[5][i]=='D') | (bim[5][i]=='I') | (len(bim[4][i])>1) | (len(bim[5][i])>1))

#updating new rsIDs of bim
bim['new'] = [0]*len(bim[0])
bim[0]=bim['chr'] # convert back to original chr values
for i,snp in enumerate(bim['position']):
    if (args.format == 'T'):
        if bim['indel'][i] == 0: #not indel
            bim['new'][i] = bed_dict.get(snp, snp) #if not matched, return "chr:bp" as the new ID of the locus
        else: #indel renamed as 'chr:pos_indel'
            bim['new'][i] = snp + '_indel'
    else:
        if bim['indel'][i] == 0:
            bim['new'][i] = bed_dict.get(snp, bim[1][i])
        else: #indel, don't change name
            bim['new'][i] = bim[1][i]
    out.write('%s\t%s\t%s\t%s\t%s\t%s\n' % (bim[0][i],bim['new'][i],str(bim[2][i]),str(int(bim[3][i])),bim[4][i],bim[5][i]))
out.close()
