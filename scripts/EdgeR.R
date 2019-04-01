# A collection of RNA-Seq data analysis tools wrapped in CWL scripts
# Copyright (C) 2019 Alessandro Pio Greco, Patrick Hedley-Miller, Filipe Jesus, Zeyu Yang
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Rscript EdgeR.R --condition string --counts PATH --metadata PATH
# code inspired by https://f1000research.com/articles/5-1408/v1

library(limma)
library(edgeR)
#library(dplyr)

args <- commandArgs( trailingOnly=TRUE )
args

if( "--counts" %in% args ){
  counts.idx <- grep("--counts", args)
  counts <- args[ counts.idx + 1 ]
  counts <- read.csv(counts, row.names = 1, header = TRUE)
} else {
  stop("please enter the path to the counts matrix with prefix '--counts'")
}

if( "--metadata" %in% args ){
  metadata.idx <- grep("--metadata", args)
  metadata <- args[ metadata.idx + 1 ]
  metadata <- read.csv(metadata, row.names = 1, header = TRUE)
} else {
  stop("please enter the path to the metadata with prefix '--metadata'")
}

if( "--condition" %in% args ){
  condition.idx <- grep("--condition", args)
  condition <- args[ condition.idx + 1 ]
  colnames(metadata) <- sub(condition, "condition",colnames(metadata))
}

comb <- combn(unique(metadata[,"condition"]), 2)
for(i in 1:ncol(comb)){
  metadata.f <- metadata[metadata$condition %in% comb[,i],]
  count.f <- counts[,rownames(metadata.f)]
  DGE <- DGEList(counts = count.f)
  samplenames <- colnames(DGE)
  samplenames

  group <- as.factor(metadata.f[,"condition"])
  DGE$samples$group <- group

  DGE <- calcNormFactors(DGE, method = "TMM")

  norm_count <- cpm(DGE)

  design <- model.matrix(~0+group)
  contrast <- gsub(".$","",paste0(paste0("group", unique(group)),sep="-", collapse = ""))
  contr.matrix <- makeContrasts(contrasts = contrast, levels = colnames(design))

  v <- voom(DGE, design)
  vfit <- lmFit(v, design)
  vfit <- contrasts.fit(vfit, contrasts=contr.matrix)
  efit <- eBayes(vfit)

  dge.res <- topTable(efit,sort="none",n=Inf)
  dge.res <- dge.res[,c("AveExpr", "logFC", "t", "P.Value", "adj.P.Val")]
  dge.res <- data.frame(rownames(dge.res),dge.res)
  colnames(dge.res) <- c("name","norm_basemean", "log2foldchange", "test_stat", "p_value","p_adj")
  contrast <- gsub(".$","",paste0(paste0(unique(group)),sep="-", collapse = ""))
  write.csv(dge.res, paste0(contrast,"_","DGE_res.csv"), row.names = FALSE)

  norm_count2 <- data.frame("name"=rownames(norm_count),as.data.frame(norm_count))
  write.csv(norm_count2, paste0(contrast,"_","norm_count.csv"), row.names = FALSE)
}
