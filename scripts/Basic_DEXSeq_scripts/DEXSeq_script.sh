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

#!/usr/bin/bash

# ./DEXSeq_script.sh sam_file_path annotation_file_path  name_for_counts_file metadata_file

echo -ne "\nBaseSpace directory ='$1'\n\n"

if [[ $2 == *"gtf"* ]]
	then
		echo "You entered GTF file, processing to GFF"
		find="gtf"
                replace="gff3"
                new_variable=${2//$find/$replace}
                python dexseq_prepare_annotation.py $2 $new_variable
		echo "done"
	else
		echo "You entered GFF file, no preprocessing needed"
		new_variable=$2
		echo "done"
fi

echo "Generating count table"
for dir in $1; 
do
	echo -ne "\nDir'=$dir'\n\n"
	echo $4
	echo $new_variable
	python dexseq_count.py $dir $new_variable $3
done
echo "Done"

echo "Starting DEXSeq"
./DEXSeq.R --count_matrix_dir $PWD --gff_file_dir $new_variable --metadata $4
