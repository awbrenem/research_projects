;Plot cyclotron resonance as a function of mlat for the
;chorus/microburst conjunctions


;DENSITY AS A FUNCTION OF LATITUDE FROM SAMPLE RAY PATH
lats = [0,10,20,30,40,50]
dens = [4.18,4.37,4.86,5.8,9.2,27]
dfrac = dens/4.18

DFRAC      1.00000      1.04545      1.16268      1.38756      2.20096      6.45933
MLAT          0           10            20           30           40          50


;Lv = dipole(5.77)
Lv = dipole(5.9)  ;gives the correct Bo at RBSP-A location

plot,Lv.R/6370.*cos(Lv.colat*!dtor),Lv.R/6370.*sin(Lv.colat*!dtor),color=120


;define colat value to get value of Bo
dens0 = 8.
colat = 40.
;adjust density based on DFRAC
dens1 = dens0*2.2

;testval = where(lv.colat ge 0.95)
testval = where(lv.colat ge colat)
testval = testval[0]

;get value of magnetic field at colat
bo = lv.b[testval]



.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/plasma-physics-general/cold_plasma_dispersion.pro
x = cold_plasma_dispersion(epol=1.5,freq=1700.,dens=dens1,bo=bo)
print,x.theta_kb
;help,x.cyclo_res
;print,x.cyclo_res.pitch_angles
print,x.cyclo_res.Ez[1]
print,x.cyclo_res.Etots[1]

;theta_kb = 40, PA=10 deg
;30d = 216
;35d = 540
;40d = 1100


;theta_kb = 0, PA=10 deg
;30d = 178
;35d = 450
;40d = 990
