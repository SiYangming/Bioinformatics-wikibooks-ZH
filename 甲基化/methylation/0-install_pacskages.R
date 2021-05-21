bioPackages <-c( 
  "minfi", # 读取idat格式的原始数据
  "IlluminaHumanMethylation450kmanifest", # 450k注释包
  "IlluminaHumanMethylation450kanno.ilmn12.hg19",
  "impute", # 补全缺失数据
  "wateRmelon",
  "gplots"
  
  
)

##### 批量安装缺失的R包#####

lapply( bioPackages, 
        function( bioPackage ){
          if( ! bioPackage %in% rownames(installed.packages()) ){
            CRANpackages <- available.packages()
            if( bioPackage %in% rownames( CRANpackages) ){
              install.packages( bioPackage, quiet = TRUE )
            }else{
              BiocManager::install( bioPackage, suppressUpdates = FALSE, ask = FALSE)
            }
          }
        }
)
