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

baseCommand: tablemaker

requirements:
  DockerRequirement:
    dockerPull: filipejesus/cufflinks:2.2.1

arguments:
  - position: 2
    valueFrom: "-q"
  - position: 3
    valueFrom: "-W"

inputs:
  threads:
    type: int
    inputBinding:
      position: 1
      prefix: -p
  merged_gtf:
    type: File
    inputBinding:
      position: 4
      prefix: -G
  output:
    type: string
    inputBinding:
      position: 5
      prefix: -o
  bam:
    type: File
    inputBinding:
      position: 6

outputs:
  tablemaker_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
