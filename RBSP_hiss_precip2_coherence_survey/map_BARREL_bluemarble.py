#This program plots the barrel data on a blue marble polar projection map.
#It wouldn't take much to make this more general but for the moment it's plotting full days and just for a specific set of payloads. If you want to change the payloads make sure to also change the set of if statements at the begining of the for loop.

#This program also only seems to run in python and not ipython due to problems getting mpl_toolkits.basemap to install on mac osX. Hopefully this problem will be solved in future releases, but currently hasn't been.

#To run this program, in the comand line (not inside of python or ipython) type $python Jan_9_map.py

#version 1 
#Date - Jan 29 2016
#By Alexa Halford Alexa.Halford@gmail.com

#import date
import sys
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/python/spacepy/lib/python/')

import numpy as np
import datetime as dt
from datetime import timedelta
import os
#os.putenv("CDF_LIB", "~/CDF/LIB")
from spacepy import pycdf
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from matplotlib.cbook import get_sample_data
from matplotlib._png import read_png
from matplotlib.offsetbox import TextArea, DrawingArea, OffsetImage, \
    AnnotationBbox
#This just stores then the info about who wrote this code and what version it is in 
__version__ = 1.0
__author__ = 'A.J. Halford'

#Payloads I want plotted
#payload =  np.array([ '2I', '2K', '2L', '2X', '2W', '2T'])
payload =  np.array([ '1I', '1C', '1G'])
mkrcolor = np.array(['navy', 'orange', 'gold',  'red', 'lightblue',  'blue' ])        

#Days I want position plotted for
day = np.array([17])
year = '13'
month = '01'
#The colors for the stations (stcolor) and the text to state which station it is. 
txtcolor = 'lightslategray'
stcolor = 'g'
# set up orthographic map projection with
# perspective of satellite looking down at 50N, 100W.
# useing intermediate resolution (l = low, h = high I think) .
map = Basemap(projection='spstere',boundinglat=-65, lon_0=0,resolution='i')
map.bluemarble()

# draw the edge of the map projection region (the projection limb) # not used here as we're using bluemarble. 
#map.drawmapboundary(fill_color='aqua')

# draw lat/lon grid lines every 30 degrees.
map.drawmeridians(np.arange(0,360,30))
map.drawparallels(np.arange(-90,90,10))


for i in range(len(payload)):
    for j in range(len(day)):
        #Make sure we have the right sting. If I were to do this for a longer period of time, the same would need to be done for the month ect....
        if day[j] < 10:
            strday = '0' + np.str(np.int(day[j]))
        else:
            strday = np.str(day[j])
        #Read in the data and get the relavent data bits.
        payload_ephm = '~/Data/barrel/v05/l2/'+payload[i]+'/'+year+month+strday+'/bar_'+payload[i]+'_l2_ephm_20'+year+month+strday+'_v05.cdf'
        data = pycdf.CDF(payload_ephm)
        temptimeMAG = data['Epoch'][:]
        templat = data['GPS_Lat'][:]
        templon = data['GPS_Lon'][:]
        tempalt = data['GPS_Alt'][:]
        tempL2 = data['L_Kp2'][:]
        tempMLT2 = data['MLT_Kp2_T89c'][:]

        #Making sure that we are only plotting times that have good data since bad data is identified with numbers and not nans. 
        good = np.where(tempalt > 0.)
        mlt = tempMLT2[good]
        alt = tempalt[good]
        lat = templat[good]
        lon = templon[good]

        good = np.where(lat > -90)
        mlt = mlt[good]
        alt = alt[good]
        lat = lat[good]
        lon = lon[good]

        good = np.where(lon > -180)
        mlt = mlt[good]
        alt = alt[good]
        lat = lat[good]
        lon = lon[good]    

        # compute native map projection coordinates of lat/lon grid.
        x, y = map(lon, lat)
        #This was for debuging and making sure the lat and lons made sense
        #print 'payload id', payload[i], ' and day ', strday
        #print 'lon min max', min(lon), max(lon)
        #print 'lat min max', min(lat), max(lat)
        #print 'payload id', payload[i], ' and day ', strday
        # contour data over the map.

        #using scatter plots seemed to make the most sense and give the niceset looking plot
        cs = map.scatter(x,y,3,  marker='o',color=mkrcolor[i])
    #now that we've mapped all the different days label the payload at the end. 
    x, y = map(lon[-1]+2, lat[-1]+2)
    plt.annotate(payload[i], xy=(x, y), color = mkrcolor[i] )

#map.set_ylim([-90, 60])
#map.set_xlim([-180, 180])


#Add in some stations
#Halley VI
x, y= map(-26.66, -75.58)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('Halley VI', xy=(x, y), color = txtcolor )
#SANAE IV
x,y = map(-2.84,-74.67)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('SANAE IV', xy=(x, y), color = txtcolor )
#South pole
x,y = map(-180,-90)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('South Pole', xy=(x, y), color = txtcolor )
#McMurdo
x,y = map(166.7, -77.9)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('McMurdo', xy=(x, y), color = txtcolor )
#AGO P1
x,y = map(129.6,-83.9)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P1', xy=(x, y), color = txtcolor )
#AGO P2
x,y = map(-46.4,-85.7)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P2', xy=(x, y), color = txtcolor )
#AGO P3
x,y = map(28.6,-82.8)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P3', xy=(x, y), color = txtcolor )
#AGO P4
x,y = map(96.8,-82.0)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P4', xy=(x, y), color = txtcolor )
#AGO P5
x,y = map(123.5,-77.2)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P5', xy=(x, y), color = txtcolor )
#AGO P6
x,y = map(130,-69.5)
cs = map.scatter(x,y,10,  marker='h',color=stcolor)
plt.annotate('P6', xy=(x, y), color = txtcolor )

plt.show()
#explt.savefig('/Users/alexa/Desktop/Jan_7_9_map.ps')
plt.close()

#
