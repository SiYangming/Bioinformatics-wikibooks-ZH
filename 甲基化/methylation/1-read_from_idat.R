library(minfi)
baseDir = "idat"
RGset = read.metharray.exp(baseDir)
MSet.raw = preprocessRaw(RGset)
MSet.norm = preprocessIllumina(RGset, bg.correct = TRUE, normalize = "controls")
B = getBeta(MSet.norm)
write.table(B,file="results/1-beta.xls",sep="\t", quote=F)
