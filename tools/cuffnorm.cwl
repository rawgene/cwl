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
    valueFrom: "cuffnorm"
    shellQuote: False
  - position: 6
    prefix: "&&"
    valueFrom: $("python")
    shellQuote: False
  - position: 8
    valueFrom: $(inputs.output + "/genes.count_table")
  - position: 9
    valueFrom: $(inputs.output + "/genes.attr_table")

inputs:
  input_script:
    type: File
    inputBinding:
      position: 7
  output:
    type: string
    inputBinding:
      position: 1
      prefix: -o
  metadata:
    type: File
    inputBinding:
      position: 7
  threads:
    type: int
    inputBinding:
      position: 2
      prefix: -p
  label:
    type: string[]
    inputBinding:
      position: 10
      itemSeparator: ","
  merged_gtf:
    type: File
    inputBinding:
      position: 3
  condition1_files:
    type: File[]
    inputBinding:
      itemSeparator: ","
      separate: false
      position: 4
      prefix: ""
  condition2_files:
    type: File[]
    inputBinding:
      itemSeparator: ","
      separate: false
      position: 5
      prefix: ""

outputs:
  cuffnorm_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
