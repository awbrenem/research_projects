# -*- coding: utf-8 -*-
"""
Created on Sun Jan 24 17:19:21 2021

@author: Karl Pederson
"""

import numpy as np
import matplotlib
matplotlib.use('Qt5Agg') #Fixes MacOS crash
from matplotlib import pyplot as plt
#import matplotlib.colors as colors
#from matplotlib import ticker, cm, colors
from matplotlib.colors import LogNorm
import sys
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_Colpitts_Chen/')

"""NOTE **** I took out all of the unnecessary testing functions and only left test 
functions used to produce needed plots - so a function with _plot will plot something, otherwise
the function is needed to produce an array for something"""

"""NOTE **** The overlay plots for the simulated microburst and real uB have
the simulated microburst asymptote at about 20 for flux, I still can't figure
out why"""

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

"""Creates flux array (with dispersion). Both energy and time exponentials
mintime: minimum time value with flux
maxtime: max time value with flux
tdispersion: calculated dispersion per energy bin (currently set to per keV w/ 1000 bins)
dt: width of microburst
J0: Amplitude factor
E0: center energy for microburst
ntsteps: number of time steps
nenergies: number of energies"""
def flux(ntsteps, nenergies, maxtime, mintime, dt, J0, E0): 
    tdispersion = (maxtime-mintime)/nenergies
    flux = np.zeros((nenergies, ntsteps))
    
    for e in range(nenergies):
        
        for t in range(ntsteps):
            
            """Produces array of flux values f(E, t) by combining time variance
            with energy variance and a multiplication factor"""
            flux[e,t] = J0 * np.exp(-1*e/E0) * np.exp(-1*np.power((t-mintime-(tdispersion*e)), 2)/np.power(dt, 2))
            
    return flux


"""Creates noise array and adds it to the inputed flux array
flux: array of size (nenergies, ntsteps)
maxflux: max flux in flux array used for noise calculation
N: array of random values with size (nenergies, ntsteps)
noiseS: array containing noise values of size (nenergies, ntsteps)"""

def noise(flux):

    ntsteps = len(flux[0])
    nenergies = len(flux)

    """max flux in flux array"""
    maxflux = np.amax(flux)

    """Setting noise factor arrays"""

    N = 2 * np.random.rand(nenergies, ntsteps) - 1
    #Random Scale Factor to make the noise level more realistic
    scalefac = 0.8
    N = N * scalefac
    noiseS = np.zeros((nenergies, ntsteps))  

    """Adding noise to noiseS and then flux array"""
    for x in range(nenergies):
        noiseS[x,:] = N[x,:] * np.power((maxflux-flux[x,:]), 1/2)
        flux[x,:] = flux[x,:] + noiseS[x,:]

    return flux


"""Plot flux spectra vs energy for each time step
flux: array with size (nenergies, ntsteps)

PLOTS ALL THE GAUSSIANS FOR EVERY ENERGY FOR EACH TIMESTEP.

THIS IS STAND-ALONE.  

WILL PROBABLY CRASH COMPUTER UNLESS YOU SHORTEN NENERGIES BELOW 1000 
OTHERWISE IT TRIES TO PLOT 1000 THINGS AT A TIME

OLD: spectra_etest()
"""

def seperatefve_plot(flux):
    nenergies = len(flux)
    ntsteps = len(flux[0])
    
    flux2 = np.transpose(flux)
    nrows = int(np.sqrt(ntsteps)) + 1
    fig = plt.figure(figsize=(15,10))

    for t in range(ntsteps):

        plt.subplot(nrows, nrows, t+1)
        plt.plot(np.arange(nenergies), flux2[t])
        plt.yticks(np.arange(0,1.1,1))
        plt.ylabel('Flux (t=' + str(t) + ')')
        plt.xlabel('Energy (keV)')

    plt.show()

    return

"""Plots all spectra at each time stacked on each other
flux: array of size (nenergies, ntsteps)
flux2: transposed flux array of size (ntsteps, nenergies)

PLOTS EVERY SINGLE CHANNEL ON TOP OF EACH OTHER (SIMILAR TO SPECTRA_ETEST)

OLD: spectra_stackedtest()
"""

def stackedfve_plot(flux):
    nenergies = len(flux)
    ntsteps = len(flux[0])
    
    fig2 = plt.figure()
    plt.xlabel('Energy (keV)')
    plt.ylabel('Flux')    

    flux2 = np.transpose(flux)

    for t in range(ntsteps):

        plt.plot(np.arange(nenergies), flux2[t])
        
    plt.show()
    
    return


"""Determines energy values that record a flux response for each bin according
to a square response for each channel
numenergybins: number of energy bins
fbgain/fbgain2: arrays that hold the value 1 in each place where a bin will record flux"""

def fbgain(flux,fblow,fbhig):
    nenergies = len(flux)
    
    #fblow = [220.,283.,384.,520.,721.]
    #fbhig = [283.,384.,520.,721.,985.]
    numenergybins = len(fblow)

    fbgain = np.zeros((nenergies, numenergybins))
    fbgain2 = np.transpose(fbgain)

    fblow = np.array(fblow)
    fbhig = np.array(fbhig)
    
    for x in range(numenergybins):

        for E in range(nenergies):

            if (E >= fblow[x] and E <= fbhig[x]):
                fbgain2[x][E] = 1
                
    return fbgain2

"""Plots test of stages of the flux integration
energies: array of values for each energy
flux: array of size (nenergies, ntsteps)
fblow: lowest energy values for each energy bin
fbhig: Highest energy values for each energy bin
fbgain2: FB energy gain transposed to array size (nenergies,numenergybins)
OLD: intflux_test()"""
def fbflux_plot(flux, fbgain2,fblow,fbhig):
    nenergies = len(flux)
    ntsteps = len(flux[0])
    
    #fblow = [220.,283.,384.,520.,721.]
    #fbhig = [283.,384.,520.,721.,985.]
    numenergybins = len(fblow)
    
    flux2 = np.transpose(flux)
    fig5 = plt.figure(figsize=(20,20))
    plt.subplot(3,1,1)
    
    for t in range(ntsteps):
        
        fluxtmp = flux2[t,:]
        """plot output of FB detector at each time"""
        plt.plot(np.arange(nenergies), fluxtmp) 
    
   
    """Plotting simulated fb square response channels"""
    plt.subplot(3,1,2) 
    
    for e in range(numenergybins):
        
        plt.plot(np.arange(nenergies), fbgain2[e,:])
    
    """Plotting flux after FB in channels at time 0"""
    plt.subplot(3,1,3)
    
    flux_after_fb = np.zeros((nenergies, numenergybins))
    flux_after_fb2 = np.transpose(flux_after_fb)
    
    for e in range(numenergybins):
        
        flux_after_fb2[e,:] = flux2[0,:] * fbgain2[e,:]
        
        plt.plot(np.arange(nenergies), flux_after_fb2[e,:])

    plt.show()
    return

"""Finding the integrated flux for each enerrgy bin at each time
flux: array of size (nenergies, ntsteps)
fblow: lowest energy values for each energy bin
fbhig: Highest energy values for each energy bin
fbgain2: FB energy gain transposed to array size (numenergybins, nenergies)
fluxtmp: flux at time t in flux2 array (ntsteps, nenergies) """

def Fch_total(flux, fbgain2,fblow,fbhig):
    #fblow = [220.,283.,384.,520.,721.]
    #fbhig = [283.,384.,520.,721.,985.]
    numenergybins = len(fblow)
    
    ntsteps = len(flux[0])
    nenergies = len(flux)

    flux2 = np.transpose(flux)

    Fch_total = np.zeros((numenergybins, ntsteps))
    Fch_total2 = np.transpose(Fch_total)

    for t in range(ntsteps):

        fluxtmp = flux2[t,:]

        #THE BELOW TWO VARIABLES CAN PROBABLY BE TEMPORARY
        flux_after_fb = np.zeros((nenergies, numenergybins))
        flux_after_fb2 = np.transpose(flux_after_fb)

        for x in range(numenergybins):

            flux_after_fb2[x,:] = fluxtmp * fbgain2[x,:]
            int_flux = 0

            for e in range(nenergies):

                """Now integrate the FB fluxes for each channel over all energies."""
                if (e >= fblow[x] and e <= fbhig[x]):

                    int_flux += flux_after_fb2[x][e]

            Fch_total2[t][x] = int_flux
    
    Fch_total = np.transpose(Fch_total2)

    #Normalize flux by size of energy bin
    for x in range(numenergybins):
        Fch_total[x] = Fch_total[x]/(fbhig[x]-fblow[x])

    return Fch_total



"""Plots of the microburst spectrogram with each energy bin in below plots
flux: array size (nenergies, ntsteps)
time: array of time values
energies: array of energy values
Fch_total: integrated flux array 
fblow: lowest energy value for each bin
fbhig: highest energy value for each bin
OLD: uB_test()"""
def uB_plot(flux, Fch_total,fblow,fbhig):
    #fblow = [220.,283.,384.,520.,721.]
    #fbhig = [283.,384.,520.,721.,985.]
    numenergybins = len(fblow)
    
    time_grid, energy_grid = np.meshgrid(np.arange(ntsteps), np.arange(nenergies))
    #fig6 = plt.figure(figsize=(20,20))
    """Spectrogram Plot"""
    plt.subplot(numenergybins+1, 1, 1)
    #plt.contourf(time_grid[200:,:], energy_grid[200:,:], flux[200:,:],levels=[1e1,1e2,1e3,1e4],cmap=plt.cm.jet,norm=LogNorm()) #,vmin=1,vmax=np.max(flux)/10.)
    plt.contourf(time_grid[220:,:], energy_grid[220:,:], flux[220:,:],vmin=10,vmax=50)



    #cbar = plt.colorbar()
    plt.clim(10, 50)
    #cbar.ax.tick_params(labelsize=5)
    plt.xlabel('time (us)', size=5)
    plt.ylabel('Energy (keV)', size=5)
    plt.title('Simulated Microburst Flux (Normalized)', size=5)
    plt.ylim(200,1000)
    plt.xticks(fontsize=5)
    plt.yticks(fontsize=5)

    """Each energy bin Subplots"""
    subplot_count = 2
    for e in reversed(range(numenergybins)):
        plt.subplot(numenergybins+1,1,subplot_count,title=str(fblow[e]) + "-" + str(fbhig[e]) + "keV")
        plt.plot(Fch_total[e])
        plt.ylabel("Integrated Flux", size=5)
        plt.xlabel('time (us)', size=5)
        #plt.annotate(s="FIREBIRD Simulated Channel " + str(fblow[e]) + "-" + str(fbhig[e]) + "keV", xy=[95,150], size=5)
        #plt.annotate("FIREBIRD Simulated Channel " + str(fblow[e]) + "-" + str(fbhig[e]) + "keV", xy=[0.7,0.9],size=5,xycoords="figure fraction")
        #plt.yticks(np.arange(-0.1,0.8,.1))
        #plt.yticks(np.arange(-10,180,20),fontsize=5)
        plt.xticks(np.arange(0,150,25),fontsize=5)
        subplot_count +=1
        
    plt.show()
    return

"""Determines max flux for each energy level between 200-nenergieskeV (to zoom in)
in the simulated microburst and returns an array of those values"""

def uB_maxflux(flux):
    nenergies = len(flux)

    fluxmax = np.zeros(nenergies-200)    

    e = 200
    while(e < nenergies):
        fluxmax[e-200] = max(flux[e])
        e+=1

    return fluxmax

"""Calculates max flux of each energy bin 200keV or higher (to zoom in)
and adjusts values by a factor to start the graph on the simulated microburst
fluxmax: array of max fluxes for each keV in simulated microburst
realuB: array of max fluxes for each energy bin in real microburst
OLD: Real_uB1()"""
def Real_uB(fluxmax, realuB, fblow, fbhig):

    Ecenter = list()
    for i in range(len(fblow)):
        Ecenter.append((fblow[i] + fbhig[i])/2.)

    S = fluxmax[Ecenter[0]-200]/realuB[0]
   
    for x in range(len(realuB)):
        realuB[x] = S * realuB[x]
        
    return realuB

"""Overlays simulated microburst and real microburst multiplied by factor
from 200-nenergies keV (to zoom in)
fluxmax: array of max fluxes for each keV in simulated microburst
realuB: array of max fluxes for each energy bin in real microburst
Ecenter: energy values at the center of each energy bin"""

def uBoverlay_plot(fluxmax, realuB, nenergies, fblow, fbhig):


    Ecenter = list()
    for i in range(len(fblow)):
        Ecenter.append((fblow[i] + fbhig[i])/2.)

    fig8 = plt.figure()
    """Simulated microburst"""
    plt.plot(np.arange(200,nenergies,1), fluxmax)
    """Real microburst"""
    plt.plot(Ecenter, realuB, marker="*")
    plt.ylabel("Flux", size=15)
    plt.xlabel('Energy (keV)', size=15)
    plt.title("Comparison of Energy Bin Flux Maxes Between Real and Simulated Microbursts")
    plt.show()

    return


"""Variable Definitions NECESSARY FOR FLUX FUNCTION"""
nenergies = 1000
ntsteps = 150
maxtime = 100
mintime = 33.333
dt = 10
J0 = 600
E0 = 100

"""Real Microburst Maxes per energy bin - used for overlay plotting
uB1, 2, and 3 are the saved arrays of real uB points per FB channel - realuB 
is just the one I picked to use in the overlay plot"""
uB1 = [16, 4, 0.9, 0.2, 0.03]
uB2 = [27, 11, 3, 1, 0.9]
uB3 = [150, 130, 63, 21, 0]

realuB = uB2



fblow = [220.,283.,384.,520.,721.]
fbhig = [283.,384.,520.,721.,985.]


"""Function Calls - Explanation for Each
flux() and noise() are needed to produce flux arrays which are used in almost everything - corresponding test functions
are seperatefve_plot() and stackedfve_plot()
fbgain() is used to simulate FB channel responses - also used to determine Fch_total (integrated flux) - corresponding
test function is fbflux_plot()
Fch_total() creates integrated flux array (normalized by size of energy bin) - corresponding
test function is uB_plot()
uB_maxflux() gathers the max flux for each keV in simulated uB and Real_uB() amplifies
the real uB so the first point is on the simulated uB plotline - needed to produce overlay plots - corresponding 
test function is uBoverlay_plot()"""
flux = flux(ntsteps, nenergies, maxtime, mintime, dt, J0, E0)
flux = noise(flux)

#WHY IS THIS A [5,1000] ARRAY WITH NO TIMES?
fbgain2 = fbgain(flux,fblow,fbhig)
#[5,150]
Fch_total = Fch_total(flux, fbgain2,fblow,fbhig)
#Seems to be the max flux (>200 keV) for all energy channels and each time
fluxmax = uB_maxflux(flux)
Real_uB(fluxmax, realuB, fblow, fbhig)

"""Plot Function Calls"""
#seperatefve_plot(flux)  TENDS TO CRASH COMPUTER WITH 1000 ENERGY LEVELS (PRODUCES 1000 SUBPLOTS)
#stackedfve_plot(flux)
#fbflux_plot(flux, fbgain2)
uB_plot(flux, Fch_total, fblow, fbhig)
uBoverlay_plot(fluxmax, realuB, nenergies, fblow, fbhig)





#Aaron changes
#1) removed Fch_total_balanced and put it inside of Fch_total
#2) removed obsolete routines (like the one that defines the energy channels with a function)
#3) reversed order of stacked plot so higher energies plot first --> for e in reversed(range(numenergybins)):

