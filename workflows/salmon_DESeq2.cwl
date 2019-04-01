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
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  threads: int
  salmon_index: Directory
  annotation: File
  subject_name1: string
  subject_name2: string
  subject_name3: string
  subject_name4: string
  fastq1: File[]
  fastq2: File[]
  fastq3: File[]
  fastq4: File[]
  salmon_count_script: File
  DESeq2_script: File
  metadata: File

outputs:
  salmon_quant_out:
    type: Directory
    outputSource: salmon_quant_folder/out
  salmon_count_out:
    type: Directory
    outputSource: salmon_count_folder/out
  DESeq2_out:
    type: Directory
    outputSource: DESeq2_folder/out
steps:
  salmon_quant_1:
    run: ../tools/salmon_quant.cwl
    in:
      index_directory: salmon_index
      output: subject_name1
      threads: threads
      first_end_fastq:
        source: [fastq1]
        valueFrom: $(self[0])
      second_end_fastq:
        source: [fastq1]
        valueFrom: $(self[1])
    out: [salmon_out]

  salmon_quant_2:
    run: ../tools/salmon_quant.cwl
    in:
      index_directory: salmon_index
      output: subject_name2
      threads: threads
      first_end_fastq:
        source: [fastq2]
        valueFrom: $(self[0])
      second_end_fastq:
        source: [fastq2]
        valueFrom: $(self[1])
    out: [salmon_out]

  salmon_quant_3:
    run: ../tools/salmon_quant.cwl
    in:
      index_directory: salmon_index
      output: subject_name3
      threads: threads
      single_fastq: fastq3
    out: [salmon_out]

  salmon_quant_4:
    run: ../tools/salmon_quant.cwl
    in:
      index_directory: salmon_index
      output: subject_name4
      threads: threads
      single_fastq: fastq4
    out: [salmon_out]

  salmon_quant_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item:
      - salmon_quant_1/salmon_out
      - salmon_quant_2/salmon_out
      - salmon_quant_3/salmon_out
      - salmon_quant_4/salmon_out
      name:
        valueFrom: "salmon_quant"
    out: [out]

  salmon_count:
    run: ../tools/salmon_count.cwl
    in:
      input_script: salmon_count_script
      gtf: annotation
      metadata: metadata
      quant_results: salmon_quant_folder/out
    out: [gene_count_output, gene_length_output, gene_abundance_output]

  salmon_count_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item:
      - salmon_count/gene_count_output
      - salmon_count/gene_length_output
      - salmon_count/gene_abundance_output
      name:
        valueFrom: "salmon_count"
    out: [out]

  DESeq2:
    run: ../tools/DESeq2.cwl
    in:
      input_script: DESeq2_script
      count_matrix: salmon_count/gene_count_output
      metadata: metadata
    out: [DESeq2_out]

  DESeq2_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item: DESeq2/DESeq2_out
      name:
        valueFrom: "DESeq2"
    out: [out]
