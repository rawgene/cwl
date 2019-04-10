suppressMessages(library("IsoformSwitchAnalyzeR"))
suppressMessages(library("rtracklayer"))
suppressMessages(library("GenomicRanges"))

args <- commandArgs(trailingOnly = TRUE)

if("--salmon_dir" %in% args){
  salmon_dir.idx <- grep("--salmon_dir", args)
  salmon_dir <- args[ salmon_dir.idx + 1]
} else {
  stop("please provide the path for the salmon directory \n")
}

if("--metadata" %in% args){
  metadata.idx <- grep("--metadata", args)
  metadata.path <- args[metadata.idx + 1]
  if(file.exists(metadata.path)){
    metadata <- read.csv(metadata.path, header = TRUE)
    colnames(metadata) <- c("sampleID","condition","libType")
    metadata <- metadata[,c("sampleID","condition")]
  } else {
    stop("file <",metadata.path,"> does not exist \n")
  }
} else {
  stop("please provide a metadata csv \n")
}

if("--gtf" %in% args){
  gtf.idx <- grep("--gtf",args)
  gtf <- args[gtf.idx+1]
} else {
  stop("please provide a gtf file \n")
}
salmonQuant <- importIsoformExpression(parentDir = salmon_dir)

gtf <- import(gtf)
if("transcript_version" %in% colnames(values(gtf))){
  print("TRUE")
  gtf <- gtf[paste0(values(gtf)$transcript_id,".",values(gtf)$transcript_version) %in% salmonQuant$counts$isoform_id]
}

export(gtf, 'exon.gtf')

comb <- combn(unique(as.character(metadata$condition)),2)
for (i in 1:ncol(comb)) {
  aSwitchList <- importRdata(
    isoformCountMatrix = salmonQuant$counts,
    isoformRepExpression = salmonQuant$abundance,
    designMatrix = metadata,
    comparisonsToMake = data.frame("condition_1"=comb[1,i],"condition_2"=comb[2,i]),
    isoformExonAnnoation = "./exon.gtf",
    showProgress = TRUE
  )
  aSwitchList <- isoformSwitchTestDEXSeq(aSwitchList, reduceToSwitchingGenes=FALSE )
  aSwitchList <- analyzeAlternativeSplicing( aSwitchList )
  res.df <- as.data.frame(aSwitchList$isoformSwitchAnalysis)
  res.df$log2foldchange <- aSwitchList$isoformFeatures$iso_log2_fold_change
  contrast <- paste0(comb[1,i], "-", comb[2,i])
  write.csv(res.df,paste0(contrast,"_DIE_res.csv"),row.names = FALSE)
  count.df <- aSwitchList$isoformRepExpression
  colnames(count.df) <- gsub("isoform_id", "name", colnames(count.df))
  write.csv(count.df,paste0(contrast,"_norm_count.csv"), row.names=FALSE)
  saveRDS(aSwitchList, paste0(contrast,".rds"))
}