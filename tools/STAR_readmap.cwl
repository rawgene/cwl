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
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: quay.io/biocontainers/star:2.6.0c--0

arguments:
  - position: 1
    valueFrom: "mkdir"
  - position: 2
    valueFrom: $(inputs.outFileNamePrefix)
  - position: 3
    shellQuote: False
    valueFrom: '&& cd'
  - position: 4
    valueFrom: $(inputs.outFileNamePrefix)
  - position: 5
    shellQuote: False
    valueFrom: '&& STAR'
  - position: 6
    valueFrom: "${
        if (inputs.readFilesIn[0].nameext == '.gz'){
          return '--readFilesCommand gunzip -c'}
          return '';
      }"

inputs:
  threads:
    type: int
    inputBinding:
      position: 7
      prefix: --runThreadN
  genomeDir:
    type: Directory
    inputBinding:
      position: 8
      prefix: --genomeDir
  readFilesIn:
    type: File[]
    inputBinding:
      position: 9
      prefix: --readFilesIn
  outFileNamePrefix:
    type: string
    inputBinding:
      position: 10
      prefix: --outFileNamePrefix
  XSTag:
    type: string?
    default: intronMotif
    inputBinding:
      position: 11
      prefix: --outSAMstrandField

outputs:
  star_read_out:
    type: Directory
    outputBinding:
      glob: $(inputs.outFileNamePrefix)

  sam_output:
    type: File
    outputBinding:
      glob: $(inputs.outFileNamePrefix + "/*.sam")
