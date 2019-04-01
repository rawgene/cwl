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
baseCommand:

requirements:
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerPull: quay.io/biocontainers/hisat2:2.1.0--py27h2d50403_2
  InlineJavascriptRequirement: {}

arguments:
  - position: 1
    valueFrom: "mkdir"
  - position: 2
    valueFrom: $(inputs.output.split('.')[0])
  - position: 3
    shellQuote: False
    valueFrom: '&& cd'
  - position: 4
    valueFrom: $(inputs.output.split('.')[0])
  - position: 5
    shellQuote: False
    valueFrom: '&& hisat2'

inputs:
  input_type:
    type: string
    default: "-q"
    inputBinding:
      position: 6
  index_directory:
    type: Directory
    inputBinding:
      position: 7
      prefix: "-x"
      valueFrom: "${return inputs.index_directory.path + '/'
                  + inputs.index_directory.listing[0].nameroot.split('.').slice(0,-1).join('.')}"
  first_pair:
    type: File?
    inputBinding:
      position: 8
      prefix: "-1"
  second_pair:
    type: File?
    inputBinding:
      position: 9
      prefix: "-2"
  single_file:
    type: File[]?
    inputBinding:
      position: 10
      prefix: -U
  sra_acc:
    type: string?
    inputBinding:
      position: 11
      prefix: --sra-acc
  output:
    type: string
    inputBinding:
      position: 12
      prefix: -S
  threads:
    type: int
    inputBinding:
      position: 13
      prefix: -p
  XSTag:
    type: string?
    default: --dta-cufflinks
    inputBinding:
      position: 14
  log:
    type: string
    default: "log.txt"
    inputBinding:
      position: 15
      prefix: --summary-file

outputs:
  hisat2_align_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output.split('.')[0])

  sam_output:
    type: File
    outputBinding:
      glob: $(inputs.output.split('.')[0] + '/' + inputs.output)
