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
  genomeDir: Directory
  annotation: File
  subject_name1: string
  subject_name2: string
  subject_name3: string
  subject_name4: string
  fastq1: File[]
  fastq2: File[]
  fastq3: File[]
  fastq4: File[]
  metadata: File
  perl_script: File
  miso_script: File
  conditions: string[]

outputs:
  star_readmap_out:
    type: Directory
    outputSource: star_folder/out
  samtools_out:
    type: Directory
    outputSource: samtools_folder/out
  miso_out:
    type: Directory
    outputSource: miso_folder/out

steps:
# STAR
  star_readmap_1:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq1
      outFileNamePrefix: subject_name1
    out: [sam_output, star_read_out]

  star_readmap_2:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq2
      outFileNamePrefix: subject_name2
    out: [sam_output, star_read_out]

  star_readmap_3:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq3
      outFileNamePrefix: subject_name3
    out: [sam_output, star_read_out]

  star_readmap_4:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq4
      outFileNamePrefix: subject_name4
    out: [sam_output, star_read_out]

  star_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item:
      - star_readmap_1/star_read_out
      - star_readmap_2/star_read_out
      - star_readmap_3/star_read_out
      - star_readmap_4/star_read_out
      name:
        valueFrom: "star"
    out: [out]

# Samtools
  samtools_1:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_1/sam_output
      threads: threads
      outfilename:
        source: [subject_name1]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_2:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_2/sam_output
      threads: threads
      outfilename:
        source: [subject_name2]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_3:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_3/sam_output
      threads: threads
      outfilename:
        source: [subject_name3]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_4:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_4/sam_output
      threads: threads
      outfilename:
        source: [subject_name4]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item:
      - samtools_1/samtools_out
      - samtools_2/samtools_out
      - samtools_3/samtools_out
      - samtools_4/samtools_out
      name:
        valueFrom: "samtools"
    out: [out]

  miso_index:
    run: ../tools/miso_index.cwl
    in:
      gtf: annotation
      output:
        valueFrom: "miso_output"
      perl_input: perl_script
    out: [miso_out]

  miso_merge1:
    run: ../tools/miso_merge.cwl
    in:
      bam:
      - samtools_1/samtools_out
      - samtools_2/samtools_out
      output: 
         valueFrom: "untreated"
    out: [miso_out]
  
  miso_merge2:
    run: ../tools/miso_merge.cwl
    in:
      bam:
      - samtools_3/samtools_out
      - samtools_4/samtools_out
      output: 
         valueFrom: "treated"
    out: [miso_out]  

  miso_run_normal:
    run: ../tools/miso_run.cwl
    in:
      input_script: miso_script
      gff: miso_index/miso_out
      bam: miso_merge1/miso_out
      lib_type: 
        valueFrom: "PE"
      min_exon_size:
        valueFrom: "50"
      output: 
        valueFrom: "normal_out"
    out: [miso_out]

  miso_run_tumour:
    run: ../tools/miso_run.cwl
    in:
      input_script: miso_script
      gff: miso_index/miso_out
      bam: miso_merge2/miso_out
      lib_type: 
        valueFrom: "SG"
      min_exon_size: 
        valueFrom: "50"
      output:
        valueFrom: "tumour_out"
    out: [miso_out]

  miso_compare:
    run: ../tools/miso_compare.cwl
    in:
      group1: miso_run_normal/miso_out
      group2: miso_run_tumour/miso_out
      output: 
        valueFrom: "miso_compare"
    out: [miso_out]

  miso_folder:
    run: ../../cwl-tools/folder.cwl
    in:
      item:
      - miso_index/miso_out
      - miso_merge1/miso_out
      - miso_merge2/miso_out
      - miso_run_normal/miso_out
      - miso_run_tumour/miso_out
      - miso_compare/miso_out
      name:
        valueFrom: "miso"
    out: [out]
