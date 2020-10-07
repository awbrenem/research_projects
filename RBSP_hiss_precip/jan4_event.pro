;Perform cross-correlations on the Jan 3 data


tplot_options,'title','from jan4_zoomed_event.pro'

date = '2014-01-04'
probe = 'a'
rbspx = 'rbspa'
timespan,date

rbsp_efw_init

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL




t0 = time_double('2014-01-04/19:00')
t1 = time_double('2014-01-04/22:00')

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract

dif_data,'rbspa_state_lshell','rbspb_state_lshell',newname='rbsp_state_lshell_diff'


;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densitya','ytitle','density'+strupcase(probe)+'!Ccm^-3'
;-----------------------------------------------
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densityb','ytitle','density'+strupcase(probe)+'!Ccm^-3'
;-----------------------------------------------
get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2
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
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}


get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2
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
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,['Bfield_hissinta','Bfield_hissintb']
;-----------------------------------------------
;; ;MAGEIS file
;; pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
;; fnt = 'rbspa_rel02_ect-mageis-L2_20140103_v3.0.0.cdf'
;; cdf2tplot,file=pn+fnt
;; get_data,'FESA',data=dd
;; store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
;; get_data,'FESA',data=dd
;; store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
;; ylim,'fesa_2mev',0.02,100,1
;; ylim,'FESA',30,4000,1
;; tplot,'FESA'
;; zlim,'FESA',0,1d5
;-----------------------------------------------
payloads = ['2I','2W','2K']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date,type='ephm'

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250
;--------------------------------------------------W


get_data,'PeakDet_2W',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2W',data={x:xv,y:yv}
options,'PeakDet_2W','colors',250
;----------------------------------------


rbsp_detrend,['PeakDet_2K','PeakDet_2W','PeakDet_2I','Bfield_hissinta','Bfield_hissintb'],60.*1


copy_data,'PeakDet_2W_smoothed','PeakDet_2W_smoothed2'
copy_data,'PeakDet_2K_smoothed','PeakDet_2K_smoothed2'
copy_data,'PeakDet_2I_smoothed','PeakDet_2I_smoothed2'
copy_data,'Bfield_hissinta_smoothed','Bfield_hissinta2'
copy_data,'Bfield_hissintb_smoothed','Bfield_hissintb2'

rbsp_detrend,['PeakDet_2K_smoothed2','PeakDet_2W_smoothed2','PeakDet_2I_smoothed2','Bfield_hissinta2','Bfield_hissintb2'],60.*20.

copy_data,'PeakDet_2W_smoothed2_detrend','PeakDet_2W_detrend2'
copy_data,'PeakDet_2K_smoothed2_detrend','PeakDet_2K_detrend2'
copy_data,'PeakDet_2I_smoothed2_detrend','PeakDet_2I_detrend2'
copy_data,'Bfield_hissinta2_detrend','Bfield_hissinta2_detrend2'
copy_data,'Bfield_hissintb2_detrend','Bfield_hissintb2_detrend2'

ylim,'PeakDet_2W',3000,5000
ylim,'PeakDet_2I',3000,20000
tplot,['PeakDet_2K','PeakDet_2W','PeakDet_2I','Bfield_hissinta','Bfield_hissintb']


ylim,'PeakDet_2W',3500,4500
ylim,'PeakDet_2I',6000,18000
ylim,'PeakDet_2K',2500,4500
tlimit,'2014-01-04/20:00','2014-01-04/21:30'
tplot,['PeakDet_2K','PeakDet_2W','PeakDet_2I','Bfield_hissinta','Bfield_hissintb']



ylim,'PeakDet_2W_smoothed2',3600,4800
ylim,'PeakDet_2I_smoothed2',6000,20000
ylim,'PeakDet_2K_smoothed2',3000,4000
tplot,['PeakDet_2K_smoothed2','PeakDet_2W_smoothed2','PeakDet_2I_smoothed2']

tlimit,'2014-01-04/20:00','2014-01-04/22:00'
tplot,['PeakDet_2W_smoothed2','PeakDet_2I_smoothed2','PeakDet_2W_detrend2','PeakDet_2I_detrend2','delta_MLT_abs','delta_L_abs','L_Kp2_2I','L_Kp2_2W','MLT_Kp2_T89c_2W','MLT_Kp2_T89c_2I']




ylim,'PeakDet_2W_smoothed2',3000,4800
ylim,'PeakDet_2I_smoothed2',4000,20000
ylim,'PeakDet_2W_detrend2',-400,400
ylim,'PeakDet_2I_detrend2',-5000,5000






;Find the separations b/t the payloads
dif_data,'L_Kp2_2I','L_Kp2_2W'  
dif_data,'MLT_Kp2_T89c_2W','MLT_Kp2_T89c_2I'  
copy_data,'MLT_Kp2_T89c_2W-MLT_Kp2_T89c_2I','delta_MLT_abs'
copy_data,'L_Kp2_2I-L_Kp2_2W','delta_L_abs'
options,'delta_MLT_abs','ytitle','|delta-MLT|!C2I and 2W'
options,'delta_L_abs','ytitle','|delta-L|!C2I and 2W'

tlimit,'2014-01-04/18:00','2014-01-04/24:00'
ylim,'PeakDet_2W_smoothed2',3500,4800
tplot,['PeakDet_2W_smoothed2','PeakDet_2I_smoothed2','PeakDet_2W_detrend2','PeakDet_2I_detrend2','delta_MLT_abs','delta_L_abs','L_Kp2_2I','L_Kp2_2W','MLT_Kp2_T89c_2W','MLT_Kp2_T89c_2I']



;Plot detrended balloon AND spacecraft data to see if there is
;anything interesting on sc

;RBSP-A and 2W and 2I

dif_data,'L_Kp2_2I','rbspa_state_lshell',newname='dL_aI'
dif_data,'L_Kp2_2W','rbspa_state_lshell',newname='dL_aW'
dif_data,'MLT_Kp2_T89c_2I','rbspa_state_mlt',newname='dmlt_aI'
dif_data,'MLT_Kp2_T89c_2W','rbspa_state_mlt',newname='dmlt_aW'

tlimit,'2014-01-04/18:00','2014-01-04/24:00'
tplot,['PeakDet_2W_detrend2','PeakDet_2I_detrend2','Bfield_hissinta2_detrend2','rbspa_state_mlt','rbspa_state_lshell','L_Kp2_2I','L_Kp2_2W','MLT_Kp2_T89c_2W','MLT_Kp2_T89c_2I','dL_aI','dL_aW','dmlt_aI','dmlt_aW']


;RBSP-B and 2W and 2I

dif_data,'L_Kp2_2I','rbspb_state_lshell',newname='dL_bI'
dif_data,'L_Kp2_2W','rbspb_state_lshell',newname='dL_bW'
dif_data,'MLT_Kp2_T89c_2I','rbspb_state_mlt',newname='dmlt_bI'
dif_data,'MLT_Kp2_T89c_2W','rbspb_state_mlt',newname='dmlt_bW'

tlimit,'2014-01-04/19:30','2014-01-04/24:00'
tplot,['PeakDet_2W_detrend2','PeakDet_2I_detrend2','Bfield_hissintb2_detrend2','rbspb_state_mlt','rbspb_state_lshell','L_Kp2_2I','L_Kp2_2W','MLT_Kp2_T89c_2W','MLT_Kp2_T89c_2I','dL_bI','dL_bW','dmlt_bI','dmlt_bW']

;RBSP-A and RBSP-B
tlimit,'2014-01-04/19:30','2014-01-04/24:00'
tplot,['Bfield_hissinta2_detrend2','Bfield_hissintb2_detrend2','rbspa_state_mlt','rbspb_state_mlt','rbspa_state_lshell','rbspb_state_lshell','rbsp_state_mlt_diff','rbsp_state_lshell_diff']












