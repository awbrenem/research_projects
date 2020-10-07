#Simulate a microburst as instruments of various capabilities would observe it.

#### SEE microburst_simulator.pro
#####
#####


"""
Steps:
1) F(E,t) = A(t)*exp(-(E-Eo)^2/dEo^2)*exp(-(t-t0)^2/dt^2)
where exp(-(E-Eo)^2/dEo^2) can be from Arlo's presentation
2) For each individual channel integrate this over the energy range:
for ex: f(t) = int(F(E,t)) from 250-400
3) Define instrument response (g(t)). Maybe a "fat" Gaussian, or even a Heaviside for each energy bin. i.e. assume
that the FB instrument responds very quickly to a sudden flux increase
4) Convolution for each channel: C(t) = (f(t)*g(t)) = int(-inf,inf) f(tau)*g(t-tau)dtau
5) integrate C(t) over the integration time of the instrument (e.g. 18.75 msec, or 50 msec).
6) Do this with all the channels and add them together to get a F'(E,t).

"""

class Simulate_mb:


    def __init__(self):
        self.__dict__.update()

    #create a microburst with a particular energy range and dispersion
    #Power at each energy will exhibit an exponential form with a "width".
    def create_mb(self, emin, emax, width, deltat):


    #define hypothetical instrument to observe the microbursts
    #Instrument will integrate in each energy bin for a set amount of time
    #(e.g. FB collimated detectors are 18.75 msec)
    def define_instrument(self, emin, emax, deltae, deltat):

        #Define center energy of each bin. Assume even response over this entire range.




