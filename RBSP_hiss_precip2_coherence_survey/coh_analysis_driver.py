#! /usr/bin/env python
#####! /opt/local/bin python

#import date
import sys
import time
#sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/python/efw_barrel_coherence_analysis/')
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey/')
from Coh_analysis import Coh_analysis
import py_compile
import numpy as np
import datetime as dt
from datetime import timedelta
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/python/spacepy/lib/python/')
# from spacepy import pycdf
import matplotlib.pyplot as plt
from pylab import *
import matplotlib.mlab as mlab
#import plasmaconst as pc
import subprocess
import os


#  ;-----------------------------------------------
#  ;calculate the cross spectra optimized for ULF waves of <2 mHz (Hartinger15 "The global structure")
#  ;2 mHz = 8.333 min
#  ;-----------------------------------------------

#  ;Original run ("run1")
#  ;folder = 'tplot_vars_2014_run1'
#  ;meanfilterwidth=3
#  ;meanfilterheight=3
#  ;window_minutes = 2*120.
#  ;lag_factor = 16.
#  ;coherence_multiplier = 2.5

#  ;Modified original run ("run2")
#  folder = 'tplot_vars_2014_run2'
#  meanfilterwidth=5
#  meanfilterheight=5
#;  window_minutes = 90.
#;  lag_factor = 8.
#;  coherence_multiplier = 2.5


#  ;Better for 70 min window ("run3")
#  ;folder = 'tplot_vars_2014_run3'
#  ;meanfilterwidth=5
#  ;meanfilterheight=3
#  ;window_minutes = 70.
#  ;lag_factor = 4.
#  ;coherence_multiplier = 2.5



# Interesting payloads only (BARREL mission 2 from 2014)
# Interesting combos only


#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------
#Runs for 10-60 min waves
#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------

# BARREL campaign 1
combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ',
    'DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC',
    'GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT',
    'HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM',
    'KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']
r1 = {
    'folder': 'run1_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission1',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '1',
    'fspc': 1,
    'date0': datetime.date(2013,1,1),
    'date1': datetime.date(2013,2,16),
    'payloads':['b','d','i','g','c','h','a','j','k','m','o','q','r','s','t','u','v'],
    'combos':combos,
    'window_minutes':90.,
    'lag_factor':8.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}




# BARREL campaign 2
combos = ['IT','IW','IK','IL','IX','TW','TK','TL',
    'TX','WK','WL','WX','KL','KX','LX','LA','LB','LE',
    'LO','LP','XA','XB','AB','AE','AO','AP','BE','BO',
    'BP','EO','EP','OP']

r1 = {
    'folder': 'run2_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission2',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '2',
    'fspc': 1,
    'date0': datetime.date(2014,1,1),
    'date1': datetime.date(2014,2,12),
    'payloads':['i','t','w','k','l','x','a','b','e','o','p'],
    'combos':combos,
    'window_minutes':90.,
    'lag_factor':8.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}



# BARREL campaign 3, first Kiruna campaign
r1 = {
    'folder': 'run3_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission3',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '3',
    'fspc': 1,
    'date0': datetime.date(2015,8,25),
    'date1': datetime.date(2015,8,26),
    'payloads':['f','g'],
    'combos':['FG'],   #only combo with overlapping dates
    'window_minutes':90.,
    'lag_factor':8.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}

# BARREL campaign 4, second Kiruna campaign
r1 = {
    'folder': 'run4_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission4',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '4',
    'fspc': 1,
    'date0': datetime.date(2016,8,21),
    'date1': datetime.date(2016,8,31),
    'payloads':['c','d','f','g','h'],
    'combos':['CD','FG','GH'],   #only combo with overlapping dates
    'window_minutes':90.,
    'lag_factor':8.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}




#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------
#Runs for 5-30 min waves
#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------

# BARREL campaign 1 version 2
combos = ['BD','BJ','BK','BM','BO','DI','DG','DC','DH','DJ','DK','DM','DO','DQ',
    'DR','IG','IC','IH','IA','IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV','GC',
    'GH','GJ','GK','GO','GQ','GR','GS','GT','GU','CH','CK','CO','CQ','CR','CS','CT',
    'HA','HK','HQ','HR','HS','HT','HU','HV','AQ','AT','AU','AV','JK','JM','JO','KM',
    'KO','KQ','MO','QR','QS','QT','QU','QV','RS','ST','SU','TU','TV','UV']
r1 = {
    'folder': 'run1_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission1v2',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '1',
    'fspc': 1,
    'date0': datetime.date(2013,1,1),
    'date1': datetime.date(2013,2,16),
    'payloads':['b','d','i','g','c','h','a','j','k','m','o','q','r','s','t','u','v'],
    'combos':combos,
    'window_minutes':40.,
    'lag_factor':4.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}


# BARREL campaign 2 version 2
combos = ['IT','IW','IK','IL','IX','TW','TK','TL',
    'TX','WK','WL','WX','KL','KX','LX','LA','LB','LE',
    'LO','LP','XA','XB','AB','AE','AO','AP','BE','BO',
    'BP','EO','EP','OP']

r1 = {
    'folder': 'run2v2_test',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/barrel_rbsp_coherence_survey',
    'datapath': '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/',
    'folder_singlepayload': 'folder_singlepayload',
    'folder_coh': 'coh_vars_barrelmission2v2',
    'folder_plots': 'barrel_missionwide_plots',
    'folder_ephem': 'barrel_ephemeris',
    'pre': '2',
    'fspc': 1,
    'date0': datetime.date(2014,1,1),
    'date1': datetime.date(2014,2,12),
    'payloads':['i','t','w','k','l','x','a','b','e','o','p'],
    'combos':combos,
    'window_minutes':40.,
    'lag_factor':4.,
    'coherence_multiplier':2.5,
    'meanfilterwidth':5,
    'meanfilterheight':5,
    'tsmooth':60.}






#all possible combos mission 1
#['BD', 'BI', 'BG', 'BC', 'BH', 'BA', 'BJ', 'BK', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BU', 'BV', 'DI', 'DG', 'DC', 'DH', 'DA', 'DJ', 'DK', 'DM', 'DN', 'DO', 'DQ', 'DR', 'DS', 'DT', 'DU', 'DV', 'IG', 'IC', 'IH', 'IA', 'IJ', 'IK', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'IU', 'IV', 'GC', 'GH', 'GA', 'GJ', 'GK', 'GM', 'GN', 'GO', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GV', 'CH', 'CA', 'CJ', 'CK', 'CM', 'CN', 'CO', 'CQ', 'CR', 'CS', 'CT', 'CU', 'CV', 'HA', 'HJ', 'HK', 'HM', 'HN', 'HO', 'HQ', 'HR', 'HS', 'HT', 'HU', 'HV', 'AJ', 'AK', 'AM', 'AN', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'JK', 'JM', 'JN', 'JO', 'JQ', 'JR', 'JS', 'JT', 'JU', 'JV', 'KM', 'KN', 'KO', 'KQ', 'KR', 'KS', 'KT', 'KU', 'KV', 'MN', 'MO', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'NO', 'NQ', 'NR', 'NS', 'NT', 'NU', 'NV', 'OQ', 'OR', 'OS', 'OT', 'OU', 'OV', 'QR', 'QS', 'QT', 'QU', 'QV', 'RS', 'RT', 'RU', 'RV', 'ST', 'SU', 'SV', 'TU', 'TV', 'UV']

run = Coh_analysis(r1)
run.print_test()


#--Dates and payloads
dates = run.get_dates()
plds = r1['payloads']


#--all combos--
#combos = run.get_combos()






# For each BARREL payload, create an ascii file for entire mission.
# (e.g. barrel_2W_fspc_fullmission.txt)
# **** These files have smoothed (tsmooth) FSPC data and Kp2 L, MLT, and altitude values.

for payload in plds:
    result = run.create_barrel_singlepayload_tplot(payload, dates)



# Create ephem files of the distance of each payload from the plasmapause
# NOTE: this takes a while to run...maybe 10 min per payload
for payload in plds:
    result = run.create_barrel_plasmapause_distance(payload)


###########################################################
# Create coherence spectra files: e.g. AB.tplot
combos = r1['combos']
for combo in combos:
    result = run.create_coh_tplot(combo)

######

# Create coherence spectra files: e.g. A_OMNI_press_dyn.tplot
#folder2 = 'solar_wind_data'
#file2 =  'OMNI_sw_values_campaign1.tplot'
#tplotvar = 'OMNI_press_dyn'
folder2 = 'artemis'
file2 =  'thb_ptotQ_values_campaign1.tplot'
tplotvar = 'thb_peem_ptotQ'

#tplotvar = 'OMNI_HRO_1min_IMF'
#tplotvar = 'OMNI_HRO_1min_Pressure'
#tplotvar = 'OMNI_HRO_1min_flow_speed'
#tplotvar = 'OMNI_HRO_1min_proton_density'
#tplotvar = 'OMNI_HRO_1min_Bmag'
#tplotvar = 'OMNI_clockangle'
#tplotvar = 'OMNI_coneangle'
for payload in plds:
    result = run.create_coh_tplot_general(payload,folder2,file2,tplotvar)

# Filter the coherence values to remove salt/pepper noise. Creates files like AB_meanfilter.tplot
for combo in plds:
    pld = combo.upper()
    combotmp = pld+'_thb_peem_ptotQ'
    result = run.filter_coh_tplot(combotmp)

###########################################################


# Filter the coherence values to remove salt/pepper noise. Creates files like AB_meanfilter.tplot
combos = r1['combos']
for combo in combos:
    result = run.filter_coh_tplot(combo)


for payload in plds:
    result = run.filter_coh_tplot_general(payload.upper()+'_'+'OMNI_press_dyn')

###########################################################




# Create filtered single payload plots with select ULF freq range.
# These are used to filter to times of sufficient activity.
#pmin = 10.*60.
#pmax = 60.*60.
pmin = 2.*60.
pmax = 40.*60.
for payload in plds:
    result = run.filter_barrel_by_ulf_period(payload, pmin, pmax)


###########################################################
# Make some plots
pmin = 2.*60.
pmax = 40.*60.
combos = r1['combos']
for combo in combos:
    result = run.plot_coh_tplot(combo, pmin, pmax)


pmin = 2.*60.
pmax = 60.*60.
for payload in plds:
    result = run.plot_coh_tplot_general(payload.upper()+'_'+'OMNI_press_dyn', pmin, pmax)



#result = run.
#pro py_extract_timeseries_from_coherence_files
