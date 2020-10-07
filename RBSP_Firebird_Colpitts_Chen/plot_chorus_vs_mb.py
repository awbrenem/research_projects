"""
Make various plots of chorus amplitude vs microburst flux for the conjunctions.


"""

import sys
import matplotlib.pyplot as plt
import numpy as np
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')
from Rbsp_fb_filter_conjunctions import Rbsp_fb_filter_conjunctions



rbaf3_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"3"})
rbaf4_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"4"})
rbbf3_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"3"})
rbbf4_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"4"})

lmin = 0
lmax = 12
mltmin = 0
mltmax = 24


rbaf3 = rbaf3_obj.read_conjunction_file()
keyv = list(rbaf3.keys())
rbaf3_1 = rbaf3_obj.filter_based_on_range(rbaf3, "Lrb", lmin, lmax)
rbaf3_2 = rbaf3_obj.filter_based_on_range(rbaf3_1, "MLTrb", mltmin, mltmax)
rbaf3_3 = rbaf3_obj.filter_based_on_range(rbaf3_2, "bursttotalmin", 0.01, 10000)
finv3a = rbaf3_3

rbaf4 = rbaf4_obj.read_conjunction_file()
rbaf4_1 = rbaf4_obj.filter_based_on_range(rbaf4, "Lrb", lmin, lmax)
rbaf4_2 = rbaf4_obj.filter_based_on_range(rbaf4_1, "MLTrb", mltmin, mltmax)
rbaf4_3 = rbaf4_obj.filter_based_on_range(rbaf4_2, "bursttotalmin", 0.01, 10000)
finv4a = rbaf4_3

rbbf3 = rbbf3_obj.read_conjunction_file()
rbbf3_1 = rbbf3_obj.filter_based_on_range(rbbf3, "Lrb", lmin, lmax)
rbbf3_2 = rbbf3_obj.filter_based_on_range(rbbf3_1, "MLTrb", mltmin, mltmax)
rbbf3_3 = rbbf3_obj.filter_based_on_range(rbbf3_2, "bursttotalmin", 0.01, 10000)
finv3b = rbbf3_3

rbbf4 = rbbf4_obj.read_conjunction_file()
rbbf4_1 = rbbf4_obj.filter_based_on_range(rbbf4, "Lrb", lmin, lmax)
rbbf4_2 = rbbf4_obj.filter_based_on_range(rbbf4_1, "MLTrb", mltmin, mltmax)
rbbf4_3 = rbbf4_obj.filter_based_on_range(rbbf4_2, "bursttotalmin", 0.01, 10000)
finv4b = rbbf4_3






#Print final results after filtering
print("fbmaxflux --> max collumated or surface detector fluxes during the conjunction")
print("rbmaxampE --> max RBSP electric field amplitude (mV/m, filter bank) within +/-60 of conjunction")
print("rbmaxampB --> max RBSP magnetic field amplitude (pT, filter bank) within +/-60 of conjunction")
print("bursttotalmin --> total number of burst minutes within +/-60 minutes of conjunction")
print("This includes B1, B2, and EMFISIS burst")
print("Lrb, Lfb, and MLTrb, MLTfb are the L and MLT values of RBSP and FB during the exact time of closest conjunction")

print("Conjunctions for RBSPa and FU3")
print('{:22}'.format(keyv[2]),
      '{:4}'.format(keyv[3]),'{:5}'.format(keyv[5]),
      '{:4}'.format(keyv[4]),'{:5}'.format(keyv[6]),
      '{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),
      '{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv3a["datetime_min"])):
    if finv3a["Lrb"][i] != 0:
        print('{:19}'.format(finv3a["datetime_min"][i]),
              '{:6.1f}'.format(finv3a["Lrb"][i]),'{:6.1f}'.format(finv3a["MLTrb"][i]),
              '{:6.1f}'.format(finv3a["Lfb"][i]),'{:6.1f}'.format(finv3a["MLTfb"][i]),
              '{:8.1f}'.format(finv3a["fbmaxflux"][i]),
              '{:8.1f}'.format(finv3a["rbmaxampE"][i]),'{:8.1f}'.format(finv3a["rbmaxampB"][i]),
              '{:8.1f}'.format(finv3a["bursttotalmin"][i]))

"""
print("Conjunctions for RBSPb and FU3")
print('{:22}'.format(keyv[2]),
      '{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),
      '{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),
      '{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv3b["datetime_min"])):
    if finv3b["Lmin"][i] != 0: print('{:19}'.format(finv3b["datetime_min"][i]),'{:6.1f}'.format(finv3b["Lmin"][i]),'{:6.1f}'.format(finv3b["MLTmin"][i]),
                                '{:8.1f}'.format(finv3b["fbmaxflux"][i]),'{:8.1f}'.format(finv3b["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv3b["rbmaxampB"][i]),'{:8.1f}'.format(finv3b["bursttotalmin"][i]))

print("Conjunctions for RBSPa and FU4")
print('{:22}'.format(keyv[2]),'{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv4a["datetime_min"])):
    if finv4a["Lmin"][i] != 0: print('{:19}'.format(finv4a["datetime_min"][i]),'{:6.1f}'.format(finv4a["Lmin"][i]),'{:6.1f}'.format(finv4a["MLTmin"][i]),
                                '{:8.1f}'.format(finv4a["fbmaxflux"][i]),'{:8.1f}'.format(finv4a["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv4a["rbmaxampB"][i]),'{:8.1f}'.format(finv4a["bursttotalmin"][i]))

print("Conjunctions for RBSPb and FU4")
print('{:22}'.format(keyv[2]),'{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv4b["datetime_min"])):
    if finv4b["Lmin"][i] != 0: print('{:19}'.format(finv4b["datetime_min"][i]),'{:6.1f}'.format(finv4b["Lmin"][i]),'{:6.1f}'.format(finv4b["MLTmin"][i]),
                                '{:8.1f}'.format(finv4b["fbmaxflux"][i]),'{:8.1f}'.format(finv4b["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv4b["rbmaxampB"][i]),'{:8.1f}'.format(finv4b["bursttotalmin"][i]))


"""

#Plot RBSP filter bank Bw max amplitude vs FIREBIRD flux

#Total up values for all four combinations of RBSP and FIREBIRD
v1 = np.asarray(finv3a["rbmaxampB"]+finv3b["rbmaxampB"]+finv4a["rbmaxampB"]+finv4b["rbmaxampB"])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond = np.where(v1 != 0)

v12 = v1[cond].tolist()
vfb2 = vfb[cond].tolist()
plt.subplot(2,3,1)
plt.scatter([v12],[vfb2])
#plt.plot([0.1,10000],[0.1,10000])
plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)\nwithin +/-1 hr\nof conjunction")
plt.ylabel("FIREBIRD max flux")
plt.xlabel("RBSP max filter bank wave amp (pT)")
plt.xscale('log')
plt.yscale('log')
plt.axis([1,2000,0.1,200])



"""
Plot RBSP filter bank Ew max amplitude vs FIREBIRD flux
"""

quan_root = "SpecB"
band = "lb"
Max_Avg_Med = "Max"
quan1 = quan_root + Max_Avg_Med + "_"+band

#Total up values for all four combinations of RBSP and FIREBIRD

#Total activity index -- use this to filter out days of basically no wave activity
quan2 = quan_root + "Tot" + "_"+band
vtots = np.asarray(finv3a[quan2]+finv3b[quan2]+finv4a[quan2]+finv4b[quan2])


v1 = np.asarray(finv3a[quan1]+finv3b[quan1]+finv4a[quan1]+finv4b[quan1])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond1 = np.where(v1 > 0.0)
cond2 = np.where(vfb < 1000)
cond3 = np.where(vtots > 0.02)
condf = cond1 and cond2 and cond3
v12 = v1[condf].tolist()
vfb2 = vfb[condf].tolist()
ymin = np.nanmin(vfb2)
ymax = np.nanmax(vfb2)
xmin = np.nanmin(v12)
xmax = np.nanmax(v12)

if xmin == 0: xmin=0.001
plt.subplot(2,3,2)
plt.scatter([v12],[vfb2])
#plt.plot([0.001,10000],[0.001,10000])
#plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
plt.ylabel("FIREBIRD max flux")
plt.xlabel("RBSP " + quan1)
plt.xscale('log')
plt.yscale('log')
if quan_root == "SpecE":
      xmin = 0.001
      xmax = 100
else:
      xmin = 0.01
      xmax = 1000
plt.axis([xmin,xmax,0.1,200])
#plt.axis([0.001,300,0.1,100])




quan_root = "SpecB"
band = "lb"
Max_Avg_Med = "Med"
quan1 = quan_root + Max_Avg_Med + "_"+band

#Total up values for all four combinations of RBSP and FIREBIRD

#Total activity index -- use this to filter out days of basically no wave activity
quan2 = quan_root + "Tot" + "_"+band
vtots = np.asarray(finv3a[quan2]+finv3b[quan2]+finv4a[quan2]+finv4b[quan2])


v1 = np.asarray(finv3a[quan1]+finv3b[quan1]+finv4a[quan1]+finv4b[quan1])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond1 = np.where(v1 > 0.0)
cond2 = np.where(vfb < 1000)
cond3 = np.where(vtots > 0.02)
condf = cond1 and cond2 and cond3
v12 = v1[condf].tolist()
vfb2 = vfb[condf].tolist()
ymin = np.nanmin(vfb2)
ymax = np.nanmax(vfb2)
xmin = np.nanmin(v12)
xmax = np.nanmax(v12)

if xmin == 0: xmin=0.001
plt.subplot(2,3,3)
plt.scatter([v12],[vfb2])
#plt.plot([0.001,10000],[0.001,10000])
#plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
plt.ylabel("FIREBIRD maxflux")
plt.xlabel("RBSP " + quan1)
plt.xscale('log')
plt.yscale('log')
if quan_root == "SpecE":
      xmin = 0.0001
      xmax = 1
else:
      xmin = 0.001
      xmax = 1
plt.axis([xmin,xmax,0.1,200])
#plt.axis([0.001,300,0.1,100])



























#Plot RBSP filter bank Bw max amplitude vs FIREBIRD flux

#Total up values for all four combinations of RBSP and FIREBIRD
v1 = np.asarray(finv3a["rbmaxampE"]+finv3b["rbmaxampE"]+finv4a["rbmaxampE"]+finv4b["rbmaxampE"])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond = np.where(v1 != 0)

v12 = v1[cond].tolist()
vfb2 = vfb[cond].tolist()
plt.subplot(2,3,4)
plt.scatter([v12],[vfb2])
#plt.plot([0.1,10000],[0.1,10000])
plt.ylabel("FIREBIRD max flux")
plt.xlabel("RBSP max filter bank wave amp (mV/m)")
plt.xscale('log')
plt.yscale('log')
plt.axis([1,300,0.1,200])



"""
Plot RBSP filter bank Ew max amplitude vs FIREBIRD flux
"""

quan_root = "SpecE"
band = "lb"
Max_Avg_Med = "Max"
quan1 = quan_root + Max_Avg_Med + "_"+band

#Total up values for all four combinations of RBSP and FIREBIRD

#Total activity index -- use this to filter out days of basically no wave activity
quan2 = quan_root + "Tot" + "_"+band
vtots = np.asarray(finv3a[quan2]+finv3b[quan2]+finv4a[quan2]+finv4b[quan2])


v1 = np.asarray(finv3a[quan1]+finv3b[quan1]+finv4a[quan1]+finv4b[quan1])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond1 = np.where(v1 > 0.0)
cond2 = np.where(vfb < 1000)
cond3 = np.where(vtots > 0.02)
condf = cond1 and cond2 and cond3
v12 = v1[condf].tolist()
vfb2 = vfb[condf].tolist()
ymin = np.nanmin(vfb2)
ymax = np.nanmax(vfb2)
xmin = np.nanmin(v12)
xmax = np.nanmax(v12)

if xmin == 0: xmin=0.001
plt.subplot(2,3,5)
plt.scatter([v12],[vfb2])
#plt.plot([0.001,10000],[0.001,10000])
#plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
plt.ylabel("FIREBIRD max flux")
plt.xlabel("RBSP " + quan1)
plt.xscale('log')
plt.yscale('log')
if quan_root == "SpecE":
      xmin = 0.001
      xmax = 100
else:
      xmin = 0.01
      xmax = 1000
plt.axis([xmin,xmax,0.1,200])
#plt.axis([0.001,300,0.1,100])




"""
Plot RBSP filter bank Ew max amplitude vs FIREBIRD flux
"""

quan_root = "SpecE"
band = "lb"
Max_Avg_Med = "Med"
quan1 = quan_root + Max_Avg_Med + "_"+band

#Total up values for all four combinations of RBSP and FIREBIRD

#Total activity index -- use this to filter out days of basically no wave activity
quan2 = quan_root + "Tot" + "_"+band
vtots = np.asarray(finv3a[quan2]+finv3b[quan2]+finv4a[quan2]+finv4b[quan2])


v1 = np.asarray(finv3a[quan1]+finv3b[quan1]+finv4a[quan1]+finv4b[quan1])
vfb = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond1 = np.where(v1 > 0.0)
cond2 = np.where(vfb < 1000)
cond3 = np.where(vtots > 0.02)
condf = cond1 and cond2 and cond3
v12 = v1[condf].tolist()
vfb2 = vfb[condf].tolist()
ymin = np.nanmin(vfb2)
ymax = np.nanmax(vfb2)
xmin = np.nanmin(v12)
xmax = np.nanmax(v12)

if xmin == 0: xmin=0.001
plt.subplot(2,3,6)
plt.scatter([v12],[vfb2])
#plt.plot([0.001,10000],[0.001,10000])
#plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
plt.ylabel("FIREBIRD maxflux")
plt.xlabel("RBSP " + quan1)
plt.xscale('log')
plt.yscale('log')
if quan_root == "SpecE":
      xmin = 0.0001
      xmax = 0.01
else:
      xmin = 0.001
      xmax = 1
plt.axis([xmin,xmax,0.1,200])
#plt.axis([0.001,300,0.1,100])

plt.show()



print("END")


