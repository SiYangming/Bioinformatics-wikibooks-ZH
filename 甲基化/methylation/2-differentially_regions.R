# 清空环境
rm(list = ls())

library(minfi)
library(impute)
library(wateRmelon)

info <- read.csv("group.csv")
rt <- read.csv("data.csv", row.names=1, blank.lines.skip = FALSE)
mat <- as.matrix(rt)
mat <- impute.knn(mat)
matData <- mat$data
matData <- matData+0.00001

###### normalization
matData <- matData[rowMeans(matData)>0.005,]
pdf(file="figures/2_1-rawBox.pdf")
boxplot(matData,col = "blue",xaxt = "n",outline = FALSE)
dev.off()
matData <- betaqn(matData)
pdf(file="figures/2_2-normalBox.pdf")
boxplot(matData,col = "red",xaxt = "n",outline = FALSE)
dev.off()
write.csv(matData,file="results/2_1-norm.csv", quote = FALSE)
grset <- makeGenomicRatioSetFromMatrix(matData, what = "Beta")

###### QC
pdf(file = "figures/2_3-densityBeanPlot.pdf")
par(oma = c(2,10,2,2))
densityBeanPlot(matData, sampGroups = info$Group, sampNames = info$Sample)
dev.off()

pdf(file="figures/2_4-mdsPlot.pdf")
mdsPlot(matData, numPositions = 1000, sampGroups = info$Group, sampNames = info$Sample)
dev.off()

###### Finding differentially methylated positions (DMPs)
M <- getM(grset)
dmp <- dmpFinder(M, pheno=info$Group, type="categorical")
dmpDiff <- dmp[(dmp$qval<0.05) & (is.na(dmp$qval)==F),]
write.csv(dmpDiff,file="results/2_2-dmpDiff.csv", quote = FALSE)

###### heatmap
diffM <- M[rownames(dmpDiff),]
hmExp <- diffM
library(gplots)
hmMat <- as.matrix(hmExp)
pdf(file="figures/2_5-heatmap.pdf",height=150,width=30)
par(oma=c(3,3,3,5))
heatmap.2(hmMat,col='greenred',trace="none",cexCol=1)
dev.off()

######differentially regions
class <- info$Group
designMatrix <- model.matrix(~factor(class))
colnames(designMatrix) <- c("T","C")
dmrs <- bumphunter(grset, design = designMatrix, cutoff = 0.2, B=10, type="Beta")
write.csv(dmrs$table,file="results/2_3-dmrs.csv", row.names = FALSE, quote=FALSE)
