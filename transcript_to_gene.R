#converts kallisto transcript-level TPM counts into gene-based counts
##takes two arguments
##   1) conversion table containing gene names and transcript ids
##   2) kallisto abundance input file

args <- commandArgs(trailingOnly = TRUE)
conv.table = args[1]
kallisto.table = args[2]

library(tximport);

#read in conversion table
tx2gene=read.table(conv.table,sep='\t',header=TRUE,quote='',check.names=FALSE);
txi <- tximport(args[1], type="kallisto", tx2gene=tx2gene,countsFromAbundance="lengthScaledTPM");

#output
write.table(txi$abundance, file="gene_abundance.txt", sep='\t', quote=FALSE);
write.table(txi$counts, file="gene_counts.txt", sep='\t', quote=FALSE);
write.table(txi$length, file="gene_length.txt", sep='\t', quote=FALSE);
