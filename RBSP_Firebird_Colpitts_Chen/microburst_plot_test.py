# -*- coding: utf-8 -*-
"""
Created on Mon May 18 13:52:05 2020

@author: Karl Pederson
"""

import numpy as np
import math
import scipy
import matplotlib
from matplotlib import pyplot as plt
import decimal
import sys
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')


class plot_microburst_test:
    
    def __init__(self):
        self.__dict__.update()
    
    
    """
    Plots a microburst graph using inputed arrays of energy and corresponding times
    t - array of times
    E - array of energy input
    """
    
    def plot_microburst_test(self, dt, EMin, EMax, a, t, E):
        
        """ Creates dE, E0, and t0 variables passed on inputed values"""
        dE = EMax - EMin
        E0 = max(E)
        """ Side note - since list.index() calls the index of the number the first time it
            shows up this will be changed in the larger version which will plot multiple curves
            across multiple energy bins"""
        t0 = t[E.index(E0)]
        
        """ Creates array to store y values to plot"""
        y = []
        
        """ Sets up index counter to access every index of list E inside for loop"""
        indexcount = 0;
        
        """ Runs calculation and adds results into y value list"""
        for time in t:
            
            yval = a * math.exp(-1 * math.pow(time-0.05, 2) / (2 * math.pow(0.1, 2))) * math.exp(-1 * math.pow(E[indexcount]-1000, 2) / (2 * math.pow(750, 2)))
            print(yval)
            y.append(yval)
            
            indexcount += 1
        
        """ Plots time(t) versus flux(y) """
        plt.plot(t, y)

        print("Here")

""" Example lists of inputed data the satellite might receive and organize"""
#t = [0, 0.005, 0.01, 0.015, 0.02, 0.025, 0.03, 0.035, 0.04, 0.045, 0.05, 0.055, 0.06, 0.065, 0.07, 0.075, 0.08, 0.085, 0.09, 0.095, 0.1]
t = np.arange(0,21)*0.005


E = [250, 275, 305, 345, 400, 450, 510, 590, 700, 840, 1000, 840, 700, 590, 510, 450, 400, 345, 305, 275, 250 ]
test_plot = plot_microburst_test()
test_plot.plot_microburst_test(0.1, 250, 1000, 1, t, E)        
    



#from scipy.ndimage.interpolation import shift
xs = np.arange(-1,1.1,0.1)
E = np.arange(250,1000,50)

fluxv = np.exp(-(E-Eo)/dE)

