# barrel_rbsp_coherence_survey


#THIS WRITEUP CONTAINS THE FOLLOWING:
#-------------------------------------
#Processing chain of commands

#Detailed description of the data analysis chain for the
#BARREL/RBSP coherence analysis
#------------------------------------------------------


#-------------------------------------
#Processing chain of commands
#-------------------------------------

#Create fullmission plots for each payload (e.g. creates barrel_2L_fspc_fullmission.txt)
#Example output:
#                    Time            quality   fspc  lshell  mlt
#                   1389021025.702   ***        82.0    4.8   14.2
coh_analysis_driver
-->Coh_analysis.py
------>py_create_barrel_missionwide_ascii (creates barrel_2L_fspc_fullmission.txt, which are FSPC or peak detector)
--------->combine_barrel_data (Combine BARREL peak detector or FSPC values for multiple days into a single tplot file. Also adds EPHEM values using Kp=2 T89(??) model)
------------>load_barrel_lc
--------->get_flare_list
------>py_create_coh_tplot (e.g. creates files like AB.tplot which have coherence values vs freq for every combination of BARREL balloons)
-------->load_barrel_data_noartifacts (loads barrel_2L_fspc_fullmission.txt)
-------->mlt_difference_find
-------->load_barrel_plasmapause_distance
-------->dynamic_cross_spec_tplot
#WORKING TO THIS POINT


py_filter_barrel_by_ulf_period (creates tplot files (barrel_2p_power.tplot) with balloon FSPC or LC values filtered to certain freq ranges. Includes RMS power across entire selected bandwidth)

create_active_time_list (takes the RMS power value from tplot files from py_filter_barrel_by_ulf_period and calculates the peak RMS power value in large (few hr, typically) blocks of time. Saves these as .txt files like barrel_2p_block_power.txt. These files will be used to select out certain times for the statistical analysis that correspond to times when there's actually precipitation occurring at certain freq ranges.)


#Below part is mostly working....
#....need to call from Python...
#....need to find better way of averaging coherence across all payloads
py_make_dial_plot (Take the coherence files (e.g. AB.tplot) and plot the coherence values as a dial plot)
-->extract_timeseries_from_coherence_files (Take the coherence files
      (e.g. AB.tplot) and extract timeseries data that will be inputted
      into timeseries_reduce_to_pk_and_npk.pro)
----->filter_coherence_spectra      
----->timeseries_reduce_to_pk_and_npk,timeseries,dt (Take an input timeseries
      of data and determine the number of times that the values are above a
      certain threshold in a time chunk of size "dt")
----->percentoccurrence_L_MLT_calculate (sort into L,MLT bins and find %occurrence)



#------------------------------------------------------
#Detailed description of the data analysis chain for the
#BARREL/RBSP coherence analysis
#------------------------------------------------------

For the second BARREL campaign the payloads used are
['i','t','w','k','l','x','a','b','e','o','p']. I'm loading
the BARREL FSPC (fast spec) data.

The first step is to create files like barrel_2W_fspc_fullmission.txt.
These contain the FSPC data, L, MLT for a single payload for the
entire second campaign. (Note: can also load Peakdetector (rcnt) values)
The data are the L2 files loaded from http://barreldata.ucsc.edu/data_products/.
The flux levels are determined from the FSPC cdf files (e.g. bar_1C_l2_fspc_20130116_v05.cdf)
while L and MLT are determined from the EPHEM cdf files (e.g. bar_1C_l2_ephm_20130116_v05.cdf).
Both Kp=2 and Kp=6 are defined from the T89 (I think) model. Since the conditions
were quiet during the second campaign, I'm using the Kp=2 values.

Once the FSPC and EPHEM files are created for each payload for the
entire mission, I NaN out data during times of flares (get_flare_list).
These are small durations of data.




Once the single-payload files are created, I now run
py_create_coh_tplot.pro. The basic idea is to call Lei's coherence program
for each of the balloon pairs (only pairs that overlap in time are considered). However, the single-balloon data need to
be modified in a number of ways first, otherwise we end up with lots of
high coherence times due to NaNs, missing values, zeros, etc...

Start by loading the BARREL single-payload data that's had the artifacts
removed (e.g. solar flares) using load_barrel_data_noartifacts.pro. NOTE:
this code once again removes the solar flares...not necessary. It's basically
just a load program that turns the ascii files into tplot variables.

Now, Lei's program doesn't like data gaps, whether they be NaNs, zeros,
interpolated lines, etc. So, the best bet I found was to fill them with
uncorrelated, amplitude-matched data. This is done with fill_with_uncorrelated_data.pro.

I then interpolate the two single-payload data onto a common timebase.
The cross-spectra are calculated with the idea of measuring ULF waves of <2 mHz
(Hartinger15 "The global structure"). 2 mHz = 8.333 min period. I'm interested
in periods from roughly 10-60 min. Shorter periods seem to be very difficult to
identify with this methodology for most balloon separations, though I should probably
look into this more closely.

For Lei's program (dynamic_cross_spec_tplot) I use a window size of 120 min. I was originally keeping this
number >> 60 min so that bpass.pro wouldn't freak out with edge effects. HOWEVER,
this may no longer be necessary. TEST WITH A SMALLER VALUE.

Parameters vary by run. Example parameters are:
  window = 60.*window_minutes
  lag = window/8.
  coherence_time = window*2.5

I'm taking the output of Lei's program and turning the y-axis (v-values) into
period measured in minutes. This is much more convenient for visualization.
I next manually change NaN coherence values to extremely low coherence values (like 0.001).

The coherence plots are very noisy, and so I run results through IDL's mean_filter to remove salt/pepper noise. I had originally tried Kyle Murphy's suggested bpass.pro, but had little luck with it. IDL's mean filter works very well.

At this stage, I'm not filtering out any values below a minimum coherence value.

Finally, the coherence files are saved as AB.tplot, where A is barrel payload 1
and B is payload 2. These files also contain the relative distance from the plasmapause,
which is loaded from load_barrel_plasmapause_distance.pro


Next, I load up these files with extract_timeseries_from_coherence_files.pro.
This program attempts to extract a plottable value from the coherence spectra
that I'll slap into the dial plots. The best approach so far seems to be
to calculate an average coherence from 10-60 min periods using a sliding
window ("sliding average"). Compared to the same technique but without the sliding window
("normal average"), this is less susceptible to remaining short-duration coherence "spikes" that have
somehow not been weeded out by IDL's median filter, called previously.

I identify these spikes by calculating the ratio of the "normal average"
to the "sliding average". Any values over 1.05 are removed.

Next, I remove all coherence values when one or both of the payload Lshells
is undefined. I can't plot these on the dial plots, so no reason to keep them.
(I may ultimately have some interest in plotting these, but I haven't dealt with
that yet). I'm also removing values where delta-MLT > ?? (e.g. 6 hrs)

Now, I take the "sliding average" coherence values and input them into
timeseries_reduce_to_pk_and_npk.pro for time chunks of dt=?? (e.g. 3600 seconds).
This finds the peak and %occurrence values in each dt. This data is ultimately
used in the dial plots.

This also gives me the new timebase defined by "dt", which I interpolate all
Lshell and MLT (including delta values) to.

Next, I use the "dt-based" data as an input into percentoccurrence_L_MLT_calculate.pro.
This uses histograms to put the timeseries data into [L,M] grid array of size
L=number Lshells, m=number MLTs.

The general above procedure is calculated for each payload combination.
I then average the percent occurrence and peak values over all the combinations.
After eliminating low count sectors, I then create the dial plots and also
rectangular plots, if desired.




***************
NEW - need to add
***************
from py_filter_barrel_by_ulf_period.pro
# Create filtered single payload plots with select ULF freq range.
# These are used to filter to times of sufficient activity.
pmin = 20.*60.
pmax = 25.*60.
for payload in plds:
    result = run.filter_barrel_by_ulf_period(payload, dates, pmin, pmax)


pro combine_coh_spectra --> combines all the coherence spectra into a single spectra. 
