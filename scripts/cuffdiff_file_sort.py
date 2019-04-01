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
from statsmodels.compat.python import iteritems
import numpy as np
import statsmodels.stats.multitest as multi
import pandas as pd


#UserInfo.tsv
data = pd.read_csv(sys.argv[1], sep='\t')
print("step1")
p_adjust = multi.multipletests(pvals = data.p_value, alpha = 0.05, method = "fdr_bh")
print("step2")
data['p_adj'] = p_adjust[1]
print("step3")
data = data.rename(columns={'log2(fold_change)': 'log2foldchange', 'gene': 'name'})
data = data.set_index("name")
print("step4")
print(sys.argv[1].split('/')[0] + "/"+ sys.argv[1].split('/')[0] + "/DGE_res.csv")
print("step5")
data.to_csv(sys.argv[1].split('/')[0] + "/"+ sys.argv[1].split('/')[0] +"_DGE_res.csv", sep = ",")
