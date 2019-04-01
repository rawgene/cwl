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
  ShellCommandRequirement: {}
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bioconductor-ballgown:2.14.0--r351_0

arguments:
  - position: 4
    prefix: "&&"
    valueFrom: "ls"
    shellQuote: False

inputs:
  input_script:
    type: File
    inputBinding:
      position: 0
  tablemaker_output:
    type: Directory
    inputBinding:
      position: 1
      prefix: --data_dir
  metadata:
    type: File
    inputBinding:
      position: 2
      prefix: --metadata
  condition:
    type: string
    inputBinding:
      position: 3
      prefix: --condition

outputs:
  de_res:
    type: File[]
    outputBinding:
      glob: "*DGE_res.csv"
  ballgown_out:
    type: File[]
    outputBinding:
      glob: "*.csv"
