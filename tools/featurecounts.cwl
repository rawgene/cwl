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
class: CommandLineTool
baseCommand: Rscript

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: $(inputs.bam_files)
  DockerRequirement:
    dockerPull: filipejesus/featurecounts:3.8

arguments:
  - prefix: --d
    position: 1
    valueFrom: $(runtime.outdir)

inputs:
  input_script:
    type: File
    inputBinding:
      position: 0
  bam_files:
    type: File[]
  gtf:
    type: File
    inputBinding:
      position: 2
      prefix: --g
  threads:
    type: int?
    inputBinding:
      position: 3
      prefix: --p
  featuretype:
    type: string?
    inputBinding:
      position: 4
      prefix: --ft
  attribute:
    type: string?
    inputBinding:
      position: 5
      prefix: --a
  multipleoverlap:
    type: string?
    inputBinding:
      position: 6
      prefix: --mo
  multiread:
    type: string?
    inputBinding:
      position: 7
      prefix: --mm
  fraction:
    type: string?
    inputBinding:
      position: 8
      prefix: --f
  longreads:
    type: string?
    inputBinding:
      position: 9
      prefix: --lr
  stranded:
    type: string?
    inputBinding:
      position: 10
      prefix: --s
  metadata:
    type: File
    inputBinding:
      position: 11
      prefix: --metadata

outputs:
  gene_count_output:
    type: File
    outputBinding:
      glob: "gene_count_matrix.csv"
