;FFT the integrated spec curves and the 2I precip curves to
;show similar periodicities




tplot_options,'title','from jan3_fft_hiss_precip_curves.pro'

conjunction = '20140103'
date = '2014-01-03'
payloads = ['2I']
probe = 'a'
rbspx = 'rbspa'


t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date

;t0z = time_double('2014-01-03/19:00')
;t1z = time_double('2014-01-03/23:00')
t0z = time_double('2014-01-03/17:00')
t1z = time_double('2014-01-03/24:00')

rbsp_load_barrel_lc,payloads,date,type='rcnt'


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250


rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	


rbsp_load_efw_spec,probe='a',type='calibrated'




trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


;get_data,'rbsp'+probe+'_efw_64_spec0',data=E122
get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2


bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.

bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.

nelem = n_elements(bu2.x)
bt = fltarr(nelem)


;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y

;for j=0L,nelem-1 do bt[j] = total(sqrt(ball[j,*]*bandw))
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)


store_data,'Bfield_hissint',data={x:bu2.x,y:bt}


tplot,['Bfield_hissint','PeakDet_2I']


d1 = tsample('Bfield_hissint',[t0z,t1z],times=t1)
d2 = tsample('PeakDet_2I',[t0z,t1z],times=t2)
store_data,'Bfield_hissint2',data={x:t1,y:d1}
store_data,'PeakDet_2I2',data={x:t2,y:d2}

tinterpol_mxn,'PeakDet_2I2',t1,newname='PeakDet_2I2'

;Subtract off DC signal
rbsp_detrend,'Bfield_hissint2',60.*30.
rbsp_detrend,'PeakDet_2I2',60.*30.

tplot,['Bfield_hissint2_smoothed','Bfield_hissint2_detrend','PeakDet_2I2_smoothed','PeakDet_2I2_detrend']


;FFT the signals
store_data,['x_SPEC','hissint_spec','peakdet_spec','hissint_spec2','peakdet_spec2'],/delete
plot_wavestuff,'Bfield_hissint2_detrend',/spec,/nodelete,npts=128,n_ave=1
copy_data,'x_SPEC','hissint_spec'
store_data,'x_SPEC',/delete
plot_wavestuff,'PeakDet_2I2_detrend',/spec,/nodelete,npts=128,n_ave=1
copy_data,'x_SPEC','peakdet_spec'
store_data,'x_SPEC',/delete

ylim,['hissint_fft','peakdet_fft'],1,2000,1
tplot,['hissint_fft','peakdet_fft']

;normalize the power
get_data,'hissint_spec',data=dd
maxv = max(dd.y,/nan)
store_data,'hissint_spec2',data={x:dd.x,y:dd.y/maxv,v:dd.v}
get_data,'peakdet_spec',data=dd
maxv = max(dd.y,/nan)
store_data,'peakdet_spec2',data={x:dd.x,y:dd.y/maxv,v:dd.v}
options,['peakdet_spec2','hissint_spec2'],'spec',1

ylim,['hissint_spec2','peakdet_spec2'],0.001,0.1,1
zlim,'hissint_spec2',1d-7,1,0.01
zlim,'peakdet_spec2',1d-7,1,0.01
tplot,['hissint_spec2','peakdet_spec2','Bfield_hissint2_detrend','PeakDet_2I2_detrend']
tlimit,'2014-01-03/19:30','2014-01-03/22:30'


store_data,['wavelet_power_spec','wavelet_power_spec_Conf_Level_95','wavelet_power_spec_Cone_of_Influence'],/delete
get_data,'Bfield_hissint2_detrend',data=dd
wavelet_to_tplot,dd.x,dd.y,/kill_cone,dscale=0.02
copy_data,'wavelet_power_spec','hissint_wavelet'
copy_data,'wavelet_power_spec_Conf_Level_95','hissint_conf'
;tplot,['wavelet_power_spec_Conf_Level_95','wavelet_power_spec_Cone_of_Influence','wavelet_power_spec']

store_data,['wavelet_power_spec','wavelet_power_spec_Conf_Level_95','wavelet_power_spec_Cone_of_Influence'],/delete
get_data,'PeakDet_2I2_detrend',data=dd
wavelet_to_tplot,dd.x,dd.y,/kill_cone,dscale=0.02
copy_data,'wavelet_power_spec','peakdet_wavelet'
copy_data,'wavelet_power_spec_Conf_Level_95','peakdet_conf'




get_data,'hissint_conf',data=dd
get_data,'hissint_wavelet',data=wv
goo = where(dd.y le 0.6)
if goo[0] ne -1 then wv.y[goo] = !values.f_nan
store_data,'hissint_wavelet2',data={x:wv.x,y:wv.y,v:wv.v}
options,'hissint_wavelet2','spec',1

get_data,'peakdet_conf',data=dd
get_data,'peakdet_wavelet',data=wv
goo = where(dd.y le 0.6)
if goo[0] ne -1 then wv.y[goo] = !values.f_nan
store_data,'peakdet_wavelet2',data={x:wv.x,y:wv.y,v:wv.v}
options,'peakdet_wavelet2','spec',1


zlim,['hissint_wavelet2'],1d-4,0.002
zlim,['peakdet_wavelet2'],5d6,3d7
ylim,['hissint_wavelet2','peakdet_wavelet2'],0.001,0.02,1
;tplot,['hissint_wavelet2','peakdet_wavelet2','hissint_conf','peakdet_conf','Bfield_hissint2_detrend','PeakDet_2I2_detrend']
tplot,['hissint_wavelet2','peakdet_wavelet2','Bfield_hissint2_detrend','PeakDet_2I2_detrend']




PRO wavelet_to_tplot,tt,dd,ORDER=order,DSCALE=dscale,NSCALE=nscale,START_SCALE=sscale,$
                           NEW_NAME=new_name,KILL_CONE=kill_cone,SIGNIF=signif,       $
                           PERIOD=period,FFT_THEOR=fft_theor,MOTHER=mother,           $
                           SCALES=scales,CONE=cone,CONF_95LEV=conf_95lev




