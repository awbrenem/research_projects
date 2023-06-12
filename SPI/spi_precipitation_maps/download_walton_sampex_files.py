#! /usr/bin/env python
#Use Wget to download Sam Walton's SAMPEX files at 


wget https://drive.google.com/drive/u/1/folders/13FkiTbV2ApKiMUhE3MnwDu5tNPUfMcXG/{1993..1994}.txt


#I've stored these in /Users/abrenema/data/SAMPEX/

#For usage see Sam's email (sdwalton@berkeley.edu) on 3/2/23 


pd.read_csv(‘/filepath/'+str(year)+'.txt’, index_col=0, parse_dates=True)

#Of course, replacing ‘/filepath/‘ with wherever the files are located on your system, and don’t forget to assign the year variable as an integer. 
#You can use the ‘usecols’ keyword argument if you don’t want to load up all the columns to save memory, which can be significantly faster too. Refer to the ‘README_column’ file for the corresponding column numbers.
#
#Thanks,
#Sam

