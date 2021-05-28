"""
Produces dial plots (L, MLT) of spacecraft locations, FIREBIRD CubeSats, BARREL balloons
either at a regular time cadence or at times of the FIREBIRD/RBSP conjunctions (default).




------------------------------------------------------
Note on various payloads:

-ELFIN (Angeloupolos CubeSats that measure energetic precip).
Data availability at https://elfin-data.epss.ucla.edu/tohban_reports/tohban_report_010620.txt
There may be a few conjunctions where useful ELFIN data exists.

-PROBA-V (small sat, vegetation imager). Has energetic particle precip capabilities.
Not yet sure if this will be useful.
------------------------------------------------------

Written by AWB, April, 2020


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




"""
#Load all the BARREL data

barrel_mission2_ephem_allpayloads.tplot
barrel_mission3_ephem_allpayloads.tplot

BARREL 2014 mission
p2 = ['2T','2I','2K','2L','2M','2N','2O','2P','2Q','2W','2X','2Y','2A','2B','2C','2D','2E','2F']
BARREL 2015 mission (over before FIREBIRD mission starts)
p3 = ['3A','3D','3G','3B','3E']


BARREL 2013 mission
p1 = ['1B','1D','1I','1G','1C','1H','1A','1J','1K','1M','1O','1Q','1R','1S','1T','1U','1V']
p1s = []
for count,i in enumerate(p1):
    p1s.append("$"+p1[count]+"$")



fn = 'barrel_mission1_ephem_allpayloads.tplot'
pytplot.tplot_restore(pathbarrel+fn)

#Get the times for the first BARREL mission
tn = pytplot.tplot_names()
d = pytplot.get_data('L_Kp2_'+p1[0]+'_interp')
bar1t = d[0]


#Turn BARREL times into datetime list
bar1tt = np.ndarray.tolist(bar1t)
bar1t_dt = []
for i in bar1tt:
    bar1t_dt.append(datetime.datetime.fromtimestamp(i))


#Now load the data for each payload and append to array
dat1L = []
for i in p1:
    d = pytplot.get_data('L_Kp2_'+i+'_interp')
    tmp = np.ndarray.tolist(d[1])
    dat1L.append([tmp])

dat1MLT = []
for i in p1:
    d = pytplot.get_data('MLT_Kp2_'+i+'_interp')
    tmp = np.ndarray.tolist(d[1])
    dat1MLT.append([tmp])

dat1L = np.squeeze(dat1L)
np.shape(dat1L)
dat1MLT = np.squeeze(dat1MLT)
np.shape(dat1MLT)

#plot = plt.scatter(bar1t,dat1L[1])
#plot = plt.scatter(bar1t,dat1MLT[1])


"""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
BARREL 2016 mission
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


p4 = ['4A','4D','4G','4B','4E','4H']
p4s = []
for count,i in enumerate(p4):
    p4s.append("$"+p4[count]+"$")


fn = 'barrel_mission4_ephem_allpayloads.tplot'
pytplot.tplot_restore(pathbarrel+fn)

#Get the times for the first BARREL mission. All payloads have been interpolated to a common time base
tn = pytplot.tplot_names()
d = pytplot.get_data('L_Kp2_'+p4[0]+'_interp')
bar4t = d[0]


#Turn BARREL times into datetime list
bar4tt = np.ndarray.tolist(bar4t)
bar4t_dt = []
for i in bar4tt:
    bar4t_dt.append(datetime.datetime.fromtimestamp(i))


#Now load the data for each payload and append to array
dat4L = []
for i in p4:
    d = pytplot.get_data('L_Kp2_'+i+'_interp')
    tmp = np.ndarray.tolist(d[1])
    dat4L.append([tmp])

dat4MLT = []
for i in p4:
    d = pytplot.get_data('MLT_Kp2_'+i+'_interp')
    tmp = np.ndarray.tolist(d[1])
    dat4MLT.append([tmp])

dat4L = np.squeeze(dat4L)
np.shape(dat4L)
dat4MLT = np.squeeze(dat4MLT)
np.shape(dat4MLT)








path = "/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_Colpitts_Chen/satellite_ephemeris_cdfs/"

#Load all the CDFs
#...all the CDF files (SSCWeb) during the duration of the
#...FIREBIRD II mission (2015-01-01 to 2020-01-01)

arase = pycdf.CDF(path+"arase_20200327104526_88419.cdf")
c1 = pycdf.CDF(path+"cluster1_20200327104616_89403.cdf")
#****CLUSTER SATS OVERLAP. ONLY PLOT C1
#c2 = pycdf.CDF(path+"cluster2_20200327104648_89871.cdf")
#c3 = pycdf.CDF(path+"cluster3_20200327104720_90676.cdf")
#c4 = pycdf.CDF(path+"cluster4_20200327104808_91312.cdf")
mms1 = pycdf.CDF(path+"mms1_20200327104936_92464.cdf")
#mms2 = pycdf.CDF(path+"mms2_20200327105034_93233.cdf")
#mms3 = pycdf.CDF(path+"mms3_20200327105107_93671.cdf")
#mms4 = pycdf.CDF(path+"mms4_20200327105139_94139.cdf")
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

satlabels = ["AR","CL","MMS","RBa","RBb","THade","THb","THc","AC6a","AC6b","NOAA15","NOAA16","NOAA17","NOAA18","NOAA19","NOAA20","MOP1b","MOP2a","MOPc"]
colors = ["red","brown","black","blue","blue","teal","teal","teal","red","red","green","green","green","green","green","green","green","green","green"]

markers2 = []
markers2.append(["$"+q+"$" for q in satlabels])
markers2 = markers2[0]

#List of all the CDF files
cdfs = [arase,c1,mms1,rba,rbb,tha,thb,thc,ac6a,ac6b,noaa15,noaa16,noaa17,noaa18,noaa19,noaa20,metop1b,metop2a,metopc]








#-------TESTING---------
#Noon test for RBSPa
#start = datetime.datetime(2017, 8, 1, 1, 14)
#Midnight test for RBSPa
#start = datetime.datetime(2017, 8, 1, 8, 38)
#18 MLT test for RBSPa
#start = datetime.datetime(2017, 8, 1, 7, 50)
#stop =  datetime.datetime(2016, 10, 1, 1, 10)

"""
#----------------------------------------------------------------------------
#Use this if wanting to produce plots at a set cadence during a set timerange
start = datetime.datetime(2017, 8, 1, 6, 0)
stop = datetime.datetime(2017, 8, 1, 23, 59)

#Determine the times to iterate over
dt = 30  #minutes b/t each plot
ntimes = math.floor((stop - start).seconds/60/dt)
tfinal = [start]
newtime = start
for i in range(ntimes):
    newtime = newtime + datetime.timedelta(minutes=dt)
    print(newtime)
    tfinal.append(newtime)
#----------------------------------------------------------------------------
"""

#----------------------------------------------------------------------------
#Use this if wanting to produce plots only during the times of conjunctions.


lmin = 0
lmax = 12
mltmin = 0
mltmax = 24

rbaf3_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"3", "hires":"1"})
rbaf4_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"4", "hires":"1"})
rbbf3_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"3", "hires":"1"})
rbbf4_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"4", "hires":"1"})


rbaf3 = rbaf3_obj.read_conjunction_file()
keyv = list(rbaf3.keys())
rbaf3_1 = rbaf3_obj.filter_based_on_range(rbaf3, "Lrb", lmin, lmax)
rbaf3_2 = rbaf3_obj.filter_based_on_range(rbaf3_1, "MLTrb", mltmin, mltmax)
rbaf3_3 = rbaf3_obj.filter_based_on_range(rbaf3_2, "bursttotalmin", 1, 10000)
finv3a = rbaf3_3

rbaf4 = rbaf4_obj.read_conjunction_file()
rbaf4_1 = rbaf4_obj.filter_based_on_range(rbaf4, "Lrb", lmin, lmax)
rbaf4_2 = rbaf4_obj.filter_based_on_range(rbaf4_1, "MLTrb", mltmin, mltmax)
rbaf4_3 = rbaf4_obj.filter_based_on_range(rbaf4_2, "bursttotalmin", 1, 10000)
finv4a = rbaf4_3

rbbf3 = rbbf3_obj.read_conjunction_file()
rbbf3_1 = rbbf3_obj.filter_based_on_range(rbbf3, "Lrb", lmin, lmax)
rbbf3_2 = rbbf3_obj.filter_based_on_range(rbbf3_1, "MLTrb", mltmin, mltmax)
rbbf3_3 = rbbf3_obj.filter_based_on_range(rbbf3_2, "bursttotalmin", 1, 10000)
finv3b = rbbf3_3

rbbf4 = rbbf4_obj.read_conjunction_file()
rbbf4_1 = rbbf4_obj.filter_based_on_range(rbbf4, "Lrb", lmin, lmax)
rbbf4_2 = rbbf4_obj.filter_based_on_range(rbbf4_1, "MLTrb", mltmin, mltmax)
rbbf4_3 = rbbf4_obj.filter_based_on_range(rbbf4_2, "bursttotalmin", 1, 10000)
finv4b = rbbf4_3




#Reduce these arrays by getting rid of null string elements (these have been filtered out)
good = np.where(np.asarray(finv3a['datetime_min']) != "")
a3a = []
L3a_rb = []
L3a_fb = []
MLT3a_rb = []
MLT3a_fb = []
btot3a_fb = []
fluxmax3a_fb = []
maxE3a_fb = []
maxB3a_fb = []
for i in good[0]:
    a3a.append(finv3a['datetime_min'][i])
    L3a_rb.append(rbaf3['Lrb'][i])
    L3a_fb.append(rbaf3['Lfb'][i])
    MLT3a_rb.append(rbaf3['MLTrb'][i])
    MLT3a_fb.append(rbaf3['MLTfb'][i])
    btot3a_fb.append(rbaf3['bursttotalmin'][i])
    fluxmax3a_fb.append(rbaf3['fbmaxflux'][i])
    maxE3a_fb.append(rbaf3['rbmaxampE'][i])
    maxB3a_fb.append(rbaf3['rbmaxampB'][i])


good = np.where(np.asarray(finv3b['datetime_min']) != "")
a3b = []
L3b_rb = []
L3b_fb = []
MLT3b_rb = []
MLT3b_fb = []
btot3b_fb = []
fluxmax3b_fb = []
maxE3b_fb = []
maxB3b_fb = []
for i in good[0]:
    a3b.append(finv3b['datetime_min'][i])
    L3b_rb.append(rbbf3['Lrb'][i])
    L3b_fb.append(rbbf3['Lfb'][i])
    MLT3b_rb.append(rbbf3['MLTrb'][i])
    MLT3b_fb.append(rbbf3['MLTfb'][i])
    btot3b_fb.append(rbbf3['bursttotalmin'][i])
    fluxmax3b_fb.append(rbbf3['fbmaxflux'][i])
    maxE3b_fb.append(rbbf3['rbmaxampE'][i])
    maxB3b_fb.append(rbbf3['rbmaxampB'][i])

good = np.where(np.asarray(finv4a['datetime_min']) != "")
a4a = []
L4a_rb = []
L4a_fb = []
MLT4a_rb = []
MLT4a_fb = []
btot4a_fb = []
fluxmax4a_fb = []
maxE4a_fb = []
maxB4a_fb = []
for i in good[0]:
    a4a.append(finv4a['datetime_min'][i])
    L4a_rb.append(rbaf4['Lrb'][i])
    L4a_fb.append(rbaf4['Lfb'][i])
    MLT4a_rb.append(rbaf4['MLTrb'][i])
    MLT4a_fb.append(rbaf4['MLTfb'][i])
    btot4a_fb.append(rbaf4['bursttotalmin'][i])
    fluxmax4a_fb.append(rbaf4['fbmaxflux'][i])
    maxE4a_fb.append(rbaf4['rbmaxampE'][i])
    maxB4a_fb.append(rbaf4['rbmaxampB'][i])

good = np.where(np.asarray(finv4b['datetime_min']) != "")
a4b = []
L4b_rb = []
L4b_fb = []
MLT4b_rb = []
MLT4b_fb = []
btot4b_fb = []
fluxmax4b_fb = []
maxE4b_fb = []
maxB4b_fb = []
for i in good[0]:
    a4b.append(finv4b['datetime_min'][i])
    L4b_rb.append(rbbf4['Lrb'][i])
    L4b_fb.append(rbbf4['Lfb'][i])
    MLT4b_rb.append(rbbf4['MLTrb'][i])
    MLT4b_fb.append(rbbf4['MLTfb'][i])
    btot4b_fb.append(rbbf4['bursttotalmin'][i])
    fluxmax4b_fb.append(rbbf4['fbmaxflux'][i])
    maxE4b_fb.append(rbbf4['rbmaxampE'][i])
    maxB4b_fb.append(rbbf4['rbmaxampB'][i])




#Now we have to take all these conjunction times and put them into a datetime list.
a3af = []
for i in a3a:
    a3af.append(datetime.datetime.strptime(i, '%Y-%m-%d/%H:%M:%S'))
a3bf = []
for i in a3b:
    a3bf.append(datetime.datetime.strptime(i, '%Y-%m-%d/%H:%M:%S'))
a4af = []
for i in a4a:
    a4af.append(datetime.datetime.strptime(i, '%Y-%m-%d/%H:%M:%S'))
a4bf = []
for i in a4b:
    a4bf.append(datetime.datetime.strptime(i, '%Y-%m-%d/%H:%M:%S'))



FB_names = []
RB_names = []
for i in range(len(a3af)): FB_names.append("F3")
for i in range(len(a3bf)): FB_names.append("F3")
for i in range(len(a4af)): FB_names.append("F4")
for i in range(len(a4bf)): FB_names.append("F4")
for i in range(len(a3af)): RB_names.append("RBa")
for i in range(len(a3bf)): RB_names.append("RBb")
for i in range(len(a4af)): RB_names.append("RBa")
for i in range(len(a4bf)): RB_names.append("RBb")

#concatenate all of the arrays
tfinal = a3af + a3bf + a4af + a4bf
FB_Lfinal = L3a_fb + L3b_fb + L4a_fb + L4b_fb
RB_Lfinal = L3a_rb + L3b_rb + L4a_rb + L4b_rb
mtmp = MLT3a_fb + MLT3b_fb + MLT4a_fb + MLT4b_fb
FB_MLTfinal = []
for i in mtmp: FB_MLTfinal.append(math.radians(360*(i/24)-180.))
mtmp = MLT3a_rb + MLT3b_rb + MLT4a_rb + MLT4b_rb
RB_MLTfinal = []
for i in mtmp: RB_MLTfinal.append(math.radians(360*(i/24)-180.))
btotfin = btot3a_fb + btot3b_fb + btot4a_fb + btot4b_fb
fluxmaxfb = fluxmax3a_fb + fluxmax3b_fb + fluxmax4a_fb + fluxmax4b_fb
maxE = maxE3a_fb + maxE3b_fb + maxE4a_fb + maxE4b_fb
maxB = maxB3a_fb + maxB3b_fb + maxB4a_fb + maxB4b_fb

#make a title string that has various values

strvals = []
for i in range(len(btotfin)):
    if not math.isnan(btotfin[i]):
        goo1 = "Bursttot=" + str(round(btotfin[i])) + ' min'
    else:
        goo1 = "Bursttot=NaN min"
    if not math.isnan(fluxmaxfb[i]):
        goo2 = "fluxmax=" + str(round(fluxmaxfb[i])) + ' #/s-cm2-sr'
    else:
        goo2 = "fluxmax=NaN #/s-cm2-sr"
    if not math.isnan(maxE[i]):
        goo3 = "Emax=" + str(round(maxE[i])) + ' mV/m'
    else:
        goo3 = "Emax=NaN mV/m"
    if not math.isnan(maxB[i]):
        goo4 = "Bmax=" + str(round(maxB[i])) + ' pT'
    else:
        goo4 = "Bmax=NaN pT"
    goo = goo1 + ',\n' + goo2 + ',\n' + goo3 + ',\n' + goo4
    strvals.append(goo)


#----------------------------------------------------------------------------





#Basic plot structure
r = np.arange(0, 12, 1)
theta = 2 * np.pi * r

#BARREL test for mission 4 data
#datetime.datetime(2016, 8, 14, 0, 52)


initialtimeindex = 0
#initialtimeindex = 10  #for testing BARREL plotting
i=initialtimeindex
for t in tfinal[initialtimeindex:]:


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
    ax.set_title("L vs MLT "+t.strftime("(%Y-%m-%d %H:%M:%S)"),fontdict=fd1)
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
    ax.scatter([FB_MLTfinal[i],FB_MLTfinal[i]],[FB_Lfinal[i],FB_Lfinal[i]],s=[500,500],marker="$"+FB_names[i]+"$",clip_on=False,alpha=0.15)
    #ax.scatter([fbrad4,fbrad4],[fbl4,fbl4],s=[500,500],marker="$FB4$",clip_on=False)

    #---FOR A TEST PLOT RB LFINAL AND MLTFINAL (NOTE: THIS IS ONLY FOR THE SATELLITE OF THE CONJUNCTION PAIR)
    #ax.scatter([RB_MLTfinal[i],RB_MLTfinal[i]],[RB_Lfinal[i],RB_Lfinal[i]],s=[500,500],marker="X",clip_on=False,alpha=0.15)


    #Overplot the rough location of the FIREBIRD cubesat that is NOT in conjunction.
    #NOTE: ---I MAY NEED TO INTERPOLATE THESE TO HIGHER CADENCE



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


    #----CHECK TO SEE IF THIS IS CORRECT
    i=i+1


    """""""""""""""""""""""""""""""""""""""""""""""
    Overplot all BARREL locations for 2016 campaign
    """""""""""""""""""""""""""""""""""""""""""""""

    for j in range(len(p4)):

        #Grab start/stop indices for each balloon
        startind = bisect.bisect_left(bar4t_dt,t)

        #Only plot if we have balloon data within time range
        if startind != len(bar4t_dt):
            dttst = bar4t_dt[startind] - t
            #make sure BARREL times are close to time of conjunction. Mostly I test this to avoid having the startind=0,
            #which can select BARREL data that are months before the current conjunction.
            if dttst.total_seconds() < 1000:
                l = dat4L[j][startind]
                mlt = dat4MLT[j][startind]

                angle_tmp = mlt*(360/24.)
                angle_tmp2 = math.radians(angle_tmp)

                #Plot sc location
                ax.scatter([angle_tmp2,angle_tmp2],[l,l],s=[500,500],marker=p4s[j],color=colors[j],clip_on=False,alpha=0.15)
                print("Here'")



    #Overplot sc location for each payload for current timerange
    for j in range(len(cdfs)):

        #Grab start/stop indices for each CDF file
        startind = bisect.bisect_left(cdfs[j]["Epoch"],t)


        #Only plot if we have satellite data within time range
        if startind != len(cdfs[j]['L_VALUE']):

            epochtmp = cdfs[j]["Epoch"][startind]
            #sattimetmp = pycdf.Library.epoch_to_datetime(epochtmp)

            dttst = epochtmp - t
            satprintv = satlabels[j]
            #make sure satellite times are close to time of conjunction. Mostly I test this to avoid having the startind=0,
            #which can select sat data that are months before the current conjunction.
            if dttst.total_seconds() < 1000:

                # then grab the data we want
                l = cdfs[j]['L_VALUE'][startind]
                gse = 6370*cdfs[j]['XYZ_GSE'][startind]


                #Calculate MLT from longitude
                angle_tmp = math.degrees(np.arctan2(gse[1],gse[0]))
                angle_tmp = angle_tmp #- 180
                angle_tmp2 = math.radians(angle_tmp)
                #for i in mtmp: RB_MLTfinal.append(math.radians(360*(i/24)))
                #ax.scatter([RB_MLTfinal[i],RB_MLTfinal[i]],[RB_Lfinal[i],RB_Lfinal[i]],s=[500,500],marker="X",clip_on=False,alpha=0.15)


                #Plot sc location
                ax.scatter([angle_tmp2,angle_tmp2],[l,l],s=[500,500],marker=markers2[j],color=colors[j],clip_on=False,alpha=0.15)


    #plt.show()
    FB_names[i]
    filenamesv = RB_names[i]+"_"+FB_names[i]+"_"+ t.strftime("%Y%m%d_%H%M%S")
    plt.savefig("/Users/aaronbreneman/Desktop/"+filenamesv)
    print("finished with time t")
    plt.close()

#plt.show()
