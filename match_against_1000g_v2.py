__author__= "mlin"
from optparse import OptionParser
import pandas as pd 

USAGE = """
match_against_1000g.py --bim 
                             --legend <legend file >
                             --out <mid fix name>
"""

parser = OptionParser(USAGE)
parser.add_option("--bim", help = "PLINK bim file")
parser.add_option("-l", "--legend", help = "1000 genome legend", default="/vault/public/1000g/LegendFiles/autosome_1000GP_Phase3_GRCh37_combined.legend")
parser.add_option("-o", "--out", default = "NA")

(options,args)=parser.parse_args()

bimfile = options.bim
legendfile = options.legend
if(options.out=="NA"):
    out = bimfile
else:
    out = options.out

## functions ##

def StrFlip(letter):
    #flip allele to the opposite strand
    if letter =='0':
        return '0'
    elif letter=='G':
        return 'C'
    elif letter=='C':
        return 'G'
    elif letter=='T':
        return 'A'
    elif letter=='A':
        return 'T'
    else:
        return letter # D, I, other indels etc. 
    
def gFlip(gtype):
    # e.g flip A:G to T:C
    g1 = gtype.split(":")[0]
    g2 = gtype.split(":")[1]
    a1 = StrFlip(g1)
    a2 = StrFlip(g2)
    return a1 + ":" + a2 


#read in 
bim = pd.read_csv(bimfile, header=-1, sep='\s+', dtype = str)
legend = pd.read_csv(legendfile, header=0, sep='\s+', dtype = str)

#creating an index according to chr and bp, then A1 and A2 allele
bim['position'] = pd.Series(bim[0].astype(str)).str.cat(bim[3].astype(str), sep=":") # key in the form of chr:bp
bim['gtype1'] = pd.Series(bim[4].astype(str)).str.cat(bim[5].astype(str), sep=":")
bim['gtype2'] = pd.Series(bim[5].astype(str)).str.cat(bim[4].astype(str), sep=":")

legend['index'] = pd.Series(legend['chr']).str.cat(legend['position'], sep=":")
legend['gtype'] = pd.Series(legend['a0']).str.cat(legend['a1'],sep=":")

#dictionary on legend
legend_dict = dict(zip(legend['index'],legend['gtype']))

# a mark of indels
bim['indel'] = 'NA'
for i in range(0, bim[0].size):
    bim['indel'][i] = int((bim[4][i]=='D') | (bim[4][i]=='I') | (bim[5][i]=='D') | (bim[5][i]=='I')) | (len(bim['gtype1'][i])>3)

# a mark of snps to remove or flip
bim['remove'] = 0
bim['flip'] = 0



# start matching
for i,snp in enumerate(bim['position']):
    if i%1000==0:
        print "On line: ", i
    if bim['indel'][i] == 0: #not indel
        gtype = legend_dict.get(snp, 'NA') #locus not found in 1000g
        if gtype=='NA':
            bim['remove'][i]=1
        elif gtype==bim['gtype1'][i] or gtype==bim['gtype2'][i]: #match 1000g alt and ref
            continue
        elif gtype==gFlip(bim['gtype1'][i]) or gtype==gFlip(bim['gtype2'][i]): # need to flip strand to match
            bim['flip'][i]=1
        elif bim['gtype1'][i].split(":")[0]=='0' or bim['gtype1'][i].split(":")[1]=='0': # locus fixed
            bim_allele = bim['gtype1'][i].strip('0').strip(':') 
            legend_allele = gtype.split(":")
            if bim_allele in legend_allele: # fixed but match 1000g
                continue
            elif StrFlip(bim_allele) in legend_allele: # fixed but need to be flipped
                bim['flip'][i]=1
            else:
                bim['remove'][i]=1
        else:
            bim['remove'][i]=1


out_indel = file(out + ".Indel.txt", 'w')
out_remove = file(out + ".NonMatching.txt", 'w')
out_flip = file( out + ".FlipStrand.txt", 'w')

for i in range(0,bim[0].size):
    if bim['indel'][i]==1:
        out_indel.write('%s\t%s\t%s\t%s\t%s\t%s\n' % (bim[0][i], bim[1][i], bim[2][i], bim[3][i], bim[4][i], bim[5][i]))
    if bim['remove'][i]==1:
        out_remove.write('%s\t%s\t%s\t%s\t%s\t%s\n' % (bim[0][i], bim[1][i], bim[2][i], bim[3][i], bim[4][i], bim[5][i]))
    if bim['flip'][i]==1:
        out_flip.write('%s\t%s\t%s\t%s\t%s\t%s\n' % (bim[0][i], bim[1][i], bim[2][i], bim[3][i], bim[4][i], bim[5][i]))
        
out_indel.close()
out_remove.close()
out_flip.close()
