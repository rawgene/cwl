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

#!/usr/bin/env Rscript
args = commandArgs(T)

print(dir())
#source("https://bioconductor.org/biocLite.R")
#biocLite('pasilla')
#biocLite("DESeq")

#library(pasilla)
#datafile = system.file( "extdata/pasilla_gene_counts.tsv", package="pasilla" )

library(DESeq)

CountTable = read.table(args[1], row.names = 1)

Design = read.table(args[2], row.names = 1)

cds = newCountDataSet(CountTable, Design)

cds = estimateSizeFactors( cds )

#sizeFactors( cds )
#counts( cds, normalized=TRUE )

cds = estimateDispersions( cds )
#View(cds)

plotDispEsts( cds )
#head( fData(cds) )
#View(cds)
res = nbinomTest( cds, "untreated", "treated" )
print(res)
plotMA(res)
