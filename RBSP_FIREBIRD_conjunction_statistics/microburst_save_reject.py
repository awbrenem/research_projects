"""
Save or reject Schumko's microbursts based on time gaps, nzeros, etc...

Saved microburst plots are copied from the parent folder (e.g. FU3_microburst_catalog_01) to 
a "reduced" folder (e.g. FU3_microburst_catalog_01_reduced)

This significantly reduces the number of microbursts I need to manually verify. 

"""


import os
import numpy as np 
#import matplotlib.pyplot as plt 


#Read all the files in directory. These filenames are of type:
#'YYYYMMDD_HHMMSS_HHMMSS_saturated=?_timegap=?_nzeros=?_L=?_MLT=?_lat=?_lon=?_microbursts'

path = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/Shumko_microburst_detection/FU3_microburst_catalog_01/'

files = os.listdir(path)

saturated = []
timegap = []
nzeros = []
yymmdd = []
hhmmss1 = []
hhmmss2 = []
files2 = []


for i in range(len(files)):

    tst = files[i].find('nzeros')
    if tst != -1:
        yymmdd.append(files[i][0:8])
        hhmmss1.append(files[i][9:15])
        hhmmss2.append(files[i][16:22])

        start = files[i].find('saturated')
        stop = files[i].find('_timegap=')
        saturated.append(int(files[i][start+10:stop]))

        start = files[i].find('timegap')
        stop = files[i].find('_nzeros=')
        timegap.append(int(files[i][start+8:stop]))

        start = files[i].find('nzeros')
        stop = files[i].find('_L=')
        nzeros.append(int(files[i][start+7:stop]))

        files2.append(files[i])



#Find all the good microbursts and copy these to another folder. 

nzeros = np.asarray(nzeros)
saturated = np.asarray(saturated)
timegap = np.asarray(timegap)

#cond = np.where((nzeros < 4) & (saturated == 0) & (timegap == 0))[-1]
cond = np.where((nzeros == 0) & (saturated == 0) & (timegap == 0))[-1]

goodfiles = [""] * len(cond)
for i in range(len(cond)): 
    goodfiles[i] = files2[cond[i]]
    print(goodfiles[i])


#Copy the good files to the reduced folder
path_reduced = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/Shumko_microburst_detection/FU3_microburst_catalog_01_reduced/'

import shutil
for i in goodfiles:
    shutil.copyfile(path+i, path_reduced+i)



