"""
Create a verified list of microbursts based on Mykhaylo Shumko's full catalog (e.g. FU3_microburst_catalog.csv).
The problem with the full list is that many of the microbursts are false detections. 

To reduce these, first run microburst_save_reject.py. This filters out many of the 
false microbursts. This much smaller list can then be verified by eye. 

This program reduces the full microburst catalog to only those that have been verified. 

"""


import os
import numpy as np 
import pandas as pd

path = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/Shumko_microburst_detection/'

#Microburst full and reduced catalogs
catfull = path + 'FU3_microburst_catalog_01.csv'
catreduced = path + 'FU3_microburst_catalog_01_reduced.csv'


#Folder of surviving microburst files
uBsurviving = path + 'FU3_microburst_catalog_01_reduced_nzero=0_VERIFIED/'


#Get names of all surviving microbursts
files = sorted(os.listdir(uBsurviving))

yymmdd = []
hhmmss1 = []
hhmmss2 = []
files2 = []

#Build list of surviving microbursts
for i in range(len(files)):

    #Make sure the file is an actual microburst and not directory info
    tst = files[i].find('nzeros')
    if tst != -1:
        yymmdd.append(files[i][0:8])
        hhmmss1.append(files[i][9:15])
        hhmmss2.append(files[i][16:22])
        #Since not all files are microbursts, we need to rebuild the microburst list
        files2.append(files[i])


#Put the datetime in the same format as the .csv file for comparison
datetime = []
for i in range(len(files2)):
    datetime.append(yymmdd[i][0:4]+'-'+yymmdd[i][4:6]+'-'+yymmdd[i][6:8]+' '+hhmmss1[i][0:2]+':'+hhmmss1[i][2:4]+':'+hhmmss1[i][4:6]+'.'+hhmmss2[i][0:2]+hhmmss2[i][2:4]+hhmmss2[i][4:6])


#Read in full microburst list from Mike
header = ['Time','Lat','Lon','Alt','McIlwainL','MLT','kp','counts_s_0','counts_s_1','counts_s_2','counts_s_3','counts_s_4','counts_s_5','sig_0','sig_1','sig_2','sig_3','sig_4','sig_5','time_gap','saturated','n_zeros']
file_name = catfull
df = pd.read_csv(file_name, header=None, delim_whitespace=False, names=header, 
                na_values=["NaN", "-NaN", "Inf", "-Inf"],skiprows=1)


#Compare microburst times from reduced list to full list. Create new list for surviving microbursts
goodind = []
for i in range(len(datetime)):
    good = np.where(df['Time'] == datetime[i])[0]
    print(datetime[i], ' - ', df['Time'][good])
    goodind.append(good[0])


#New dataframe with only the desired microbursts
df2 = df.iloc[goodind,:]


#Print the surviving list to a .csv file. 
df2.to_csv(catreduced,index=False)

