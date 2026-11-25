## ----setup, include=FALSE-----------------------------------------------------
library(seqout)
knitr::opts_chunk$set(
  collapse = TRUE, comment = "#>",
  eval = requireNamespace("genevintage", quietly = TRUE)
)
example_dir <- system.file("extdata", "gene-names", package = "seqout")
read_example <- function(name, ...) {
  read.delim(file.path(example_dir, name), check.names = FALSE, ...)
}

## ----install, eval=FALSE------------------------------------------------------
# install.packages("seqout", repos = c(
#   "https://saketlab.r-universe.dev", "https://cloud.r-project.org"
# ))

## ----old-study-download, eval=FALSE-------------------------------------------
# old <- SeqoutListCounts("GSE52529") |>
#   SeqoutMatrix(sample = "GSE52529_fpkm_matrix.txt.gz")
# dim(old$X)
# head(rownames(old$X))
# 
# # automatic selection; decision recorded below
# automatic <- old |> SeqoutGeneNames()
# automatic$gene_annotation[[1]]$annotation

## ----automatic-audit, eval=FALSE----------------------------------------------
# head(SeqoutGeneReport(automatic))
# stopifnot(
#   identical(unname(old$X), unname(automatic$X)),
#   identical(rownames(automatic$X), rownames(automatic$var))
# )

## ----old-study-ranking--------------------------------------------------------
id_file <- gzfile(file.path(example_dir, "GSE52529-gene-ids.txt.gz"))
old_ids <- readLines(id_file)
close(id_file)
head(genevintage::detect_release(old_ids), 3)

## ----old-study-offline--------------------------------------------------------
old_excerpt <- as.matrix(read_example("GSE52529-excerpt.tsv.gz", row.names = 1))
gencode17 <- read_example("gencode17-excerpt.tsv.gz")
old_named <- SeqoutGeneNames(old_excerpt, mapping = gencode17)
SeqoutGeneReport(old_named)[, c("input", "name", "status")]
stopifnot(identical(as.vector(old_excerpt), as.vector(old_named)))

## ----excel-study-download, eval=FALSE-----------------------------------------
# damaged <- SeqoutListCounts("GSE101942") |>
#   SeqoutMatrix(sample = "GSE101942_IPSC_rawCounts.txt.gz")
# 
# # explicit target, not automatic
# repaired <- damaged |> SeqoutCorrectNames(species = "human", release = 116)
# report <- SeqoutGeneReport(repaired)
# report[report$status != "unchanged", c("input", "name", "status")]
# stopifnot(identical(unname(damaged$X), unname(repaired$X)))

## ----excel-study-offline------------------------------------------------------
excel_excerpt <- as.matrix(read_example("GSE101942-excerpt.tsv.gz", row.names = 1))
human116 <- read_example("ensembl116-excel.tsv.gz")
excel_fixed <- SeqoutCorrectNames(excel_excerpt, mapping = human116, quiet = TRUE)
excel_report <- SeqoutGeneReport(excel_fixed)
excel_report[
  excel_report$input %in% c("1-Mar", "9-Sep", "15-Sep", "TP53"),
  c("input", "name", "status")
]
table(excel_report$status)
stopifnot(identical(as.vector(excel_excerpt), as.vector(excel_fixed)))

## ----excel-vintages-----------------------------------------------------------
human95 <- read_example("ensembl95-excel.tsv.gz")
excel_old <- SeqoutCorrectNames(excel_excerpt, mapping = human95, quiet = TRUE)
old_report <- SeqoutGeneReport(excel_old)
show <- excel_report$input %in% c("1-Mar", "9-Sep")
data.frame(
  deposited = excel_report$input[show],
  ensembl95 = old_report$name[show],
  ensembl116 = excel_report$name[show]
)

## ----feature-column, eval=FALSE-----------------------------------------------
# repaired <- SeqoutCorrectNames(
#   rna,
#   ids = rna$var$symbol, species = "human", release = 116
# )

