;Amplitude (and power) distributions for the EFW/BARREL events
;Fit to Gaussian and Skew Normal distributions

;date = '2014-01-03'
;tt = 'Hiss power dist for 2014-01-03/19:30 - 22:30'
;t0 = time_double('2014-01-03/19:30')
;t1 = time_double('2014-01-03/22:30')

date = '2014-01-06'
tt = 'Hiss power dist for 2014-01-06/20:00 - 22:00'
t0 = time_double('2014-01-06/20:00')
t1 = time_double('2014-01-06/22:00')


timespan,date
rbsp_load_efw_spec,probe='a',type='calibrated'
get_data,'rbspa_efw_64_spec4',data=dd
y = tsample('rbspa_efw_64_spec4',[t0,t1],times=t)
store_data,'tmp',data={x:t,y:y,v:dd.v}

get_data,'tmp',data=dd

yt = 'Normalized spectral power dist vs freq at each time'                                             
xt = 'Freq (Hz)'

;Find median value for each time

maxv = max(dd.y)

moms = fltarr(n_elements(dd.x))
;meds = fltarr(n_elements(dd.x))
for i=0,n_elements(dd.x)-1 do begin  $
	tmp = moment(dd.y[i,3:63]/maxv)  & $
	moms[i] = tmp[0]


;meds[i] = (median(dd.y[i,3:63]/maxv))



plot,dd.v,dd.y[0,3:63]/maxv,yrange=[0,0.6],xrange=[0,400],xstyle=1,title=tt,ytitle=yt,xtitle=xt
for i=0,n_elements(dd.x)-1 do oplot,dd.v,dd.y[i,3:63]/maxv   


;Fit a gaussian to this.
maxf = float(max(dd.v))
freqs = maxf*indgen(1000)/999.

fm = 40.
df = 60.
Bw2 = 0.4
frac = ((freqs-fm)/df)^2
B2 = Bw2*exp(-1*frac)
B22 = Bw2*maxv*exp(-1*frac)

;Fit a gaussian to the higher freq population (maybe from chorus)
fm = 160.
df = 90.
Bw3 = 0.07
frac3 = ((freqs-fm)/df)^2
B3 = Bw3*exp(-1*frac3)
B33 = Bw3*maxv*exp(-1*frac3)


;plot,dd.v,dd.y[0,3:63]/maxv,yrange=[0,0.6],xrange=[0,400],xstyle=1,title=tt,ytitle=yt,xtitle=xt
;for i=0,2699 do oplot,dd.v,dd.y[i,3:63]/maxv                                                 
;oplot,dd.v,B2,color=250,thick=3
;for i=0,2699 do oplot,dd.v,moms[i],color=50,thick=3
;for i=0,2699 do oplot,dd.v,meds,color=50,thick=3



;Skew normal distribution

fm = 30.
df = 80.
a = 7.   ;skew parameter

x = (freqs - fm)/df
y = a*x/sqrt(2.)

phi = 1/sqrt(2*!pi) * exp(-x^2/2.)
phi2 = 0.5*(1 + erf(y))

func = Bw2*2/(2.*!pi*f)*phi*phi2
func *= 4.5d2

plot,dd.v,dd.y[0,3:63]/maxv,yrange=[0,0.6],xrange=[0,400],xstyle=1,title=tt,ytitle=yt,xtitle=xt
for i=0,n_elements(dd.x)-1 do oplot,dd.v,dd.y[i,3:63]/maxv                                                 
oplot,freqs,B2,color=250,thick=3
oplot,freqs,B3,color=250,thick=3
oplot,freqs,func,color=210,thick=3
xyouts,0.5,0.5,'Two Gaussians and a skew normal dist',/normal
xyouts,0.5,0.4,'From amp_distributions.pro',/normal





;plot,dd.v,dd.y[0,3:63],xrange=[0,2000],yrange=[1d-9,1d-4],/ylog,xstyle=1,title=tt,ytitle=yt,xtitle=xt
;for i=0,n_elements(dd.x)-1 do oplot,dd.v,dd.y[i,3:63]                                                 
;oplot,freqs,B22,color=250,thick=3
;oplot,freqs,B33,color=250,thick=3
;oplot,freqs,func,color=210,thick=3
;xyouts,0.5,0.5,'Two Gaussians and a skew normal dist',/normal


