## ----include = FALSE----------------------------------------------------------
seqout::SeqoutDefault(NULL)
# live API calls run only off CRAN, when online
online <- (identical(Sys.getenv("NOT_CRAN"), "true") ||
  identical(Sys.getenv("IN_PKGDOWN"), "true")) && seqout::SeqoutOnline()
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = online)

## ----install, eval = FALSE----------------------------------------------------
# # install.packages("pak")
# pak::pak("saketlab/seqout/R")

## ----setup--------------------------------------------------------------------
# library(seqout)

## ----search-------------------------------------------------------------------
# SeqoutSearch("cervical cancer single cell", db = "geo", limit = 5)

## ----cohort-------------------------------------------------------------------
# liver <- SampleSearch(
#   organism = "Homo sapiens",
#   tissue = "liver",
#   age_min_years = 50,
#   limit = 5
# )
# liver[, c("sample", "study_accession", "tissue", "disease", "sex", "age")]

## ----pipes--------------------------------------------------------------------
# # A PubMed ID or a DOI, told apart by the value, to the datasets that cite it
# "34764296" |>
#   Paper() |>
#   nrow()
# 
# list(tissue = "liver", organism = "Homo sapiens") |>
#   SampleSearch(limit = 3) |>
#   subset(select = c(sample, study_accession, disease))

## ----dataset------------------------------------------------------------------
# d <- SeqoutGet("GSE168652")
# d

## ----dataset-fields-----------------------------------------------------------
# d$meta$title
# c(samples = nrow(d$samples), runs = nrow(d$runs), papers = nrow(d$pubs))

## ----enriched-----------------------------------------------------------------
# d$enriched[, c("sample", "tissue", "disease", "assay")]

## ----counts-table-------------------------------------------------------------
# counts <- SeqoutListCounts("GSE297547")
# m <- counts
# 
# nrow(m)
# head(m[, c("unit", "sample", "format", "preferred", "has_metadata")], 4)

## ----counts-read, eval = FALSE------------------------------------------------
# rna <- SeqoutMatrix(counts, sample = "GSM8994520")
# dim(rna$X)

## ----counts-seurat, eval = FALSE----------------------------------------------
# obj <- Seqout2Seurat("GSE297547", sample = "GSM8994520", min.cells = 3, min.features = 200)

## ----gene-names-demo, eval = FALSE--------------------------------------------
# # GSE52529: original Ensembl IDs, FPKM not raw counts
# old <- SeqoutListCounts("GSE52529") |>
#   SeqoutMatrix(sample = "GSE52529_fpkm_matrix.txt.gz")
# named <- old |> SeqoutGeneNames()
# named$gene_annotation[[1]]$annotation
# 
# # GSE101942: verified Excel-damaged gene names
# damaged <- SeqoutListCounts("GSE101942") |>
#   SeqoutMatrix(sample = "GSE101942_IPSC_rawCounts.txt.gz")
# repaired <- damaged |> SeqoutCorrectNames(species = "human", release = 116)
# report <- SeqoutGeneReport(repaired)
# report[report$status != "unchanged", ]

## ----supplementary------------------------------------------------------------
# head(d$supplementary, 4)

## ----downloads, eval = FALSE--------------------------------------------------
# DownloadSupplementary("GSE168652", "GSE168652")
# DownloadRuns("SRR12012336", "SRR12012336")
# DownloadBAMs("ERP117016", "ERP117016")

## ----parquet------------------------------------------------------------------
# con <- SeqoutConnect("parquet", quiet = TRUE)
# 
# Query("SELECT count(*) AS n FROM geo_series", con = con)

## ----close--------------------------------------------------------------------
# SeqoutClose(con)

