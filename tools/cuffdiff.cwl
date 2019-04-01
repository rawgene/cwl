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
baseCommand: mkdir

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: filipejesus/cufflinks:2.2.1

arguments:
  - position: -4
    valueFrom: $(inputs.output)
  - position: -3
    prefix: "&&"
    valueFrom: "cuffdiff"
    shellQuote: false
  - prefix: "&&"
    position: 14
    valueFrom: "python"
    shellQuote: false
  - position : 16
    valueFrom: $(inputs.output +"/gene_exp.diff")
    shellQuote: false

inputs:
  input_script:
    type: File
    inputBinding:
      position: 15
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
  label:
    type: string[]
    inputBinding:
      position: 3
      itemSeparator: ","
      prefix: -L
  use_all:
    type: string?
    inputBinding:
      position: 4
      prefix: --total-hits-norm
  compatible_only:
    type: string?
    inputBinding:
      position: 5
      prefix: --compatible-hits-norm
  bias_correction:
    type: File?
    inputBinding:
      position: 6
      prefix: -b
  multi_read_correct:
    type: string?
    inputBinding:
      position: 7
      prefix: -u
  FDR:
    type: string
    inputBinding:
      position: 8
      prefix: --FDR
  libType:
    type: string?
    inputBinding:
      position: 9
      prefix: --library-type
  libNorm:
    type: string?
    inputBinding:
      position: 10
      prefix: --library-norm-method
  merged_gtf:
    type: File
    inputBinding:
      position: 11
  condition1_files:
    type: File[]
    inputBinding:
      itemSeparator: ","
      separate: false
      position: 12
      prefix: ""
  condition2_files:
    type: File[]
    inputBinding:
      itemSeparator: ","
      separate: false
      position: 13
      prefix: ""

outputs:
  cuffdiff_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
  de_res:
    type: File[]
    outputBinding:
      glob: "*/*_DGE_res.csv"
