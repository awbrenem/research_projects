import scipy.io as sio
from scipy.io import readsav
from os.path import dirname, join as pjoin
import pickle 
import netCDF4
import numpy as np
import matplotlib.pyplot as plt
import sys 
sys.path.append('/Users/abrenema/Desktop/code/Aaron/github/signal_analysis/')
import plot_spectrogram as ps

fn = ['Gridded_BLC_Flux_v1_20010330.sav',
      'Gridded_BLC_Flux_v1_20010331.sav',
      'Gridded_BLC_Flux_v1_20010401.sav',
      'Gridded_BLC_Flux_v1_20010402.sav',
      'Gridded_BLC_Flux_v1_20010403.sav']



path = '/Users/abrenema/Desktop/Research/SPI_ISFM/data'
data_dir = pjoin(dirname(sio.__file__), path, 'MPE_Gridded_POES-selected')
sav_fname = pjoin(data_dir, fn[1])
sav_data = readsav(sav_fname)
#dict_keys(['blc_mean_grid', 'blc_median_grid', 'blc_1st_quart', 'blc_3rd_quart', 'lat_grid', 'lon_grid', 'time_grid', 'energy'])

#data arrays have shape [nenergies, ntimes, nlats, nlons]

lats_P = sav_data['lat_grid']
lons_P = sav_data['lon_grid']
medianv_P = sav_data['blc_median_grid']
times_P = sav_data['time_grid']
energies_P = sav_data['energy']

#select energy
eval = 1000
enloc = np.where(energies_P >= eval)[0][0]
#select time (hrs) in current day
tval = 8
tloc = np.where(times_P >= tval)[0][0]

#lat grid
#[-85., -75., -65., -55., -45., -35., -25., -15.,  -5.,   5.,  15.,
#        25.,  35.,  45.,  55.,  65.,  75.,  85.]
#long grid
#array([ 10.,  30.,  50.,  70.,  90., 110., 130., 150., 170., 190., 210.,
#       230., 250., 270., 290., 310., 330., 350.]


#--------------------------------------------
#Load SAMPEX HILT data

path2 = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/SPI/spi_precipitation_maps/spi_precipitation_maps/data/'

fn2 = 'sampexHILT_vals_recovery-phase_BLC-20010331_080600_20010331_110600_3hrs.nc4'
ds = netCDF4.Dataset(path2 + fn2, 'r')
lats_S = ds.variables['lat'][:]
lons_S = ds.variables['lon'][:]
samplesGEO_S = ds.variables['samplesGEO'][:]
tmp = ds.variables['quantilesGEO'][:]
medianv_S = tmp[:,:,2]
ds.variables.keys()




#---------------------------------------------
#comparison plot of POES and HILT data
pvals = medianv_P[enloc,tloc,:,:]


fig, axs = plt.subplots(2)
ps.plot_spectrogram(lons_S,lats_S,np.transpose(medianv_S),zscale='linear',vr=[0,1],plot_kwargs={'cmap':'viridis'},ax=axs[0])
ps.plot_spectrogram(lons_P,lats_P,np.transpose(pvals),zscale='linear',plot_kwargs={'cmap':'viridis'},ax=axs[1],vr=[1e-8,1e-1],minzval=5e-4)







l2 = np.array(lats)
lats = ds.variables['lat'][:]
lons = ds.variables['lon'][:]
sampes = ds.variables['samplesGEO'][:]
