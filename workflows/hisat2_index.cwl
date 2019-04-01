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

#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  StepInputExpressionRequirement: {}

inputs:
  threads: int
  fasta: File[]
  ht2base: string
  gtf: File[]
outputs:
  ht_out:
    type: Directory
    outputSource: hisat2_build_folder/out
  log_out:
    type: File
    outputSource: hisat2_build/log
  splice_sites_out:
    type: File
    outputSource: hisat2_ss/splice_sites
  exon_out:
    type: File
    outputSource: hisat2_exon/exons
steps:
  hisat2_ss:
    run: ../tools/hisat2_ss.cwl
    in:
      gtf: gtf
    out: [splice_sites]
  hisat2_exon:
    run: ../tools/hisat2_exon.cwl
    in:
      gtf: gtf
    out: [exons]
  hisat2_build:
    run: ../tools/hisat2_build.cwl
    in:
      threads: threads
      splice_sites: hisat2_ss/splice_sites
      exon: hisat2_exon/exons
      fasta: fasta
      output: ht2base
    out: [ht, log]
  hisat2_build_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item: hisat2_build/ht
      name:
        valueFrom: "HISAT2Index"
    out: [out]