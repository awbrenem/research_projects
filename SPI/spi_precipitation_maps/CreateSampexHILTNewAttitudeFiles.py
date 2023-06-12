"""
This program will create new SAMPEX daily attitude files based on Sam Walton's yearly attitude files.
These contain all the info of the online attitude files plus additional useful info on the BLC, DLC, etc...
In addition, I'll add info on storm phase, loss cone type, and HILT pitch angle direction (Sam's has only the PET direction).

Note that the original attitude files at 
https://izw1.caltech.edu/sampex/DataCenter/docs/sampex_psset.html
are divided into Bartels rotations. Same as all the SAMPEX data, I think. 

I'll save the new attitude files as daily files. This will require a modification of the bin_sampex_hilt.py code
in the way in which it loads the attitude files, but that should be easy. 

"""

from datetime import datetime
import pathlib
import re
import numpy as np
import pandas as pd
import sampex
import matplotlib.pyplot as plt
import matplotlib.colors



class CreateSampexHILTNewAttitudeFiles:
    """
    Merges SAMPEX attitude files for the HILT instrument with:
    (1) Storm epoch list
    (2) HILT pitch angle direction
    (3) Loss cone type
    ***All of the above variables are in Sam Walton's SAMPEX ephemeris files that I load below
    """
    def __init__(self,) -> None:

#Note that Pandas can grab file from url --> this is a safer method than using local path 


        #List of storm epoch times 
        path = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/SPI/spi_precipitation_maps/"
        fn = "WGStormList.txt"
        stormlist = pd.read_csv(path + fn, index_col=0, parse_dates=[1, 2, 3, 4])
        self.stormlist = stormlist.reset_index(drop=True)


        #List of dates to analyze
        self._get_dates()

        return



    def load_sam_sampex(self):

        #Load Sam Walton's SAMPEX additional attitude data
        filepath = "/Users/abrenema/data/SAMPEX/"
        ystart = 1996
        yend = 1998 
        yearsvar = list(range(ystart,yend+1,1))
        yearss = []
        for i in yearsvar: yearss.append(str(i))


        samdat = pd.read_csv(filepath+str(ystart)+'.txt', index_col=0, parse_dates=True)
        for i in yearss[1:]:
            samdat2 = pd.read_csv(filepath+i+'.txt', index_col=0, parse_dates=True)
            samdat = pd.concat([samdat, samdat2])

        #Test storm phase values (most are NaN)
        samdat.StormPhase.dropna().unique()
        #array(['Quiet', 'Initial', 'Main', 'ERecovery', 'MRecovery', 'LRecovery'],


        return samdat



    #def __iter__(self):
    def loop_dates(self):


        #Load SAMPEX attitude data 
        for date in self.dates:
            print(f'Processing SAMPEX attitude on {date.date()}')


            try:
                self.attitude = sampex.Attitude(date).load()
            except ValueError as err:
                # Sometimes there is missing attitude data
                if 'Missing attitude file in' in str(err):
                    continue
                else:
                    raise

#Now reduce attitude data to current date

#Then, compare to epoch data to 

#Then, create a new daily attitude file with updated epoch flag


#Mike's attitude data are on 6-sec cadence and have:
#time	GEO_Radius	GEO_Long	GEO_Lat	Altitude	L_Shell	MLT	Mirror_Alt	Pitch	Att_Flag




            """
            try:
                merged_df = pd.merge_asof(self.hilt, self.attitude, left_index=True, 
                    right_index=True, tolerance=pd.Timedelta(seconds=3), 
                    direction='nearest')
            except ValueError as err:
                if 'keys must be sorted' in str(err):
                    continue
                else:
                    raise
            """
            self.attitude = self.attitude.reset_index()
            self.attitude.rename(columns={'index':'time'}, inplace=True)


        #Finally, save the new attitude file to a daily .csv file and return
        filename = '~/Desktop/tmp.csv'
        self.attitude.to_csv(filename, encoding='utf-8', index=False)





    def __len__(self):
        """
        How many days to process.
        """
        return len(self.dates)

    def _get_dates(self):
        """
        Finds the SAMPEX files and converts the filenames into dates.
        """
        # Look for local SAMPEX files.
        file_name_glob = f"hhrr*"
        self.hilt_paths = sorted(
            pathlib.Path(sampex.config['data_dir']).rglob(file_name_glob))
        if len(self.hilt_paths):
            date_strs = [re.findall(r"\d+", str(f.name))[0] for f in self.hilt_paths]
            self.dates = [sampex.load.yeardoy2date(date_str) for date_str in date_strs]
        else:
            # Otherwise get the list of filenames online.
            downloader = sampex.Downloader(
                'https://izw1.caltech.edu/sampex/DataCenter/DATA/HILThires/State4/'
                )
            downloaders = downloader.ls(file_name_glob)
            assert len(downloaders), f'{len(downloaders)} HILT files found at {downloader.url}'

            date_strs = [re.findall(r"\d+", str(d.name()))[0] for d in downloaders]
            self.dates = [sampex.load.yeardoy2date(date_str) for date_str in date_strs]
        #self.dates = [date for date in self.dates if date > datetime(1997, 1, 1)]
        self.dates = [date for date in self.dates if (date > datetime(1997, 1, 2)) and (date < datetime(1997, 1, 4))]
        return self.dates

if __name__ == '__main__':


    m = CreateSampexHILTNewAttitudeFiles()
    #np.shape(m.storm_events)
    #np.shape(m.dates)
    #m.__len__()   #Otherwise "length of what since "m" is an object"
    #merged = m.__iter__()
    ##np.shape(m.merged_df)


    #Load Sam Walton's SAMPEX additional attitude data

    ssampex = m.load_sam_sampex()





#    dates_iter2 = m.__iter__()
    dates_iter2 = m.loop_dates()
    tst = next(dates_iter2)








    t2 = tst['index'][0:1] == '1996-12-14 00:00:06'

    column_names = ['time',]

    tst.columns = column_names





    for ax_i in ax:
        ax_i.set_rlabel_position(235)
        ax_i.tick_params(axis='y', colors='white')

    plt.suptitle(f'SAMPEX-HILT | L-MLT map')
    plt.tight_layout()
    plt.show()