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
baseCommand: cufflinks

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: filipejesus/cufflinks:2.2.1

inputs:
  gtf:
    type: File
    inputBinding:
      position: 1
      prefix: -G
  output:
    type: string
    inputBinding:
      position: 2
      prefix: -o
  threads:
    type: int
    inputBinding:
      position: 3
      prefix: -p
  BiasCorrecting:
    type: File?
    inputBinding:
      position: 4
      prefix: -b
  libType:
    type: string?
    inputBinding:
      position: 5
      prefix: –library-type
  libNorm:
    type: string?
    inputBinding:
      position: 6
      prefix: –library-norm-method
  multi_read_correction:
    type: string?
    inputBinding:
      position: 7
      prefix: -u
  bam:
    type: File
    inputBinding:
      position: 8

outputs:
  cufflink_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
  gtf_out:
    type: File
    outputBinding:
      glob: $(inputs.output+"/transcripts.gtf")
