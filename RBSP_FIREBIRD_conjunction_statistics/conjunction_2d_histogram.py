#Use dMLT and dL values from Preeti to produce a 2d histogram


matplotlib.pyplot.hist2d(x, y, bins=10, range=None, density=False, weights=None, cmin=None, cmax=None, *, data=None,

import matplotlib.pyplot as plt
import numpy as np 
#x = np.random.rand(100)
#y = np.random.rand(100)
#h = plt.hist2d(x,y,bins=10)

dmlt = "/Users/abrenema/Desktop/delta_mlt.txt"
dl = "/Users/abrenema/Desktop/delta_l.txt"
with open(dmlt) as f:
    mltlines = f.readlines()
with open(dl) as f:
    llines = f.readlines()

mltlines = [float(i[:-5]) for i in mltlines]
llines = [float(i[:-5]) for i in llines]
llines = llines[:142]

h = plt.hist2d(mltlines,llines,range=[[-24,24],[-10,10]])

plt.plot(mltlines)
plt.show()
