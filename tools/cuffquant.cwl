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

#!usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: cuffquant

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: filipejesus/cufflinks:2.2.1

inputs:
  output:
    type: string
    inputBinding:
      position: 1
      prefix: -o
  threads:
    type: int
    inputBinding:
      position: 2
      prefix: -p
  bias_correction:
    type: File?
    inputBinding:
      position: 3
      prefix: -b
  multi_read_correct:
    type: string?
    inputBinding:
      position: 4
      prefix: -u
  libType:
    type: string?
    inputBinding:
      prefix: –library-type
      position: 5
  frag_mean_len:
    type: string?
    inputBinding:
      prefix: -m
      position: 6
  frad_sd_len:
    type: string?
    inputBinding:
      prefix: -string
      position: 7
  remove_len_correction:
    type: string?
    inputBinding:
      prefix: –no-length-correction
      position: 8
  merged_gtf:
    type: File
    inputBinding:
      position: 9
  bam:
    type: File
    inputBinding:
      position: 10

outputs:
   cuffquant_out:
    type: Directory
    outputBinding:
     glob: $(inputs.output)
   cxb:
    type: File
    outputBinding:
     glob: $(inputs.output+"/abundances.cxb")
