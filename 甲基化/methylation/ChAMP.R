# 清空环境
rm(list = ls())

library(ChAMP, quietly = TRUE)
library(doParallel)
detectCores()

##### 从idat读取Load #####
myLoad <- champ.load("idat")
# Or you may separate about code as champ.import("idat") + champ.filter()

##### 从beta值矩阵读取 #####
myLoad <- list()
myLoad$beta <- as.matrix(read.table("results/1-beta.xls", sep = "\t", header = TRUE, row.names = 1))
myLoad$pd <- read.csv("results/pd.csv")

#CpG.GUI()
champ.QC() 
# Alternatively: 
#QC.GUI()
myNorm <- champ.norm(method = "PBC")
myDMP <- champ.DMP()
DMP.GUI()
myDMR <- champ.DMR()
DMR.GUI()
myGSEA <- champ.GSEA()

# If DataSet is Blood samples, run champ.refbase() here.
myRefbase <- champ.refbase()