
import sys
import matplotlib.pyplot as plt
import numpy as np
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')
from Rbsp_fb_filter_conjunctions import Rbsp_fb_filter_conjunctions


lmin = 5
lmax = 8
mltmin = 0
mltmax = 24


rbaf3_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"3"})
rbaf4_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"4"})
rbbf3_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"3"})
rbbf4_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"4"})

rbaf3_obj.print_test()



rbaf3 = rbaf3_obj.read_conjunction_file()
keyv = list(rbaf3.keys())
rbaf3_1 = rbaf3_obj.filter_based_on_range(rbaf3, "L", lmin, lmax)
rbaf3_2 = rbaf3_obj.filter_based_on_range(rbaf3_1, "MLT", mltmin, mltmax)
rbaf3_3 = rbaf3_obj.filter_based_on_range(rbaf3_2, "bursttotalmin", 1, 10000)
finv3a = rbaf3_3

rbaf4 = rbaf4_obj.read_conjunction_file()
rbaf4_1 = rbaf4_obj.filter_based_on_range(rbaf4, "L", lmin, lmax)
rbaf4_2 = rbaf4_obj.filter_based_on_range(rbaf4_1, "MLT", mltmin, mltmax)
rbaf4_3 = rbaf4_obj.filter_based_on_range(rbaf4_2, "bursttotalmin", 1, 10000)
finv4a = rbaf4_3

rbbf3 = rbbf3_obj.read_conjunction_file()
rbbf3_1 = rbbf3_obj.filter_based_on_range(rbbf3, "L", lmin, lmax)
rbbf3_2 = rbbf3_obj.filter_based_on_range(rbbf3_1, "MLT", mltmin, mltmax)
rbbf3_3 = rbbf3_obj.filter_based_on_range(rbbf3_2, "bursttotalmin", 1, 10000)
finv3b = rbbf3_3

rbbf4 = rbbf4_obj.read_conjunction_file()
rbbf4_1 = rbbf4_obj.filter_based_on_range(rbbf4, "L", lmin, lmax)
rbbf4_2 = rbbf4_obj.filter_based_on_range(rbbf4_1, "MLT", mltmin, mltmax)
rbbf4_3 = rbbf4_obj.filter_based_on_range(rbbf4_2, "bursttotalmin", 1, 10000)
finv4b = rbbf4_3






#Print final results after filtering
print("fbmaxflux --> max collumated or surface detector fluxes during the conjunction")
print("rbmaxampE --> max RBSP electric field amplitude (mV/m, filter bank) within +/-60 of conjunction")
print("rbmaxampB --> max RBSP magnetic field amplitude (pT, filter bank) within +/-60 of conjunction")
print("bursttotalmin --> total number of burst minutes within +/-60 minutes of conjunction")
print("This includes B1, B2, and EMFISIS burst")


print("Conjunctions for RBSPa and FU3")
print('{:22}'.format(keyv[0]),'{:4}'.format(keyv[1]),'{:5}'.format(keyv[2]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv3a["datetime"])):
    if finv3a["L"][i] != 0: print('{:19}'.format(finv3a["datetime"][i]),'{:6.1f}'.format(finv3a["L"][i]),'{:6.1f}'.format(finv3a["MLT"][i]),
                                '{:8.1f}'.format(finv3a["fbmaxflux"][i]),'{:8.1f}'.format(finv3a["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv3a["rbmaxampB"][i]),'{:8.1f}'.format(finv3a["bursttotalmin"][i]))

print("Conjunctions for RBSPb and FU3")
print('{:22}'.format(keyv[0]),'{:4}'.format(keyv[1]),'{:5}'.format(keyv[2]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv3b["datetime"])):
    if finv3b["L"][i] != 0: print('{:19}'.format(finv3b["datetime"][i]),'{:6.1f}'.format(finv3b["L"][i]),'{:6.1f}'.format(finv3b["MLT"][i]),
                                '{:8.1f}'.format(finv3b["fbmaxflux"][i]),'{:8.1f}'.format(finv3b["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv3b["rbmaxampB"][i]),'{:8.1f}'.format(finv3b["bursttotalmin"][i]))

print("Conjunctions for RBSPa and FU4")
print('{:22}'.format(keyv[0]),'{:4}'.format(keyv[1]),'{:5}'.format(keyv[2]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv4a["datetime"])):
    if finv4a["L"][i] != 0: print('{:19}'.format(finv4a["datetime"][i]),'{:6.1f}'.format(finv4a["L"][i]),'{:6.1f}'.format(finv4a["MLT"][i]),
                                '{:8.1f}'.format(finv4a["fbmaxflux"][i]),'{:8.1f}'.format(finv4a["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv4a["rbmaxampB"][i]),'{:8.1f}'.format(finv4a["bursttotalmin"][i]))

print("Conjunctions for RBSPb and FU4")
print('{:22}'.format(keyv[0]),'{:4}'.format(keyv[1]),'{:5}'.format(keyv[2]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
for i in range(len(finv4b["datetime"])):
    if finv4b["L"][i] != 0: print('{:19}'.format(finv4b["datetime"][i]),'{:6.1f}'.format(finv4b["L"][i]),'{:6.1f}'.format(finv4b["MLT"][i]),
                                '{:8.1f}'.format(finv4b["fbmaxflux"][i]),'{:8.1f}'.format(finv4b["rbmaxampE"][i]),
                                '{:8.1f}'.format(finv4b["rbmaxampB"][i]),'{:8.1f}'.format(finv4b["bursttotalmin"][i]))







#Total up values for all four combinations of RBSP and FIREBIRD

v1 = np.asarray(finv3a["rbmaxampB"]+finv3b["rbmaxampB"]+finv4a["rbmaxampB"]+finv4b["rbmaxampB"])
v2 = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
cond = np.where(v1 != 0)

v12 = v1[cond].tolist()
v22 = v2[cond].tolist()
plt.scatter([v12],[v22])
plt.plot([0.1,10000],[0.1,10000])
plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
plt.ylabel("FIREBIRD max flux")
plt.xlabel("RBSP max wave amp (pT) within +/-1 hr\nof conjunction")
plt.xscale('log')
plt.yscale('log')
plt.axis([1,10000,1,10000])
plt.show()


