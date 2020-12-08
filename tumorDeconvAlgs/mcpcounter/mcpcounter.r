#!/usr/local/bin/env Rscript --vanilla
args <- commandArgs(TRUE)
file0 <- args[1]
# file1 <- args[2]
# library("optparse")
# 
# option_list = list(
#     make_option(c("-f", "--file"), type="character", default=NULL,
#                 help="dataset file name", metavar="character"),
#     make_option(c("-o", "--out"), type="character", default="deconvoluted.tsv",
#                 help="output file name [default= %default]", metavar="character"),
#     make_option(c("-t", "--featuresType"), type="character", default="HUGO_symbols",
#                 help="type of identifiers for expression features [default= %default]", metavar="character"),
# );
# 
# opt_parser = OptionParser(option_list=option_list);
# opt = parse_args(opt_parser);
# 
# if (is.null(opt$file)){
#     print_help(opt_parser)
#     stop("At least one argument must be provided (input file)\n", call.=FALSE)
# }

library(MCPcounter)

data <- read.csv(file0, sep = "\t", row.names = 1)
mcp <- MCPcounter.estimate(data, featuresType = "HUGO_symbols")

write.table(mcp, file="deconvoluted.tsv", quote = FALSE, col.names = NA, sep = "\t")
