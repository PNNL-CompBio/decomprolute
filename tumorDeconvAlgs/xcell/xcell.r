#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
file0 <- args[1]
# file1 <- args[2]

# library("optparse")
# 
# option_list = list(
#     make_option(c("-f", "--file"), type="character", default=NULL,
#                 help="dataset file name", metavar="character"),
#     make_option(c("-s", "--signature"), type="character", default=NULL,
#                 help="signature matrix", metavar="character"),
#     make_option(c("-o", "--out"), type="character", default="deconvoluted.tsv",
#                 help="output file name [default= %default]", metavar="character"),
#     make_option(c("-p", "--pvalue"), type="character", default="deconvoluted-pvalue.tsv",
#                 help="file name for storing p-values [default= %default]", metavar="character"),
# );
# 
# opt_parser = OptionParser(option_list=option_list);
# opt = parse_args(opt_parser);
# 
# if (is.null(opt$file)){
#     print_help(opt_parser)
#     stop("At least one argument must be provided (input file)\n", call.=FALSE)
# }
# 
# if (is.null(opt$signature)) {
#     sig = opt$signature
# } else {
#     sig = read.csv(opt$signature, sep = '\t', row.names = 1)
# }


library("xCell")

df <- read.csv(file0, sep = "\t", row.names = 1)
xc <- xCellAnalysis(df, file.name = "deconvoluted.tsv")
write.table(xc, file = "deconvoluted-pvalue.tsv", quote = FALSE, col.names = NA, sep = "\t")
