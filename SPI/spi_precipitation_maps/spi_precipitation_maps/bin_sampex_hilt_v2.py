"""
Aaron's mod of Mike's original code. Rather than aggregate many days/months/years of data, this version outputs data 
at much shorter time intervels (e.g. 3 hrs) in order to resolve storm dynamics. 

(see also bin_data_v2.py)

Another mod is to use the incremental quantile: 
LEON: SAMPEX maps - the “mean” value doesn’t make a lot of sense b/c the data tend to be log-normally distributed. 
He suggests that the best statistic (when you don’t know the distribution shape) is the median of the quantiles. 
Upper and lower quantiles will give the variability.
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


#SPI comparison dates with Josh: 
#I picked a weaker storm time with less POES satellites in the air and a stronger storm with a lot of POES satellites. 
#427,2005-07-04 16:37:00,2005-07-07 00:00:00,2005-07-07 00:01:00,2005-07-07 00:02:00,-81.0
#450,2011-10-21 08:42:00,2011-10-24 22:36:00,2011-10-25 01:15:00,2011-10-28 11:42:00,-160.0


from datetime import datetime
from datetime import timedelta
import pathlib
import math
import numpy as np
import pandas as pd
import sampex
import load_sampex_modified_attitude
import matplotlib.pyplot as plt
import matplotlib.colors
from spi_precipitation_maps.dial import Dial
from GetStormPhaseList import GetStormPhaseList
import matplotlib.pyplot as plt
import sys 
sys.path.append('/Users/abrenema/Desktop/code/Aaron/github/signal_analysis/')
import plot_spectrogram as ps
import pickle
from mpl_toolkits.axes_grid1 import make_axes_locatable  #for scaling colorbar to plot size
import netCDF4

#Josh indicates that a bin size of 5 deg lat and 10 deg long should be good for entire POES mission.


#Define bins and labels
L_bins = np.arange(2, 11)
MLT_bins = np.arange(0, 24.1)
x_col = 'L_Shell'
y_col = 'MLT'
#GEOLong_bins = np.ceil(np.arange(-180.01,180.01,10))
#GEOLat_bins = np.ceil(np.arange(-90.1,90.1,5))
latdelta = 10 
londelta = 10

GEOLong_bins = np.ceil(np.arange(0,360.01,londelta))
GEOLat_bins = np.ceil(np.arange(-90.1,90.1,latdelta))
x_col2 = 'GEO_Long'
y_col2 = 'GEO_Lat'
precipitation_col = 'counts'



#Define phase of interest (initial, main, recovery, or quiet)
Ptype = 'recovery'
#Define loss cone type
lcType = 'BLC'

#Geometric factor (cm2*sr) for STATE 4 data from 1996-220 thru 2004-182
#see https://izw1.caltech.edu/sampex/DataCenter/docs/HILThires.html
geometric_fac = 15




#Versions of independent variables that are the same size as the data arrays. Each value is the 
#midpoint value. GEOLat_bins and GEOLong_bins are one size greater and include the end points. 
latbins = GEOLat_bins + latdelta/2
latbins = latbins[0:-1]
lonbins = GEOLong_bins + londelta/2
lonbins = lonbins[0:-1]









#Global variables
meanVals = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))
samples = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))
quantileVals = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1,5))
altitude = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))
attitudeFlag = np.zeros((L_bins.shape[0]-1, MLT_bins.shape[0]-1))

meanVals2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))
samples2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))
quantileVals2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1,5))
altitude2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))
attitudeFlag2 = np.zeros((GEOLong_bins.shape[0]-1, GEOLat_bins.shape[0]-1))


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



def get_statisticVals(mergedvals):

    """
    Groups the SAMPEX data in each L and MLT and calculates self.stat statistic
    on the grouped counts.
    """

    #Reset the values for each time chunk (very necessary)
    meanVals[:] = 0
    samples[:] = 0 
    quantileVals[:] = 0
    altitude[:] = 0
    attitudeFlag[:] = 0
    meanVals2[:] = 0
    samples2[:] = 0 
    quantileVals2[:] = 0
    altitude2[:] = 0
    attitudeFlag2[:] = 0

    for i, (start_x, end_x) in enumerate(zip(L_bins[:-1], L_bins[1:])):
        for j, (start_y, end_y) in enumerate(zip(MLT_bins[:-1], MLT_bins[1:])):
            filtered_data = mergedvals.loc[
                (mergedvals.loc[:, x_col] > start_x) &
                (mergedvals.loc[:, x_col] <= end_x) &
                (mergedvals.loc[:, y_col] > start_y) &
                (mergedvals.loc[:, y_col] <= end_y),
                :
            ]
            if filtered_data.shape[0] == 0:
                continue

            samples[i,j] += filtered_data.shape[0]  #number of time samples in each bin
            quantileVals[i,j,:] = np.quantile(filtered_data[precipitation_col],[0.05,0.25,0.5,0.75,0.95])
            meanVals[i,j] = np.nanmean(filtered_data[precipitation_col])
            altitude[i,j] = np.nanmean(filtered_data['Altitude'])
            attitudeFlag[i,j] = np.nanmean(filtered_data['Att_Flag'])


    for i, (start_x, end_x) in enumerate(zip(GEOLong_bins[:-1], GEOLong_bins[1:])):
        for j, (start_y, end_y) in enumerate(zip(GEOLat_bins[:-1], GEOLat_bins[1:])):
            filtered_data = mergedvals.loc[
                (mergedvals.loc[:, x_col2] > start_x) &
                (mergedvals.loc[:, x_col2] <= end_x) &
                (mergedvals.loc[:, y_col2] > start_y) &
                (mergedvals.loc[:, y_col2] <= end_y),
                :
            ]
            if filtered_data.shape[0] == 0:
                continue

            samples2[i,j] += filtered_data.shape[0]  #number of time samples
            quantileVals2[i,j,:] = np.quantile(filtered_data[precipitation_col],[0.05,0.25,0.5,0.75,0.95])
            meanVals2[i,j] = np.nanmean(filtered_data[precipitation_col])
            altitude2[i,j] = np.nanmean(filtered_data['Altitude'])
            attitudeFlag2[i,j] = np.nanmean(filtered_data['Att_Flag'])





def plot_results(timeStrv):


    save_dir1 = pathlib.Path(__file__).parent / 'plots_lmlt'
    save_dir2 = pathlib.Path(__file__).parent / 'plots_geo'
    filename1 = 'sampexHILT_L-MLT_' + timeStrv + '_' + Ptype + '-phase_' + lcType + '.png'
    save_path1 = save_dir1 / filename1
    filename2 = 'sampexHILT_GEO_' + timeStrv + '_' + Ptype + '-phase_' + lcType + '.png'
    save_path2 = save_dir2 / filename2


    valsPlot1 = quantileVals[:,:,2]
    valsPlot2 = quantileVals2[:,:,2]

    #change zeros to NaNs so that they aren't plotted
    valsPlot1[valsPlot1 == 0] = float("nan")
    valsPlot2[valsPlot2 == 0] = float("nan")
    samples[samples == 0] = float("nan")
    samples2[samples2 == 0] = float("nan")


    #----------------------------
    #Polar plots of L/MLT
    #----------------------------

    fig = plt.figure(figsize=(9, 4))
    ax = [plt.subplot(1, 2, i, projection='polar') for i in range(1, 3)]

    L_labels = [2,4,6]
    cmap = 'viridis'

    dial1 = Dial(ax[0], MLT_bins, L_bins, valsPlot1)
    dial1.draw_dial(L_labels=L_labels,
        #mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
        mesh_kwargs={'cmap':cmap,'vmin':0,'vmax':50},
        colorbar_kwargs={'label':'median > 1 MeV flux\n#/cm2-sr', 'pad':0.1})
    dial2 = Dial(ax[1], MLT_bins, L_bins, samples)
    dial2.draw_dial(L_labels=L_labels,
        #mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap},
        mesh_kwargs={'cmap':cmap},
        colorbar_kwargs={'label':'Number of samples', 'pad':0.1})


    for ax_i in ax:
        ax_i.set_rlabel_position(235)
        ax_i.tick_params(axis='y', colors='white')

    plt.suptitle(f'SAMPEX-HILT | L-MLT map\n'+timeStrv+'\n'+Ptype + ' phase\n'+lcType + ' counts and number of samples')
    plt.tight_layout()
    plt.savefig(save_path1,dpi=200)
    plt.show()
    plt.close(fig)


    #-----------------------------------
    #Plot the GEO long-lat results 
    #-----------------------------------

    fig, axs = plt.subplots(2)
    ps.plot_spectrogram(lonbins,latbins,np.transpose(valsPlot2),zscale='linear',vr=[0,5],plot_kwargs={'cmap':'viridis'},ax=axs[0])
    ps.plot_spectrogram(lonbins,latbins,np.transpose(samples2),zscale='linear',vr=[0,5000],plot_kwargs={'cmap':'viridis'},ax=axs[1])
    plt.suptitle(f'SAMPEX-HILT | GEO map\n'+timeStrv+'\n'+Ptype + ' phase\n'+lcType + ' counts and number of samples')

    print('h')

    """
    long_grid, lat_grid = np.meshgrid(GEOLong_bins, GEOLat_bins)

    #kwargs = {'cmap':'viridis'}
    #mesh_kwargs={'norm':matplotlib.colors.LogNorm(), 'cmap':cmap}
    #mesh_kwargs={'cmap':cmap}
    mesh_kwargs={'cmap':cmap,'vmin':0,'vmax':50}
    mesh_kwargs_counts={'cmap':cmap}


    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4))


    # create an axes on the right side of ax. The width of cax will be 5%
    # of ax and the padding between cax and ax will be fixed at 0.05 inch.
    divider = make_axes_locatable(ax1)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    divider2 = make_axes_locatable(ax2)
    cax2 = divider2.append_axes("right", size="5%", pad=0.05)


    mesh1 = ax1.pcolormesh(long_grid, lat_grid, np.transpose(valsPlot2), **mesh_kwargs)
    ax1.set_aspect('equal')
    colorbar_kwargs={'label':'median > 1 MeV flux\n#/cm2-sr', 'pad':0.1}
    fig.colorbar(mesh1, ax=ax1, **colorbar_kwargs,cax=cax)

    mesh2 = ax2.pcolormesh(long_grid, lat_grid, np.transpose(samples2), **mesh_kwargs_counts)
    ax2.set_aspect('equal')
    colorbar_kwargs={'label':'Number of samples', 'pad':0.1}
    fig.colorbar(mesh2, ax=ax2, **colorbar_kwargs,cax=cax2)

    plt.suptitle(f'SAMPEX-HILT | GEO map\n'+timeStrv+'\n'+Ptype + ' phase\n'+lcType + ' counts and number of samples')
    plt.tight_layout()
    plt.savefig(save_path2, dpi=200)

    plt.show()
    plt.close(fig)
    """






#---------------------------------------------------------------------
#Save quantities to netCDF file
#---------------------------------------------------------------------

def save_data(timeStr2v):

    save_dir = pathlib.Path(__file__).parent / 'data'

    #Final save data
    data={'L_bins':L_bins,
          'MLT_bins':MLT_bins,
          'GEOLong_bins':GEOLong_bins,
          'GEOLat_bins':GEOLat_bins,
          'mean_L_MLT':meanVals, 
          'quantile_L_MLT':quantileVals,
          'samples_L_MLT':samples,
          'altitude':altitude,
          'attitudeFlag':attitudeFlag,
          'mean_GEO':meanVals2,
          'quantile_GEO':quantileVals2,
          'samples_GEO':samples2,
          'altitude':altitude,
          'attitudeFlag':attitudeFlag}


    """
    #Save all values in a pandas dataframe
    filename = 'sampexHILT_vals_' + Ptype + '-phase_' + lcType + '-' + timeStr2v + '.pkl'
    save_path = save_dir / filename
    dataFile = open(save_path, 'wb')
    pickle.dump(data, dataFile)
    dataFile.close()
    """
    #--------------------------------------------
    #Save data to a Netcdf file
    #see tutorial at https://unidata.github.io/python-training/workshop/Bonus/netcdf-writing/
    #--------------------------------------------


    filename = 'sampexHILT_vals_' + Ptype + '-phase_' + lcType + '-' + timeStr2v + '.nc4'
    save_dir = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/SPI/spi_precipitation_maps/spi_precipitation_maps/data/'
    nc = netCDF4.Dataset(save_dir + filename,'w',format='NETCDF4')

    lat_dim = nc.createDimension('lat',len(latbins))
    lon_dim = nc.createDimension('lon',len(lonbins))
    l_dim = nc.createDimension('l',len(L_bins)-1)
    mlt_dim = nc.createDimension('mlt',len(MLT_bins)-1)
    quants_dim = nc.createDimension('quants',5)


    #independent variables
    lat = nc.createVariable('lat',np.float32, ('lat'))
    lon = nc.createVariable('lon',np.float32, ('lon'))
    l = nc.createVariable('l',np.float32,('l'))
    mlt = nc.createVariable('mlt',np.float32,('mlt'))
    lat.units = 'deg'
    lat.long_name = 'GEO latitude'
    lon.units = 'deg'
    lon.long_name = 'GEO longitude'
    l.units = 'Lvalue'
    l.long_name = 'L-shell'
    mlt.units = 'hrs'
    mlt.long_name = 'magnetic local time'

    #dependent variables
    samplesGEO = nc.createVariable('samplesGEO',np.float32,('lon','lat'))
    samplesLMLT = nc.createVariable('samplesLMLT',np.float32,('l','mlt'))
    quantilesGEO = nc.createVariable('quantilesGEO',np.float32,('lon','lat','quants'))
    quantilesLMLT = nc.createVariable('quantilesLMLT',np.float32,('l','mlt','quants'))
    meanGEO = nc.createVariable('meanGEO',np.float32,('lon','lat'))
    meanLMLT = nc.createVariable('meanLMLT',np.float32,('l','mlt'))
    samplesGEO.standard_name = '# samples'
    samplesLMLT.standard_name = '# samples'
    samplesGEO.long_name = 'SAMPEX HILT samples per sector'
    samplesLMLT.long_name = 'SAMPEX HILT samples per sector'
    quantilesGEO.standard_name = 'quantiles'
    quantilesLMLT.standard_name = 'quantiles'
    quantilesGEO.long_name = 'SAMPEX HILT (5,25,50,75,95) quantiles'
    quantilesLMLT.long_name = 'SAMPEX HILT (5,25,50,75,95) quantiles'
    meanGEO.standard_name = 'means'
    meanLMLT.standard_name = 'means'
    meanGEO.long_name = 'SAMPEX HILT mean values'
    meanLMLT.long_name = 'SAMPEX HILT mean values'


    #assign data
    samplesGEO[:,:] = samples2
    quantilesGEO[:,:,:] = quantileVals2
    meanGEO[:,:] = meanVals2
    lon[:] = lonbins
    lat[:] = latbins
    samplesLMLT[:,:] = samples
    quantilesLMLT[:,:,:] = quantileVals
    meanLMLT[:,:] = meanVals
    l[:] = L_bins[0:-1]
    mlt[:] = MLT_bins[0:-1]

    nc.close()





if __name__ == '__main__':

    startName, stopName = stormPhaseName(Ptype)

    #Get list of storms and their phases
    stormDates = GetStormPhaseList()

    #Reduce storm dates to timerange of available HILT data (1996-08-07 to 2012-11-07)
    #stormDates = stormDates.loc[(stormDates['Istart'] >= datetime(1996,8,8)) & (stormDates['Rstop'] <= datetime(2012,11,7))]

    #Select custom start date
    stormDates = stormDates.loc[(stormDates['Istart'] >= datetime(2001,3,29)) & (stormDates['Rstop'] <= datetime(2012,11,7))]
    stormDates.reset_index(drop=True, inplace=True)



    #Generate list of times not associated with stormtime 
    if Ptype == 'quiet':
        Qfirst = datetime(1996,8,8)
        Qlast = datetime(2012,11,7)
        numdays = (Qlast - Qfirst).days
        nhrsQ = 3  #how many hours to average over for each quiet time chunk (ONE DAY OR LESS SINCE THIS IS ALL THE HIRES HILT DATA MY COMPUTER CAN HANDLE)
        quietTimes = np.asarray([Qfirst + x*timedelta(hours=nhrsQ) for x in range(numdays*(int(24/nhrsQ)))])
        #Remove storm times
        for i in range(len(stormDates)):
            quietTimes = quietTimes[(quietTimes < stormDates['Istart'][i]) | (quietTimes > stormDates['Rstop'][i])]



    #----------------------------------------------------------------------
    #Loop through each storm event
    #----------------------------------------------------------------------

    if Ptype != 'quiet':

        nhrsS = 3  #chunksize (hrs) for each file
        for sd in range(len(stormDates.index)):

            goo = stormDates.iloc[sd]
            datestart = goo[startName].to_pydatetime()
            dateend = goo[stopName].to_pydatetime()

            #SPI comparison dates with Josh: 
            #59,2001-03-30 14:28:00,2001-03-31 04:47:00,2001-03-31 08:06:00,2001-04-03 05:31:00,-437.0
            #89,2002-12-16 17:08:00,2002-12-19 11:53:00,2002-12-21 03:18:00,2002-12-22 10:30:00,-90.0

            #sampexHILT_vals_initial-BLC-20010330_142800_3hrs_initialphase_BLC.pkl
            #sampexHILT_GEO_initial-phase_BLC_20010330_142800-20010330_172800 (3 hrs).png
            #----------------------------------------------------------------
            #load HILT data for first (and possibly only) day
            #---NOTE: these hires files are very large and I can't load more than one day at a time
            #---So, the strategy is to load first day, reduce to timerange of interest, then load second day 
            #---if necessary and do the same.

            #Determine number of time chunks
            tmp = (dateend - datestart).total_seconds()
            nchunks = math.ceil(tmp / (nhrsS*3600))

            for nc in range(nchunks):

                #define start and stop time of current chunk. Note that the last chunk will likely be 
                #less than nhrsS in size, in which case I set the end time to the end of the storm phase
                t0 = datestart + timedelta(hours=nhrsS*nc)
                if (t0 + timedelta(hours=nhrsS)) < dateend: 
                    t1 = (t0 + timedelta(hours=nhrsS))
                else:
                    t1 = dateend

                nextDayFlag = t1.day-t0.day  #time chunk crosses day boundary?

                if nc == 0:
                    hiltFull = sampex.HILT(t0).load()



                #---reduce first day's data to only that necessary
                hilt = hiltFull.loc[(hiltFull.index > t0) & (hiltFull.index <= t1)]   


                if nextDayFlag != 0:  #note: can be negative values if year is crossed
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

                fig, axs = plt.subplots(2)
                axs[0].plot(attitude['GEO_Long'])
                axs[1].plot(attitude['GEO_Lat'])

                #time chunk crosses year boundary?
                nextYearFlag = t1.year-t0.year
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


                #Change Sam's GEO long values from -180-180 to 0-360 to match Josh's files
                #goo = np.where(merged.GEO_Long < 0)
                #merged.GEO_Long[goo[0]] += 360
                merged.GEO_Long[merged.GEO_Long < 0] += 360



                #Change counts to flux 
                merged.counts /= geometric_fac



                #Get mean values 
                get_statisticVals(merged)


                #Plot the L-MLT results 
                #...Total chunksize to 3 significant digits
                dt = (t1-t0)/timedelta(hours=1)
                dt = str('{:g}'.format(float('{:.2g}'.format(dt))))
                timeStr = t0.strftime("%Y%m%d_%H%M%S") + '-' + t1.strftime("%Y%m%d_%H%M%S") + '_' + dt + 'hrs'
                plot_results(timeStr)


                #Save maps to a csv files.
                #timeStr2 = t0.strftime("%Y%m%d_%H%M%S") + '_' + t1.strftime("%Y%m%d_%H%M%S") + '_' + dt + 'hrs_' + Ptype +  'phase_'+lcType
                timeStr2 = t0.strftime("%Y%m%d_%H%M%S") + '_' + t1.strftime("%Y%m%d_%H%M%S") + '_' + dt + 'hrs'
                save_data(timeStr2)


    #Have to process quiet days better b/c the quiettime array is a different format than stormtime array
    if Ptype == 'quiet':

        #full year of attitude
        attitudeFull = load_sampex_modified_attitude.Attitude(str(quietTimes[0].year)).load()
        hiltFull = sampex.HILT(quietTimes[0]).load()



        for sd in range(len(quietTimes)-1):

            datestart = quietTimes[sd]
            dateend = datestart + timedelta(hours=nhrsQ)


            #---reduce first day's data to only that necessary
            hilt = hiltFull.loc[(hiltFull.index > datestart) & (hiltFull.index <= dateend)]   


            #---reduce first year's data to only that necessary (plus some padding due to lower cadence of attitude data relative to hires data)
            attitude = attitudeFull.loc[(attitudeFull.index > (datestart - timedelta(minutes=10))) & 
                                    (attitudeFull.index <= (dateend + timedelta(minutes=10)))] 


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


            #get mean data
            get_statisticVals(merged)



            #Total chunksize to 3 significant digits
            timeStr = datestart.strftime("%Y%m%d_%H%M%S") + '-' + dateend.strftime("%Y%m%d_%H%M%S") + '_' + str(nhrsQ) + 'hrs'
            plot_results(timeStr)



            #Save maps to a csv files
            #timeStr2 = datestart.strftime("%Y%m%d_%H%M%S") + '_' + str(nhrsQ) + 'hrs_' + Ptype +  'phase_'+lcType
            timeStr2 = datestart.strftime("%Y%m%d_%H%M%S") + '_' + dateend.strftime("%Y%m%d_%H%M%S") + '_' + str(nhrsQ) + 'hrs'
            save_data(timeStr2)





            #now determine for the next loop iteration if we need new attitude data for a new year
            nextYearFlag = quietTimes[sd+1].year - quietTimes[sd].year  #time chunk crosses day boundary?
            if nextYearFlag != 0: 
                attitudeFull = load_sampex_modified_attitude.Attitude(str(quietTimes[sd+1].year)).load()

            #load new HILT data only if a day boundary is crossed
            nextDayFlag = quietTimes[sd+1].day - quietTimes[sd].day  #time chunk crosses day boundary?
            if nextDayFlag != 0:   #note: can be negative values if year is crossed
                hiltFull = sampex.HILT(quietTimes[sd+1]).load()



