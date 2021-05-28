import numpy as np
import matplotlib.pyplot as plt


evals = np.arange(0,1001,1)
time = np.arange(0,21,1)
f0 = 1000.
E0 = 100.

time_grid, energy_grid = np.meshgrid(time, evals)


f_xy = []
for e1 in evals:
    f_xy.append(f0 * np.exp(-1 * e1/E0))
#NOTE: shouldn't be a -1 out front of exponential here

#at this point f_xy is only a 1D array
print(len(f_xy))
#1001


#Make it 2D by extending to all times
f = []
for i in range(len(time)):
  f.append(f_xy)


#size of "f"
print(len(f))   #21 rows
print(len(f[0])  #1001 columns

#Change f to np array
fnp = np.asarray(f)
fnp.shape
#(21, 1001)

time_grid.shape
#(1001, 21)

energy_grid.shape
#(1001, 21)

#need to swap fnp from (21, 1001) to (1001, 21) to be consistent
#with time_grid and energy_grid
fnp2 = np.transpose(fnp)
fnp2.shape
#(1001, 21)


#plot a slice at single time as a sanity check
#Should see a falling exponential with energy
plt.plot(fnp2[:,2])
plt.show()



#Let's try the contour plot
plt.contourf(time_grid, energy_grid, fnp2)
plt.show()
#plot looks pretty good. The preponderance of purple at the top
#is due to the fact that most of the microburst power is at lower
#energies
