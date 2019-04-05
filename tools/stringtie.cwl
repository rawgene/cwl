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
baseCommand:

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/stringtie:1.3.0--hd28b015_2
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}

arguments:
 - position: -4
   valueFrom: "stringtie"
   shellQuote: False
 - position: 4
   prefix: -o
   valueFrom: $(inputs.output + "/" + inputs.output + ".gtf")

inputs:
 bam:
  type: File
  inputBinding:
   position: 1
   prefix: -eB
 threads:
  type: int
  inputBinding:
   position: 2
   prefix: -p
 gtf:
  type: File
  inputBinding:
   position: 3
   prefix: -G
 output:
  type: string

outputs:
 stringtie_out:
  type: Directory
  outputBinding:
   glob: $(inputs.output)