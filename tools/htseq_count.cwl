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
baseCommand: python

requirements:
  DockerRequirement:
    dockerPull: genomicpariscentre/htseq:0.11.0

inputs:
  input_script:
    type: File
    inputBinding:
      position: 1
  pairedend:
    type: string
    inputBinding:
      position: 2
      prefix: -p
  stranded:
    type: string
    inputBinding:
      position: 3
      prefix: -s
  input_format:
    type: string
    default: "bam"
    inputBinding:
      position: 4
      prefix: -f
  sorted_by:
    type: string
    inputBinding:
      position: 5
      prefix: -r
  gff:
    type: File?
    inputBinding:
      position: 6
  bam:
    type: File?
    inputBinding:
      position: 7
  outname:
    type: string?
    inputBinding:
      position: 8


outputs:
  exon_count_output:
    type: File
    outputBinding:
      glob: "*"
