"""
Aaron's mod of Mike's original code. Rather than aggregate many days/months/years of data, this version outputs data 
at much shorter time intervels (e.g. 3 hrs) in order to resolve storm dynamics. 

(see also bin_data_v2.py)

Another mod is to use the incremental quartile: 
LEON: SAMPEX maps - the “mean” value doesn’t make a lot of sense b/c the data tend to be log-normally distributed. 
He suggests that the best statistic (when you don’t know the distribution shape) is the median of the quartiles. 
Upper and lower quartiles will give the variability.
(https://stackoverflow.com/questions/1058813/on-line-iterator-algorithms-for-estimating-statistical-median-mode-skewnes/2144754#2144754)


Bins the state 4 HILT data for selected dates (modification of bin_sampex_hilt.py)

If you have the SAMPEX-HILT data downloaded already, check that the
sampex.config['data_dir'] points to that directory. Run 
`python3 -m sampex init` in the command line to change that directory.

----------------------
HILT data hires range 
Starts Aug 7, 1996
Ends Nov 7, 2012
----------------------

"""



from datetime import datetime
from datetime import timedelta
import pathlib
import re
from typing import Union
import math

import numpy as np
import pandas as pd
import sampex
import load_sampex_modified_attitude
import matplotlib.pyplot as plt
import matplotlib.colors

#from spi_precipitation_maps.bin_data_v2 import Bin_Data
from spi_precipitation_maps.dial import Dial

from GetStormPhaseList import GetStormPhaseList

import matplotlib.pyplot as plt

import sys 
sys.path.append('/Users/abrenema/Desktop/code/Aaron/github/signal_analysis/')
import plot_spectrogram as ps


"""
def __init__(self,) -> None:
    #self._get_dates()
    self._get_storm_dates()
    return


def __len__(self):
    #How many days to process. It is called by progressbar.
    return len(self.dates)


def _get_storm_dates(self):
    
    #Gets list of storm dates for desired storm phase

    self.stormdates = GetStormPhaseList()
    return(self.stormdates)



def _bin_data(self, merged):
    #Groups the SAMPEX data in each L and MLT and calculates self.stat statistic
    #on the grouped counts.
    self.mean = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))
    self.mean_sampes = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))

    for i, (start_x, end_x) in enumerate(zip(L_bins[:-1], L_bins[1:])):
        for j, (start_y, end_y) in enumerate(zip(MLT_bins[:-1], MLT_bins[1:])):
            filtered_data = merged.loc[
                (merged.loc[:, self.x_col] > start_x) &
                (merged.loc[:, self.x_col] <= end_x) &
                (merged.loc[:, self.y_col] > start_y) &
                (merged.loc[:, self.y_col] <= end_y),
                :
            ]
            if filtered_data.shape[0] == 0:
                continue
            # Calculate incremental mean since were looping over many days.
            # https://math.stackexchange.com/questions/106700/incremental-averaging
            # https://ubuntuincident.wordpress.com/2012/04/25/calculating-the-average-incrementally/
            # Maybe this for loop can be replaced by itertools.accumulate?
            # for _, row in filtered_data.iterrows():
            #     adjustment = (row[self.counts_col] - self.mean[i, j])/self.mean_sampes[i, j]
            #     self.mean[i, j] += adjustment
            #     self.mean_sampes[i, j] += 1
            self.mean[i,j] = (
                self.mean_sampes[i, j]*self.mean[i,j] + np.sum(filtered_data[self.precipitation_col])
                )/(self.mean_sampes[i, j]+filtered_data.shape[0])
            self.mean_sampes[i,j] += filtered_data.shape[0]
    return


"""




def stormPhaseName(sPhse):

    if sPhse == 'initial':
        start = 'Istart'
        stop = 'Istop'
    if sPhse == 'main':
        start = 'Mstart'
        stop = 'Mstop'
    if sPhse == 'recovery':
        start = 'Rstart'
        stop = 'Rstop'
    if sPhse == 'quiet':
        start = 'Qstart'
        stop = 'Qstop'

    return start, stop





if __name__ == '__main__':

    #Define bins and labels
    L_bins = np.arange(2, 11)
    MLT_bins = np.arange(0, 24.1)
    x_col = 'L_Shell'
    y_col = 'MLT'
    GEOLong_bins = np.ceil(np.arange(-180.01,180.01,20))
    GEOLat_bins = np.ceil(np.arange(-90.1,90.1,10))
    x_col2 = 'GEO_Long'
    y_col2 = 'GEO_Lat'

    precipitation_col = 'counts'


    #Define phase of interest (initial, main, recovery, or quiet)
    Ptype = 'quiet'

    #Define loss cone type
    lcType = 'BLC'

    startName, stopName = stormPhaseName(Ptype)

    #Get list of storms and their phases
    stormDates = GetStormPhaseList()

    #Reduce storm dates to timerange of available HILT data (1996-08-07 to 2012-11-07)
    stormDates = stormDates.loc[(stormDates['Istart'] >= datetime(1996,8,8)) & (stormDates['Rstop'] <= datetime(2012,11,7))]
    stormDates.reset_index(drop=True, inplace=True)



    #Generate list of times not associated with stormtime 
    if Ptype == 'quiet':
        Qfirst = datetime(1996,8,8)
        Qlast = datetime(2012,11,7)
        numdays = (Qlast - Qfirst).days
        quietTimes = np.asarray([Qfirst + x*timedelta(hours=3) for x in range(numdays*(int(24/3)))])

        for i in range(len(stormDates)):
            quietTimes = quietTimes[(quietTimes < stormDates['Istart'][i]) | (quietTimes > stormDates['Rstop'][i])]



    #----------------------------------------------------------------------
    #Loop through each storm event
    for sd in range(len(stormDates.index)):

        goo = stormDates.iloc[sd]
        datestart = goo[startName].to_pydatetime()
        dateend = goo[stopName].to_pydatetime()



        #----------------------------------------------------------------
        #load HILT data for first (and possibly only) day
        #---NOTE: these hires files are very large and I can't load more than one day at a time
        #---So, the strategy is to load first day, reduce to timerange of interest, then load second day 
        #---if necessary and do the same.

        #Determine number of 3-hr chunks
        nchunks = math.ceil((dateend - datestart).seconds / (3*3600))

        for nc in range(nchunks):

            #define start and stop time of current chunk. Note that the last chunk will likely be 
            #less than 3 hrs in size, in which case I set the end time to the end of the storm phase
            t0 = datestart + timedelta(hours=3*nc)
            if (t0 + timedelta(hours=3)) < dateend: 
                t1 = (t0 + timedelta(hours=3))
            else:
                t1 = dateend

            nextDayFlag = t1.day-t0.day  #3-hr time chunk crosses day boundary?

            if nc == 0:
                hiltFull = sampex.HILT(t0).load()



            #---reduce first day's data to only that necessary
            hilt = hiltFull.loc[(hiltFull.index > t0) & (hiltFull.index <= t1)]   


            if nextDayFlag == 1:
                #---load second day of data, reduce, and then combine with day 1 data
                d2 = t0.replace(hour=0,minute=0,second=0,microsecond=0)
                hiltFull = sampex.HILT(d2 + timedelta(days=1)).load()
                hilt2 = hiltFull.loc[(hiltFull.index > t0) & (hiltFull.index <= t1)]
                hilt = pd.concat([hilt,hilt2])
            #----------------------------------------------------------------




            #load Sam's attitude data for first (and possibly only) year
            if nc == 0:
                attitudeFull = load_sampex_modified_attitude.Attitude(str(t0.year)).load()


            #---reduce first year's data to only that necessary (plus some padding due to lower cadence of attitude data relative to hires data)
            attitude = attitudeFull.loc[(attitudeFull.index > (t0 - timedelta(minutes=10))) & 
                                    (attitudeFull.index <= (t1 + timedelta(minutes=10)))] 

            nextYearFlag = t1.year-t0.year  #3-hr time chunk crosses day boundary?


            #plt.plot(attitude['GEO_Long'])

            if nextYearFlag == 1: 
                attitudeFull = load_sampex_modified_attitude.Attitude(str(t1.year)).load()
                attitude2 = attitudeFull.loc[(attitudeFull.index > (t0 - timedelta(minutes=10))) & 
                                        (attitudeFull.index <= (t1 + timedelta(minutes=10)))] 
                attitude = pd.concat([attitude,attitude2])



            #Merge HILT and attitude data
            hilt = hilt.sort_index(axis=0)
            merged = pd.merge_asof(hilt, attitude, left_index=True, 
                right_index=True, tolerance=pd.Timedelta(seconds=3), 
                direction='nearest')


            #------------------------------------------------------
            #Eliminate based on DLC and BLC %. This eliminates the dominant trapped population
            #------------------------------------------------------

            #merged_df = merged_df.loc[(merged_df['LC2Perc'] > 99) or (merged_df['DLCPerc'] > 99)]

            #BLC only
            #Sam's comment on 8/9/2023 for selecting BLC data: 
            # For LC2Perc, I usually use 100% (i.e. the percentage of the 58 degree view that is within the BLC). 
            # There should be plenty of data. This percentage of course relies on knowing the drift loss cone, 
            # which as we know, needs work (Something I will eventually get on to). It should largely be correct though.
            if lcType == 'BLC':
                lcTypeStr = 'LC2Perc'
            if lcType == 'DLC':
                lcTypeStr = 'DLCPerc'

            merged = merged.loc[merged[lcTypeStr] > 99]



            """
            Groups the SAMPEX data in each L and MLT and calculates self.stat statistic
            on the grouped counts.
            """
            mean = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))
            mean_sampes = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))

            for i, (start_x, end_x) in enumerate(zip(L_bins[:-1], L_bins[1:])):
                for j, (start_y, end_y) in enumerate(zip(MLT_bins[:-1], MLT_bins[1:])):
                    filtered_data = merged.loc[
                        (merged.loc[:, x_col] > start_x) &
                        (merged.loc[:, x_col] <= end_x) &
                        (merged.loc[:, y_col] > start_y) &
                        (merged.loc[:, y_col] <= end_y),
                        :
                    ]
                    if filtered_data.shape[0] == 0:
                        continue
                    # Calculate incremental mean since were looping over many days.
                    # https://math.stackexchange.com/questions/106700/incremental-averaging
                    # https://ubuntuincident.wordpress.com/2012/04/25/calculating-the-average-incrementally/
                    # Maybe this for loop can be replaced by itertools.accumulate?
                    # for _, row in filtered_data.iterrows():
                    #     adjustment = (row[self.counts_col] - self.mean[i, j])/self.mean_sampes[i, j]
                    #     self.mean[i, j] += adjustment
                    #     self.mean_sampes[i, j] += 1
                    mean[i,j] = (
                        mean_sampes[i, j]*mean[i,j] + np.sum(filtered_data[precipitation_col])
                        )/(mean_sampes[i, j]+filtered_data.shape[0])
                    mean_sampes[i,j] += filtered_data.shape[0]




            mean2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))
            mean_sampes2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))

            for i, (start_x, end_x) in enumerate(zip(GEOLong_bins[:-1], GEOLong_bins[1:])):
                for j, (start_y, end_y) in enumerate(zip(GEOLat_bins[:-1], GEOLat_bins[1:])):
                    filtered_data = merged.loc[
                        (merged.loc[:, x_col2] > start_x) &
                        (merged.loc[:, x_col2] <= end_x) &
                        (merged.loc[:, y_col2] > start_y) &
                        (merged.loc[:, y_col2] <= end_y),
                        :
                    ]
                    if filtered_data.shape[0] == 0:
                        continue
                    mean2[i,j] = (
                        mean_sampes2[i, j]*mean2[i,j] + np.sum(filtered_data[precipitation_col])
                        )/(mean_sampes2[i, j]+filtered_data.shape[0])
                    mean_sampes2[i,j] += filtered_data.shape[0]

            print('h')





            for i, (start_x, end_x) in enumerate(zip(GEOLong_bins[:-1], GEOLong_bins[1:])):
                for j, (start_y, end_y) in enumerate(zip(GEOLat_bins[:-1], GEOLat_bins[1:])):
                    print(i,j,start_x,end_x)





            #-----------------------------------
            #Plot the L-MLT results 

            #Total chunksize to 3 significant digits
            dt = (t1-t0)/timedelta(hours=1)
            dt = str('{:g}'.format(float('{:.3g}'.format(dt))))


            timeStr = t0.strftime("%Y%m%d_%H%M%S") + '-' + t1.strftime("%Y%m%d_%H%M%S") + ' (' + dt + ' hrs)'

            fig = plt.figure(figsize=(9, 4))
            ax = [plt.subplot(1, 2, i, projection='polar') for i in range(1, 3)]

            L_labels = [2,4,6]
            cmap = 'viridis'

            dial1 = Dial(ax[0], MLT_bins, L_bins, mean)
            dial1.draw_dial(L_labels=L_labels,
                mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
                colorbar_kwargs={'label':'mean > 1 MeV counts', 'pad':0.1})
            dial2 = Dial(ax[1], MLT_bins, L_bins, mean_sampes)
            dial2.draw_dial(L_labels=L_labels,
                mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
                colorbar_kwargs={'label':'Number of samples', 'pad':0.1})


            for ax_i in ax:
                ax_i.set_rlabel_position(235)
                ax_i.tick_params(axis='y', colors='white')

            plt.suptitle(f'SAMPEX-HILT | L-MLT map\n'+timeStr+'\n'+Ptype + ' phase\n'+lcType + ' counts')
            plt.tight_layout()
            plt.show()


            #-----------------------------------
            #Plot the GEO long-lat results 
            long_grid, lat_grid = np.meshgrid(GEOLong_bins, GEOLat_bins)

            #kwargs = {'cmap':'Purples'}
            kwargs = {'cmap':'viridis'}

            mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap}


            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(35, 5))
            mesh1 = ax1.pcolormesh(long_grid, lat_grid, mean2, **mesh_kwargs)
            ax1.set_aspect('equal')
            colorbar_kwargs={'label':'mean > 1 MeV counts', 'pad':0.1}
            fig.colorbar(mesh1, ax=ax1, **colorbar_kwargs)

            mesh2 = ax2.pcolormesh(long_grid, lat_grid, mean_sampes2, **mesh_kwargs)
            ax2.set_aspect('equal')
            colorbar_kwargs={'label':'Number of samples', 'pad':0.1}
            fig.colorbar(mesh2, ax=ax2, **colorbar_kwargs)




            """
            Save maps to a csv files.

            Parameters
            ----------
            filename: str
                The file name to save the precipitation map, in the csv format.
            save_dir: str or pathlib.Path
                The directory to save the map to. If None, it will save it to the
                spi_precipitation_maps/data/ folder.

            Returns
            -------
            pathlib.Path
                The full file path to the csv file.
            """

            timeStr2 = t0.strftime("%Y%m%d_%H%M%S") + '_' + dt + 'hrs_' + Ptype +  'phase_'+lcType
            save_dir = pathlib.Path(__file__).parent / 'data'

            filename = 'sampexHILT_L_MLT_vals_' + timeStr2 + '.csv'
            save_path = save_dir / filename
            df = pd.DataFrame(
                data=mean, 
                index=L_bins[:-1], 
                columns=MLT_bins[:-1]
                )
            df.to_csv(save_path)

            filename = 'sampexHILT_GEO_vals_' + timeStr2 + '.csv'
            save_path = save_dir / filename
            df = pd.DataFrame(
                data=mean2, 
                index=GEOLong_bins[:-1], 
                columns=GEOLat_bins[:-1]
                )
            df.to_csv(save_path)







