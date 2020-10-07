"""
Create a simple .txt file with the positions of **BOTH** FB CubeSats during every conjunction
defined from Mykhaylo Shumko's conjunction lists (e.g. FU4_RBSPB_conjunctions_dL10_dMLT10_hr.txt).
Code outputs a separate .txt file for each FB CubeSat. Each contains the location of that CubeSat during ALL
of the identified conjunctions (FU3-RBa + FU3-RBb + FU4-RBa + FU4-RBb).

Output designed to be used in dial_plot_spacecraft_location.py

This program exists for two reasons:
1) B/c I'd like to know the position of BOTH CubeSats during each defined conjunction. For example, both
CubeSats for a conjunction b/t FU3 and RBSPa.
2) I can get this position for each by calling Load_firebird_data.py, but this takes a VERY long time
to run through all the conjunctions. This code will create a single text file that can be loaded with these
positions for all conjunctions.


NOTE 1: very often there's no HIRES data for the other CubeSat for any time near the conjunction.
For ex, for a FU3 + RBSPa conjunction, FU4 may or may not have hires data anywhere near the conjunction.
Frequently the nearest data is on the opposite side of the Earth. The L, MLT and time differences are all
recorded so that the data can be appropriately filtered at a later stage.

NOTE 2: The Shumko files have the start and end time of each conjunction (e.g. for +/- 1 L and 1 MLT),
and the L and MLT values given are the MEAN values during the conjunction. They also return
the minimum separation in km.

"""


import datetime
import sys
import bisect
import numpy as np
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')
from Rbsp_fb_filter_conjunctions import Rbsp_fb_filter_conjunctions
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')
from Load_firebird_data import Load_firebird_data


#Load the conjunction lists without any filtering.
lmin = 0
lmax = 1000000
mltmin = 0
mltmax = 24

rbaf3_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"3"})
rbaf4_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"4"})
rbbf3_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"3"})
rbbf4_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"4"})
rbaf3 = rbaf3_obj.read_conjunction_file()
rbaf4 = rbaf4_obj.read_conjunction_file()
rbbf3 = rbbf3_obj.read_conjunction_file()
rbbf4 = rbbf4_obj.read_conjunction_file()

f3a = []
for i in range(len(rbaf3['datetime'])): f3a.append('FB3_RBSPa')
f3b = []
for i in range(len(rbbf3['datetime'])): f3b.append('FB3_RBSPb')
f4a = []
for i in range(len(rbaf4['datetime'])): f4a.append('FB4_RBSPa')
f4b = []
for i in range(len(rbbf4['datetime'])): f4b.append('FB4_RBSPb')


#glom together all the conjunction times/locations.
payloads = f3a + f3b + f4a + f4b
tconj = rbaf3['datetime'] + rbbf3['datetime'] + rbaf4['datetime'] + rbbf4['datetime']
lconj = rbaf3['L'] + rbbf3['L'] + rbaf4['L'] + rbbf4['L']
mltconj = rbaf3['MLT'] + rbbf3['MLT'] + rbaf4['MLT'] + rbbf4['MLT']



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Now that we have all the conjunction times, get the FB coordinates for all the conjunctions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

for i in range(len(tconj)):

    date = datetime.datetime.strptime(tconj[i],'%Y-%m-%d/%H:%M:%S')
    params = {'type':'hires','cubesat':'FU3','date':date.date()}

    fb = Load_firebird_data(params)
    result = fb.download_file()

    badresult = result == 'No FIREBIRD file online or local for this date'
    if badresult:
        tfin = np.nan
        lval = np.nan
        mltval = np.nan
    else:
        #Find the conjunction time in the FIREBIRD daily data
        tstr = []
        for j in result['time']:
            tstr.append(datetime.datetime.strftime(j,'%Y-%m-%d/%H:%M:%S'))


        #Extract FIREBIRD position data for time closest to conjunction
        startind = bisect.bisect_left(tstr,tconj[i])

        if startind >= len(result['time']): startind = startind - 1

        tfin = result['time'][startind]
        lval = result['mcilwainl'][startind]
        mltval = result['mlt'][startind]

        #Comparison of RBSP location during closest conjunction
        trbsp = tconj[i]
        lrbsp = lconj[i]
        mltrbsp = mltconj[i]

        #compute delta time difference b/t conjunction and selected FIREBIRD sat.
        #This is useful if we're comparing a FU3-RBSP conjunction to FU4 location. The
        #nearest FU4 data may be hours away from conjunction time.


        tdiff = tfin - datetime.datetime.strptime(trbsp,'%Y-%m-%d/%H:%M:%S')
        #if abs(tdiff.total_seconds()) > 60:
        #    tfin = np.nan
        #    lval = np.nan
        #    mltval = np.nan



    print('******************')
    print('Conjunctions time defined from FB3 list')
    print('No simultaneous conjunctions = ', badresult)
    print("We're comparing conjunction b/t ", payloads[i])
    print('tdiff = ', tdiff.total_seconds(), ' sec')
    print('Conjunction time (FB) = ', tfin)
    print('Conjunction time (RBSP) = ', trbsp)
    print('L FB (mean value during conjunction) = ', lval)
    print('L RBSP = ', lrbsp)
    print('MLT FB (mean value during conjunction) = ', mltval)
    print('MLT RBSP = ', mltrbsp)

    ltmpp = 2



