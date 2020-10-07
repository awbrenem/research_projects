


type = 'costream'
freqsALL = float([1000,1100,1200,1300,1400,1500,1600,1700,1800])
nrayss = 30.  ;number of rays for each point source
thetav = reverse((-30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.,3.]
smlat_fin = 40.
minL = 4.5
maxL = 6.7
dl = 0.1
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq





type = 'costream'
freqsALL = float([1300,1400,1500,1600,1700,1800])
nrayss = 30.  ;number of rays for each point source
thetav = reverse((-30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.]
smlat_fin = 35.
minL = 4.6
maxL = 5.5
dl = 0.05
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq

type = 'costream'
freqsALL = float([1000,1100,1200,1300,1400,1500,1600])
nrayss = 20.  ;number of rays for each point source
thetav = reverse((-30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.]
smlat_fin = 45.
minL = 4.5
maxL = 7.0
dl = 0.1
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq


type = 'costream'
freqsALL = float([500,600,700,800,900,1000,1100,1200])
nrayss = 30.  ;number of rays for each point source
thetav = reverse((-30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.,3.]
smlat_fin = 40.
minL = 5.5
maxL = 7.0
dl = 0.1
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq



type = 'counterstream'
freqsALL = float([500,600,700,800,900,1000,1100,1200])
nrayss = 30.  ;number of rays for each point source
thetav = 180 + ((30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.,3.]
smlat_fin = -40.
minL = 5.5
maxL = 7.0
dl = 0.1
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq


type = 'counterstream'
freqsALL = float([900,1000,1100,1200,1300,1400,1500,1600,1700,1800])
nrayss = 30.  ;number of rays for each point source
thetav = 180 + ((30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.,2.,3.]
smlat_fin = -40.
minL = 5.0
maxL = 7.0
dl = 0.1
FB_leq = 5.6         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq



;------------------------------------------------
;FOR SPECIFIC RAY PLOTS ONLY
;------------------------------------------------

type = 'counterstream'
freqsALL = float([1700])
nrayss = 30.  ;number of rays for each point source
thetav = 180 + ((30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.]
smlat_fin = -38.
minL = 4.8
maxL = 4.9
dl = 0.1
FB_leq = 5.0         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq

type = 'costream'
freqsALL = float([1800])
nrayss = 30.  ;number of rays for each point source
thetav = reverse((-30+0)*indgen(nrayss)/(nrayss-1))-0
nharmonic = [1.]
smlat_fin = 38.
minL = 4.8
maxL = 5.1
dl = 0.1
FB_leq = 5.0         ;Position of FIREBIRD. Final values will be extracted along this L
crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,FB_leq

;------------------------------------------------
;------------------------------------------------
