;FFT the OMNI density
;This is in response to reviewer 2's question. 


smootime = 2.
dettime = 80.


rbsp_efw_init

timespan,'2014-01-11',2,/days
omni_hro_load
tplot,'OMNI_HRO_1min_Pressure'
tinterpol_mxn,'OMNI_HRO_1min_Pressure','OMNI_HRO_1min_Pressure',/ignore_nans,/overwrite



load_barrel_lc,'2X',type='rcnt'
tinterpol_mxn,'PeakDet_2X','PeakDet_2X',/ignore_nans,/overwrite
;rbsp_detrend,'PeakDet_2X',60.*smootime
;rbsp_detrend,'PeakDet_2X_smoothed',60.*dettime
;load_barrel_lc,'2X',type='fspc'
;load_barrel_lc,'2X',type='sspc'


tinterpol_mxn,'PeakDet_2X','OMNI_HRO_1min_Pressure',/overwrite



t0z = time_double('2014-01-11/20:00')
t1z = time_double('2014-01-12/01:00')
;t0z = time_double('2014-01-11/18:00')
;t1z = time_double('2014-01-12/04:00')
;t0z = time_double('2014-01-11/13:00')
;t1z = time_double('2014-01-11/19:00')
;t0z = time_double('2014-01-11/19:00')
;t1z = time_double('2014-01-12/02:00')
;t0z = time_double('2014-01-11/00:00')
;t1z = time_double('2014-01-11/23:59')
;t0z = time_double('2014-01-28/04:00')
;t1z = time_double('2014-01-28/06:00')
time_clip,'OMNI_HRO_1min_Pressure',t0z,t1z,newname='OMNI_HRO_1min_Pressure2'
time_clip,'PeakDet_2X',t0z,t1z,newname='PeakDet_2X2'
get_data,'OMNI_HRO_1min_Pressure2',data=wave2
get_data,'PeakDet_2X2',data=wave2b
tlimit,t0z,t1z
;deriv_data,'OMNI_HRO_1min_Pressure2'
;get_data,'OMNI_HRO_1min_Pressure2_ddt',data=wavederiv
;tplot,['OMNI_HRO_1min_Pressure2','OMNI_HRO_1min_Pressure2_ddt']



nelem = n_elements(wave2.x)
windowarr=lonarr(n_elements(wave2.y[*,0]))
my_windowf,nelem-1,2,windowarr
power_x = fft_power_calc(wave2.x,windowarr*wave2.y)
;power_x2 = fft_power_calc(wave2.x,windowarr*wave2.y)
;power_deriv = fft_power_calc(wavederiv.x,windowarr*wavederiv.y)


nelemb = n_elements(wave2b.x)
windowarrb=lonarr(n_elements(wave2b.y[*,0]))
my_windowf,nelem-1,2,windowarrb
power_xb = fft_power_calc(wave2b.x,windowarrb*wave2b.y)


;power_x = fft_power_calc(wave2.x,wave2.y)


;;PSD [units^2/Hz]
;plot,power_x.freq,power_x.power_a,yrange=[1.,2d5],/ylog
;oplot,power_x.freq,curve
;;dB above background level
;plot,power_x.freq,power_x.power_x,yrange=[0,60.]


;plot 1/w^2 curve
curve = 1/power_x.freq^2
;Scale to peak value of power curve
maxv = power_x.power_a[1]
curve2 = curve/8000.
;curve2 = curve/70000.

;convert to mHz
mhz = power_x.freq*1000.
mhzb = power_xb.freq*1000.

;scale the BARREL flux 
powerb = power_xb.power_a/3d6

;PSD [units^2/Hz]
;Log plot
plot,mHz,power_x.power_a,yrange=[1d0,2d5],/ylog,xrange=[0.03,10],/xlog,xstyle=1,title='fft_omni_comparison.pro',$
ytitle='FFT power (nPa^2/Hz)',xtitle='mHz'
oplot,mHz,curve2,linestyle=2,color=250
oplot,mHzb,powerb,color=1

;Linear plot
plot,mHz,power_x.power_a,yrange=[1d0,2d5],/ylog,xrange=[0,5],xstyle=1,title='fft_omni_comparison.pro',$
ytitle='FFT power (nPa^2/Hz)',xtitle='mHz'
oplot,mHz,curve2,linestyle=2,color=250
oplot,mHzb,powerb,color=1

;--------------------
;Plot f^2*P(f)^2 vs 1/f^2
plot,mHz,mHz^2*power_x.power_a,yrange=[1d0,200],/ylog,xrange=[0,5],xstyle=1,title='fft_omni_comparison.pro',$
ytitle='FFT power (nPa^2/Hz)',xtitle='mHz'
oplot,mHz,curve2,linestyle=2,color=250
oplot,mHzb,powerb,color=1


plot,mHz,mHz^2*power_x.power_a,yrange=[0,200],xrange=[0,5],xstyle=1,title='fft_omni_comparison.pro',$
ytitle='FFT power (nPa^2/Hz)',xtitle='mHz'
oplot,mHz,curve2,linestyle=2,color=250
oplot,mHzb,powerb,color=1



;oplot,mHz,power_x2.power_a,color=250
;oplot,mHz,power_deriv.power_a,color=50





;Conversion
mhzval = 0.3 
print,1/(60.*mhzval/1000.)
mhzval = 1.2
print,1/(60.*mhzval/1000.)


;plot,mHz,power_x.power_a,yrange=[1d-2,2d5],/ylog,xrange=[0,10],title='fft_omni_comparison.pro',$
;ytitle='FFT power (nPa^2/Hz)',xtitle='mHz'
;oplot,mHz,curve2,linestyle=2,color=250















Epsd = {yrange:[-20.,40.]}
plot_wavestuff,'OMNI_HRO_1min_Pressure2',/psd,Epsd=Epsd







rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*dettime
rbsp_detrend,'OMNI_HRO_1min_Pressure',60.*smootime
rbsp_detrend,'OMNI_HRO_1min_Pressure_smoothed',60.*dettime
