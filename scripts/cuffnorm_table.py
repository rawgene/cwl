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

import sys
import numpy as np
import pandas as pd

metadata = pd.read_csv(sys.argv[1], sep=",")
count_table = pd.read_csv(sys.argv[2], sep="\t")
gene_info = pd.read_csv(sys.argv[3], sep="\t")
count_table = count_table.set_index('tracking_id')
count_table = count_table.reindex(index=gene_info['tracking_id'])
count_table = count_table.reset_index()

count_table['tracking_id'] = gene_info['gene_short_name']
print(sys.argv[4])
columns = ["name"]
for x in sys.argv[4].split(","):
    print(x)
    tmp_metadata = metadata[metadata.condition == str(x)]
    print(metadata)
    print(tmp_metadata["name"])
    [columns.append(i) for i in tmp_metadata["name"]]

print(columns)
print(count_table)
count_table.columns = columns
count_table.to_csv(sys.argv[2].split('/')[0] + "/norm_count.csv", sep = ",", index = False)
