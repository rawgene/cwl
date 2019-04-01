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

#/usr/bin/env Rscript --gff3 PATH --outname PATH

args <- commandArgs( trailingOnly=TRUE )

library(rtracklayer)

gff3.file.path <- args[ grep("--gff3", args)+1 ]
output.name <- args[ grep("--outname", args)+1 ]

test <- import(con = gff3.file.path)
export.gff2(object = test,con = output.name)