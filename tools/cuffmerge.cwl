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

cwlVersion: v1.0
class: CommandLineTool
baseCommand: python2

hints:
  DockerRequirement:
    dockerPull: filipejesus/cufflinks:2.2.1
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: '{"inputs": $(inputs.cufflinks_output)}'
        entryname: inputs.json

arguments:
  - position: -3
    prefix: -c
    valueFrom: |
    import json
    with open("inputs.json") as file:
      inputs = json.load(file)
    with open("assembly_GTF_list.txt", "w") as txt:
      for i in range(len(inputs["inputs"])):
        txt.write(inputs["inputs"][i]["path"]
          + "\n")
  - prefix: "&&"
    position: -2
    shellQuote: False
    valueFrom: $("cp "+ inputs.fasta.path + " " + runtime.outdir)
  - prefix: "&&"
    position: -1
    valueFrom: "cuffmerge"
  - position: 5
    valueFrom: assembly_GTF_list.txt
  - position: 4
    prefix: -s
    valueFrom: $(runtime.outdir+"/"+inputs.fasta.basename)
inputs:
  output:
    type: string
    inputBinding:
      position: 1
      prefix: -o
  gtf:
    type: File
    inputBinding:
      position: 2
      prefix: -g
  threads:
    type: int
    inputBinding:
      position: 3
      prefix: -p
  fasta:
    type: File
#    inputBinding:
#      position: 4
#      prefix: -s
  cufflinks_output:
    type: File[]

outputs:
  cuffmerge_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
  merged_gtf:
    type: File
    outputBinding:
      glob: $(inputs.output+"/merged.gtf")
