#converts kallisto transcript-level TPM counts into gene-based counts
##takes two arguments
##   1) conversion table containing gene names and transcript ids
##   2) kallisto abundance input file (hd5)

args <- commandArgs(trailingOnly = TRUE)
conv.table = args[1]
kallisto.h5 = args[2]

library(tximport);

#read in conversion table
tx2gene=read.table(conv.table, sep='\t',header=TRUE,quote='',check.names=FALSE);
txi <- tximport(kallisto.h5, type="kallisto", tx2gene=tx2gene, countsFromAbundance="lengthScaledTPM",ignoreTxVersion=T);

#create output table
out = cbind(row.names(txi$abundance),txi$abundance,txi$counts,txi$length)
rownames(out)=NULL
colnames(out)=c("gene","abundance","counts","length")

write.table(out,"gene_expression.tsv", sep='\t', quote=FALSE, row.names=F);
