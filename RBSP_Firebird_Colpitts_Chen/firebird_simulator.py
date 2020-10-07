# -*- coding: utf-8 -*-
"""
Created on Sun Jul 12 23:01:05 2020

@author: Karl Pederson
"""

import numpy as np
import matplotlib
from matplotlib import pyplot as plt
import scipy

"""Simulate a microburst at the location of FIREBIRD as a function of energy and time.


f(E,t) = A(t)*exp(-1*(E - Eo)^2/deltaE(t)^2)

A(t) = For each time step this defines the peak amplitude value and the energy it occurs at.
deltaE = For each time step this defines the width of Gaussian curve
Eo = time-offset of curve. Currently this is time-independent


We want to define the functional forms of A, Eo, and deltaE such that
the total flux (integrated over all energies) mimicks what probably happens in real life. Namely,
it should start low, ramp up, then ramp down.

Steps:
1) define f(E,t) as time-varying exponential f(E) = fo*exp(-E/Eo)
2) For each individual channel multiply f(E) by energy response (Gaussian).
   Fch_total = integral(f(E)*fch(E)) from 0 to infinity
   This is the instantaneous integrated energy response. If FB detectors respond very quickly
   than we may not need to worry about a ramp-up time.
3) Do this for all the channels and combine the signals.

-------
Gets more complicated if FB has a slow ramp-up response time.
for ex: f(t) = int(F(E,t)) from 250-400
"""

"""For each single time (t) define a "continuous" uB flux spectrum. It won't
actually be continuous (i.e. infinite number of values), but I'll make it have
1000 energy bins.
"""

nenergies = 1000
energies = np.arange(0,nenergies,1)
#print(energies)

"""Number of Time Steps"""

ntsteps = 200

"""Define deltaE (width) profile over time for each time step"""

deltaE = 2 * np.arange(0, ntsteps, 1) + 300
#print(deltaE)

"""Plot 1"""

plt.plot(np.arange(0, ntsteps, 1), deltaE)
plt.xlabel('Time')
plt.ylabel('DeltaE')
plt.title('DeltaE(t) Functional Form')
plt.show()

"""Define flux amplitude profile over time.
I'm having the peak amplitude fall off as an exponential
"""

tmax = ntsteps/2
dt = 10
fluxmax = np.exp(-1 * np.power(((np.arange(0,ntsteps,1))-tmax), 2)/np.power(dt,2))

"""Plot 2"""

plt.plot(np.arange(0, ntsteps, 1), fluxmax)
plt.xlabel('Time')
plt.ylabel('Flux Integrated')
plt.title('I Want Peak Flux to Occur at Time=10')
plt.show()

"""Define center energy for Gaussian (this can also be a function of time)"""

E0 = 0

"""Construct flux array f(E,t). It'll have size [nenergies, ntsteps]"""
flux = np.zeros((nenergies, ntsteps))

t = 0
while(t <= ntsteps-1):
    energycount = 0
    for e in flux:
        #print(e)
        e[t] = fluxmax[t] * np.exp(-1 * np.power((energies[energycount]-E0),2)/np.power(deltaE[t],2))
        energycount += 1
    t += 1

#print(flux)

"""This is the check to see how the integrated flux profile changes."""
Eint_t = np.zeros(ntsteps)

t = 0
while(t <= ntsteps-1):
    Eint_t[t] = scipy.integrate.quad() """Part I'm stuck on"""
    t += 1
    