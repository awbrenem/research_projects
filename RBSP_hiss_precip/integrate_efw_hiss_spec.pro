;Integrate hiss power for the BARREL/EFW campaign events
;Compare to LC precipitation events on BARREL


;date = '2014-01-03'
;timespan,date
;probe = 'a'
;payloads = '2I'

;date = '2014-01-05'
;timespan,date
;probe = 'b'
;payloads = '2W'

date = '2014-01-06'
timespan,date
probe = 'a'
payloads = '2K'



tplot_options,'title','from integrate_efw_hiss_spec.pro'

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
tplot_options,'thick',1



rbsp_load_efw_spec,probe=probe,type='calibrated'
rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype=['vsvy']

rbsp_load_barrel_lc,payloads,date;,type='rcnt'
rbsp_load_barrel_lc,payloads,date,type='rcnt'


rbsp_downsample,'rbsp'+probe+'_efw_vsvy',1/spinperiod,/nochange	
split_vec,'rbsp'+probe+'_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

get_data,'rbsp'+probe+'_efw_vsvy_V1',data=v1
get_data,'rbsp'+probe+'_efw_vsvy_V2',data=v2

sum12 = (v1.y + v2.y)/2.

density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)


store_data,'density',data={x:v1.x,y:density}
ylim,'density',100,1000,1
options,'density','ytitle','density!Ccm^-3'





;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250




get_data,'rbsp'+probe+'_efw_64_spec0',data=E122
;get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
;get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
;get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2




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
tplot,'Bfield_hissint'


;options,'Bfield_hissint','ytitle','Hiss [Bu,Bv,Bw]!CRBSP-'+strupcase(probe)+'!CIntegrated spec!C[nT]'
;options,'Efield_hisse12','ytitle','Hiss E12!CRBSP-'+strupcase(probe)+'!CE12 spec amp!C[mV/m]'

rbsp_detrend,'PeakDet_2W',60.*5.
rbsp_detrend,'density',60.*10.
store_data,'Peakcomb',data=['PeakDet_2W','PeakDet_2W_smoothed']

;ylim,'PeakDet_2W',3500,4100,0
;ylim,'PeakDet_2W_smoothed',3500,4100,0
;ylim,'PeakDet_2I',4000,20000,1
ylim,'Bfield_hissint',0.0,0.7 
ylim,'rbsp'+probe+'_efw_64_spec4',10,1000,1
ylim,'rbsp'+probe+'_efw_64_spec0',10,1000,1
zlim,'rbsp'+probe+'_efw_64_spec4',1d-6,1d-4
zlim,'rbsp'+probe+'_efw_64_spec0',1d-6,1d-4
;ylim,'Peakcomb',4600,14000
ylim,'Peakcomb',3200,3500,0
ylim,'density_detrend',-80,80
options,'Peakcomb','colors',[250,0]
ylim,'density',100,10000,1

;tplot,['rbsp'+probe+'_efw_64_spec4','Bfield_hissint','rbsp'+probe+'_efw_64_spec0','Efield_hisse12','*PeakDet_*']
tlimit,'2014-01-03/16:30','2014-01-03/23:00'
tlimit,'2014-01-03/14:00','2014-01-03/23:00'
;tlimit,'2014-01-05/19:00','2014-01-05/22:00'
;tlimit,'2014-01-06/20:00','2014-01-06/22:00'
;tlimit,'2014-01-06/18:30','2014-01-06/20:00'
;tlimit,'2014-01-06/18:00','2014-01-06/22:30'
tplot,['rbsp'+probe+'_efw_64_spec4','Bfield_hissint','density','density_detrend','Peakcomb','PeakDet_2W_detrend']

tplot,['rbsp'+probe+'_efw_64_spec4','Bfield_hissint','density','Peakcomb']

;'*PeakDet_2?_smoothed','*PeakDet_2?'



end