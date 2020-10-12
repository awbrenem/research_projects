#! /usr/bin/env python
# coding=utf-8

#import datetime
#import matplotlib.pyplot as plt
import os
os.putenv("CDF_LIB", "~/CDF/LIB")
import sys
#sys.path.append('/Users/sadietetrick/')
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/python/spacepy/lib/python/')
sys.path.append('/Users/aaronbreneman/anaconda/lib/python2.7/site-packages/')

#sys.path.append('/Users/sadietetrick/anaconda/lib/python2.7/site-packages/')
from Coh_plot import Coh_plot


r1 = {}
run = Coh_plot(r1)



goo = run.get_payload_vals('2K')
lshell_p1 = goo['lshell']
mlts_p1 = goo['mlt']
times_p1 = goo['time']

goo = run.get_payload_vals('2I')
lshell_p2 = goo['lshell']
mlts_p2 = goo['mlt']
times_p2 = goo['time']

#lshell = run.avg_lshell(lshell_p1, lshell_p2)
#mlt = run.avg_mlt(mlts_p1,mlts_p2)


goo = run.get_combo_vals('IK')
freq_p1p2 = goo['freq']
coh_p1p2 = goo['coh']
times_p1p2 = goo['times']


mc_p1p2 = run.get_max_coherence(coh_p1p2)



    #Run to get info from files
   # new_freq, new_times, new_coh = get_files(payload_combo)
    #ls, mlts, times = data_payload1(payload1)
    #ls2, mlts2, times2 = data_payload2(payload2)



mc_p1p2_in = run.filter_plasmasphere(mc_p1p2, times_p1, '2K', 'in')
mc_p1p2_in = run.filter_plasmasphere(mc_p1p2_in, times_p2, '2I', 'in')

mc_p1p2_out = run.filter_plasmasphere(mc_p1p2, times_p1, '2K', 'out')
mc_p1p2_out = run.filter_plasmasphere(mc_p1p2_out, times_p2, '2I', 'out')




#p1_in_largeevents = run.filter_largeevents(mc_p1p2, times_p1, 'IK')
#p2_in_largeevents = run.filter_largeevents(mc_p1p2, times_p2, 'IK')


"""
p1_in = run.filter_plasmasphere(mc_p1p2, times_p1, '2K', 'in')
p1_out = run.filter_plasmasphere(mc_p1p2, times_p1, '2K', 'out')
p2_in = run.filter_plasmasphere(mc_p1p2, times_p2, '2I', 'in')
p2_out = run.filter_plasmasphere(mc_p1p2, times_p2, '2I', 'out')

p1_in_largeevents = run.filter_largeevents(mc_p1p2, times_p1, 'IK')
p2_in_largeevents = run.filter_largeevents(mc_p1p2, times_p2, 'IK')
"""





filt_inl = run.interpolate_vals(times_p1p2, mc_p1p2_out, times_p1, times_p2, lshell_p1, lshell_p2)
filt_inm = run.interpolate_vals(times_p1p2, mc_p1p2, times_p1, times_p2, mlts_p1, mlts_p2)

#get and interpolate the OMNI data
omnivals = run.get_omni(times_p1p2)




xlim = [0, 24]
ylim = [0.6, 1.4]
run.plot_scatter(filt_inm['avg_vals'], mc_p1p2_out, 'MLT', 'Integrated Coherence', xlim, ylim)

xlim = [0, 8]
ylim = [0.6, 1.4]
run.plot_scatter(filt_inl['avg_vals'], mc_p1p2_out, 'Lshell', 'Integrated Coherence', xlim, ylim)


xlim = [-180, 180]
ylim = [0.6, 1.4]
run.plot_scatter(omnivals['clock_angle'], mc_p1p2_out, 'Clock Angle', 'Coherence', xlim, ylim)

xlim = [-180, 180]
ylim = [0.6, 1.4]
run.plot_scatter(omnivals['cone_angle'], mc_p1p2_out, 'Cone Angle', 'Coherence', xlim, ylim)




"""
xlim = [-180, 180]
ylim = [0.6, 1.4]
run.plot_scatter(omnivals['clock_angle'], p1_in_largeevents, 'Clock Angle', 'Coherence', xlim, ylim)

xlim = [-180, 180]
ylim = [0.6, 1.4]
run.plot_scatter(omnivals['cone_angle'], p1_in_largeevents, 'Cone Angle', 'Coherence', xlim, ylim)



xlim = [0, 24]
ylim = [0.6, 1.4]
run.plot_scatter(filt_inm['avg_vals'], p1_in_largeevents, 'MLT', 'Integrated Coherence', xlim, ylim)
xlim = [0, 8]
ylim = [0.6, 1.4]
run.plot_scatter(filt_inl['avg_vals'], p1_in_largeevents, 'Lshell', 'Integrated Coherence', xlim, ylim)
"""

run.plot_histogram()



# Test reading file
#f = open('/Users/aaronbreneman/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide/barrel_KL_coherence_fullmission.txt')
f = open('/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_missionwide/barrel_KL_coherence_fullmission.txt')
tst = goo[0:100]
lst = tst.split()
vals = np.array(lst, dtype=np.int8)

vals = np.fromstring(tst, dtype=float, sep=' ')


tester = [i for i in tst]
tf = [elem.split() for elem in tst]

import numpy as np
print np.fromstring(tst)


a = tst.astype(np.float)
a = map(float, tst)

a = np.array(tst, dtype='|S4')
y = a.astype(np.float)
