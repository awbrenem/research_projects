;Determine dispersion of FIREBIRD microbursts using a cross-correlation analysis

;.compile /Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/IDL/myfunct_linear.pro


;Calls lineslope_minmax.pro to determine the best fit line, along with the max
;and min line slopes, calculated with help of chisqr



tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/FB_calibrated_counts_flux.tplot'

rbsp_efw_init
timespan,'2016-01-20'
tplot,['flux1']

t0 = '2016-01-20/19:43:30'
t1 = '2016-01-20/19:44:50'
;From FIGURE 1 of paper:
t0z = '2016-01-20/19:43:30'
t1z = '2016-01-20/19:44:40'
tlimit,t0z,t1z


rbsp_efw_init



store_data,'hr0',data=['flux1','flux2','flux3','flux4']
options,'hr0','colors',[0,50,100,250]

copy_data,'hr0','hr0_v2'
ylim,'hr0_v2',1,1000,1


options,'flux?','psym',-2
;tplot,['flux1','flux2','flux3','flux4']


;Determine error bars from counting statistics
;% error = 100 * [1/sqrt(C)]

get_data,'counts1',t,d
store_data,'pererr1',t,100./sqrt(d)

get_data,'flux1',t,d
get_data,'pererr1',t2,d2
store_data,'errbars_f1',t,d*0.01*d2

plot,energies,y[*,0],/nodata,yrange=[1d-1,1d5],/ylog,xrange=[200,1000],xstyle=1,ystyle=1,ytitle='e- flux',xtitle='energy(keV)',$
title='MagEIS e- flux for all pitch angles for 2016-01-20/19:43:59'


;overplot test with error bars
t0z = time_double('2016-01-20/19:44:01.000')
t1z = time_double('2016-01-20/19:44:01.600')
y = tsample('flux1',[t0z,t1z],times=t)
y2 = tsample('errbars_f1',[t0z,t1z])

plot,t-t[0],y
oplot,t-t[0],y+y2,color=250
oplot,t-t[0],y-y2,color=250




;;t0z = time_double('2016-01-20/19:44:00.000')
;;t1z = time_double('2016-01-20/19:44:00.800')

;y1 = tsample('flux1',[t0z,t1z],times=t1)
;stdh0 = stddev(y1)
;y1 = tsample('flux2',[t0z,t1z],times=t1)
;stdh1 = stddev(y1)
;y1 = tsample('flux3',[t0z,t1z],times=t1)
;stdh2 = stddev(y1)
;y1 = tsample('flux4',[t0z,t1z],times=t1)
;stdh3 = stddev(y1)

;print,stdh0,stdh1,stdh2,stdh3



;Plot data with error bars


;y0 = tsample('flux1',[t0z,t1z],times=tt)
;y1 = tsample('flux2',[t0z,t1z],times=tt)
;y2 = tsample('flux3',[t0z,t1z],times=tt)
;y3 = tsample('flux4',[t0z,t1z],times=tt)
;y0err = replicate(stdh0,n_elements(tt))
;y1err = replicate(stdh1,n_elements(tt))
;y2err = replicate(stdh2,n_elements(tt))
;y3err = replicate(stdh3,n_elements(tt))

;;p0 = errorplot(t1-t1[0],y0,y0err)
;;p1 = errorplot(t1-t1[0],y1,y1err)
;;p2 = errorplot(t1-t1[0],y2,y2err)
;;p3 = errorplot(t1-t1[0],y3,y3err)

;store_data,'uB',tt,[[y0],[y1],[y2],[y3]]
;tplot,'uB'
;plot,tt-tt[0],y0
;oplot,tt-tt[0],y1
;oplot,tt-tt[0],y2
;oplot,tt-tt[0],y3


stop

;Combine tplot variables and plot (allows estimate of coefficients for LMFIT)


;Now run a cross-correlation to delays b/t subsequent peaks
; Define two n-element sample populations:

;Calculate Least squares fit line b/t all four plots.
;Calculate the correlation coeff for each. These get weighted by the error bars
;Find a +/- line to give variance in slope


;Times of the peak
peaktimes = time_double(['2016-01-20/19:44:01.279580','2016-01-20/19:44:01.266928','2016-01-20/19:44:01.255675'])
peaktimes0 = peaktimes - peaktimes[2]
;Uncertainty in the peak times (GET BETTER TIMES FROM MIKE)
peaktimeserr = [0.01,0.005,0.01]
;central energies of each bin
energies = [251,334,432]  ;,621,852







peaktimes0 = indgen(4);reverse([0.32,0.28,0.27,0.24])
counts0 = reverse([330.,295.,114.,56.])
;energies0 = [200,300,400,500,600,700]
;peaktimeserr0 = [0.05,0.05,0.05,0.05]
peaktimeserr0 = [0.1,0.1,0.1,0.1]
countserr0 = [50.,50.,50.,50.]


;;-----------------------
;;Test fitting procedure
;;-----------------------
;peaktimes0 = indgen(10)
;randomy = randomu(10,10)
;counts0 = 5*(peaktimes0 + randomy) + 2.
;plot,peaktimes0,counts0,psym=2,thick=2
;countserr0 = replicate(2,10.)
;;-----------------------



; Overplot error bars:
plot,counts0,peaktimes0,psym=2
ERRPLOT, peaktimes0-peaktimeserr0,peaktimes0+peaktimeserr0

plot,peaktimes0,counts0,psym=2;,xrange=[0.2,0.4]
ERRPLOT,counts0-countserr0,counts0+countserr0




p0 = errorplot(reverse(peaktimes0),reverse(counts0),reverse(counts0err))


lineslope_minmax,counts0,peaktimes0,peaktimeserr0


stop

END
