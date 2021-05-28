"""
Produces dial plots (L, MLT) of spacecraft locations, FIREBIRD CubeSats, BARREL balloons, etc
at a specified time range for each payload. This timerange is intended to represent the time each
payload observes chorus or microburst precip.


Written by AWB, Dec, 2020

"""

import os
os.environ["CDF_LIB"] = "~/CDF/lib"
from spacepy import pycdf
import datetime
import bisect
import math
import matplotlib.pyplot as plt
import numpy as np
import pytplot

import sys
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_Colpitts_Chen/')
from Rbsp_fb_filter_conjunctions import Rbsp_fb_filter_conjunctions
from Load_firebird_data import Load_firebird_data




pathbarrel = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_Colpitts_Chen/barrel_ephemeris/'





path = "/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_Colpitts_Chen/satellite_ephemeris_cdfs/"

#Load all the CDFs
#...all the CDF files (SSCWeb) during the duration of the
#...FIREBIRD II mission (2015-01-01 to 2020-01-01)

arase = pycdf.CDF(path+"arase_20200327104526_88419.cdf")
c1 = pycdf.CDF(path+"cluster1_20200327104616_89403.cdf")
mms1 = pycdf.CDF(path+"mms1_20200327104936_92464.cdf")
rba = pycdf.CDF(path+"rbspa_20200327105219_94683.cdf")
rbb = pycdf.CDF(path+"rbspb_20200327105258_95241.cdf")
tha = pycdf.CDF(path+"themisa_20200327104047_82094.cdf") #A,D,E always in close orbit, so I'll only plot A
thb = pycdf.CDF(path+"themisb_20200327104245_83794.cdf") #B,C are ARTEMIS
thc = pycdf.CDF(path+"themisc_20200327104318_84229.cdf")
ac6a = pycdf.CDF(path+"aerocube6b_20201204112040_82593.cdf")
ac6b = pycdf.CDF(path+"aerocube6a_20201204112040_82593.cdf")
#thd = pycdf.CDF(path+"themisd_20200327104401_85684.cdf")
#the = pycdf.CDF(path+"themise_20200327104435_87026.cdf")

noaa15 = pycdf.CDF(path+"noaa15_20201204113810_88865.cdf")
noaa16 = pycdf.CDF(path+"noaa16_20201204113810_88865.cdf")
noaa17 = pycdf.CDF(path+"noaa17_20201204113810_88865.cdf")
noaa18 = pycdf.CDF(path+"noaa18_20201204113810_88865.cdf")
noaa19 = pycdf.CDF(path+"noaa19_20201204113810_88865.cdf")
noaa20 = pycdf.CDF(path+"noaa20_20201204113810_88865.cdf")
metop1b = pycdf.CDF(path+"metop1b_20201204113810_88865.cdf")
metop2a = pycdf.CDF(path+"metop2a_20201204113810_88865.cdf")
metopc = pycdf.CDF(path+"metopc_20201204113810_88865.cdf")

satlabels = ["AR","CL","MMS","RBa","RBb","THade","THb","THc"]
colors = ["red","brown","black","blue","blue","teal","teal","teal"]

markers2 = []
markers2.append(["$"+q+"$" for q in satlabels])
markers2 = markers2[0]

cdfs = [arase,c1,mms1,rba,rbb,tha,thb,thc]
chorus=[2,    0,  0,  1,  1,  0,  0,  0]  #1 = chorus observed; 2 = chorus maybe?; 3 = no chorus
colorplot = ["black","red","blue"]

##Select payloads to plot
#payloadplot = ["AR","MMS","RBa","RBb"]
#Select timerange each payload observes chorus

#Absolute start and stop times for plotted data points
t0 = datetime.datetime(2016,5,30,10,00)
t1 = datetime.datetime(2016,5,30,11,00)

start = [datetime.datetime(2017, 11, 28, 12, 00),  #arase
         datetime.datetime(2017, 11, 28, 00, 00),  #Cluster
         datetime.datetime(2017, 11, 28, 00, 00),  #MMS
         datetime.datetime(2017, 11, 28, 11, 30),  #RBa
         datetime.datetime(2017, 11, 28, 12, 30),  #RBb
         datetime.datetime(2017, 11, 28, 00, 00),  #THa,d,e
         datetime.datetime(2017, 11, 28, 00, 00),  #THb
         datetime.datetime(2017, 11, 28, 00, 00)  #THc
         ]

stop =  [datetime.datetime(2017, 11, 28, 14, 30),  #arase
         datetime.datetime(2017, 11, 28, 00, 00),  #Cluster
         datetime.datetime(2017, 11, 28, 00, 00),  #MMS
         datetime.datetime(2017, 11, 28, 14, 30),  #RBa
         datetime.datetime(2017, 11, 28, 15, 30),  #RBb
         datetime.datetime(2017, 11, 28, 00, 00),  #THa,d,e
         datetime.datetime(2017, 11, 28, 00, 00),  #THb
         datetime.datetime(2017, 11, 28, 00, 00)  #THc
        ]


#Basic plot structure
r = np.arange(0, 12, 1)
theta = 2 * np.pi * r



"""

#Get FIREBIRD data for current conjunction for payload that is NOT in conjunction.
#e.g. for a RBSPa-FU3 conjunction, load the FU4 data so we can plot it on dial plot
    #-----LOAD CDF FILES HERE
    pathFU = " "
    if FB_names[i] == 'F3':
        pathFU = '/Users/aaronbreneman/data/firebird/FU4/'+t.strftime("%Y")+'/'+"FU4_context_"+t.strftime("%Y%m%d")+"_v01.cdf"
    else:
        pathFU = '/Users/aaronbreneman/data/firebird/FU3/'+t.strftime("%Y")+'/'+"FU3_context_"+t.strftime("%Y%m%d")+"_v01.cdf"

    startindfb_other = -1

    if os.path.exists(pathFU):
        FUother = pycdf.CDF(pathFU)
        startindfb_other = bisect.bisect_left(FUother["epoch"],t)

"""



ax = plt.subplot(111, projection='polar')
ax.set_xlim([0,2*np.pi])
ax.set_ylim([0,12])
ax.plot(theta, r)
ax.set_xticklabels([12,15,18,21,24,3,6,9])
ax.set_theta_direction(1)  #counterclockwise sense
ax.set_theta_zero_location('W')


#Plot the Earth
ax.scatter([0,0],[0,0],s=[1600,1600],marker=".")
ax.grid(True)



fd1 = {'fontsize':8,
       'fontweight':'bold',
       'verticalalignment':'top',
       'horizontalalignment':'center'}
#ax.set_title("L vs MLT "+t.strftime("(%Y-%m-%d %H:%M:%S)"),fontdict=fd1)
fd2 = {'fontsize':8,
       'verticalalignment':'bottom',
       'horizontalalignment':'left'}
#ax.set_title(strvals[i], fontdict=fd2)



"""
#Extract FIREBIRD positions for current timerange
startind_fb3 = bisect.bisect_left(fbdat3["time"],t)
fbl3 = fbdat3['mcilwainl'][startind_fb3]
fbmlt3 = fbdat3['mlt'][startind_fb3]
fb360_3 = 360*(fbmlt3/24) + 180
fbrad3 = math.radians(fb360_3)


startind_fb4 = bisect.bisect_left(fbdat4["time"],t)
fbl4 = fbdat4['mcilwainl'][startind_fb4]
fbmlt4 = fbdat4['mlt'][startind_fb4]
fb360_4 = 360*(fbmlt4/24) + 180
fbrad4 = math.radians(fb360_4)
"""
#Plot FIREBIRD location
#    ax.scatter([fbrad3,fbrad3],[fbl3,fbl3],s=[500,500],marker="$FB3$",clip_on=False)
#    ax.scatter([fbrad4,fbrad4],[fbl4,fbl4],s=[500,500],marker="$FB4$",clip_on=False)
#ax.scatter([FB_MLTfinal[i],FB_MLTfinal[i]],[FB_Lfinal[i],FB_Lfinal[i]],s=[500,500],marker="$"+FB_names[i]+"$",clip_on=False,alpha=0.15)
#ax.scatter([fbrad4,fbrad4],[fbl4,fbl4],s=[500,500],marker="$FB4$",clip_on=False)

#---FOR A TEST PLOT RB LFINAL AND MLTFINAL (NOTE: THIS IS ONLY FOR THE SATELLITE OF THE CONJUNCTION PAIR)
#ax.scatter([RB_MLTfinal[i],RB_MLTfinal[i]],[RB_Lfinal[i],RB_Lfinal[i]],s=[500,500],marker="X",clip_on=False,alpha=0.15)


#Overplot the rough location of the FIREBIRD cubesat that is NOT in conjunction.
#NOTE: ---I MAY NEED TO INTERPOLATE THESE TO HIGHER CADENCE


"""
#make sure times for FIREBIRD not in conjunction are close to time of conjunction.
lltst = len(FUother["epoch"])
slitst = startindfb_other
if startindfb_other != -1 and startindfb_other < len(FUother["epoch"]):
    timegoo = FUother["epoch"][startindfb_other]
    dttst = FUother["epoch"][startindfb_other] - t
    mlttst = FUother["MLT"][startindfb_other]
    ltst = FUother["McIlwainL"][startindfb_other]
    mltother = math.radians(360*(mlttst/24)-180.)

    if dttst.total_seconds() < 10:   #only consider plotting if there is data within 10 sec of the conjunction
        if FB_names[i] == 'F3':
            ax.scatter([mltother,mltother],[FUother["McIlwainL"][startindfb_other],FUother["McIlwainL"][startindfb_other]],s=[500,500],marker="$F_4$",clip_on=False,alpha=0.15)
        else:
            ax.scatter([mltother,mltother],[FUother["McIlwainL"][startindfb_other],FUother["McIlwainL"][startindfb_other]],s=[500,500],marker="$F_3$",clip_on=False,alpha=0.15)

"""



#Overplot sc location for each payload for current timerange
for j in range(len(cdfs)):

    j2 = j
    startind = 0
    stopind = 0
    #Grab start/stop indices for each CDF file
    startind = bisect.bisect_left(cdfs[j]["Epoch"],start[j])
    stopind = bisect.bisect_left(cdfs[j]["Epoch"],stop[j])

    t0ind = bisect.bisect_left(cdfs[j]["Epoch"],t0)
    t1ind = bisect.bisect_left(cdfs[j]["Epoch"],t1)

    #plot all trajectories whether they see chorus or not
    epochtmp = cdfs[j]["Epoch"][t0ind:t1ind]
    # then grab the data we want
    l = cdfs[j]['L_VALUE'][t0ind:t1ind]
    gse = 6370*cdfs[j]['XYZ_GSE'][t0ind:t1ind]

    #Calculate MLT from longitude
    for i in range(len(l)):
        angle_tmp = math.degrees(np.arctan2(gse[i,1],gse[i,0]))
        angle_tmp = angle_tmp #- 180
        angle_tmp2 = math.radians(angle_tmp)

        #Plot sc location
        if i == 0 and chorus[j] == 0: ax.scatter([angle_tmp2,angle_tmp2],[l[i],l[i]],s=[500,500],marker=markers2[j],color="black",clip_on=False,alpha=1.0)
        ax.scatter([angle_tmp2,angle_tmp2],[l[i],l[i]],s=[100,100],marker=".",color="black",clip_on=False,alpha=0.10)






    #Now plot data where chorus are observed or maybe observed
    #Only plot if we have satellite data within a finite time range
    if startind != len(cdfs[j]['L_VALUE']) and startind != stopind:

        epochtmp = cdfs[j]["Epoch"][startind:stopind]
        # then grab the data we want
        l = cdfs[j]['L_VALUE'][startind:stopind]
        gse = 6370*cdfs[j]['XYZ_GSE'][startind:stopind]


        #Calculate MLT from longitude
        for i in range(len(l)):
            angle_tmp = math.degrees(np.arctan2(gse[i,1],gse[i,0]))
            angle_tmp = angle_tmp #- 180
            angle_tmp2 = math.radians(angle_tmp)
            #for i in mtmp: RB_MLTfinal.append(math.radians(360*(i/24)))
            #ax.scatter([RB_MLTfinal[i],RB_MLTfinal[i]],[RB_Lfinal[i],RB_Lfinal[i]],s=[500,500],marker="X",clip_on=False,alpha=0.15)

            #Plot sc location
            if i == 0: ax.scatter([angle_tmp2,angle_tmp2],[l[i],l[i]],s=[500,500],marker=markers2[j],color="black",clip_on=False,alpha=1.0)
            ax.scatter([angle_tmp2,angle_tmp2],[l[i],l[i]],s=[500,500],marker=".",color=colorplot[chorus[j]],clip_on=False,alpha=0.10)


#plt.show()
#filenamesv = RB_names[i]+"_"+FB_names[i]+"_"+ t.strftime("%Y%m%d_%H%M%S")
#plt.savefig("/Users/aaronbreneman/Desktop/"+filenamesv)
#print("finished with time t")
plt.close()

#plt.show()
