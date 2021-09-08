# 清空环境
rm(list = ls())

library(minfi)
baseDir <- "idat"
RGset <- read.metharray.exp(baseDir)
MSet.raw <- preprocessRaw(RGset)
MSet.norm <- preprocessIllumina(RGset, bg.correct = TRUE, normalize = "controls")
B <- getBeta(MSet.norm)
write.csv(B,file="results/1-beta.csv", quote = FALSE)