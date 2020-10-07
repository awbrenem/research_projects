;Make the three-tiered plot of coherence vs freq for any event


tplot_options,'title','from coherence_vs_freq_plot.pro'

;**************************************************
;; date = '2014-01-06'
;; rbspx = 'rbspa'
;; probe = 'a'
;; t0 = time_double(date + '/19:30')
;; t1 = time_double(date + '/22:30')
;; t0z = '2014-01-06/19:30'
;; t1z = '2014-01-06/21:50'
;; hissremove_low = [0,2]
;; hissremove_high = [45,63]
;; fnt = 'rbspa_rel02_ect-mageis-L2_20140106_v3.0.0.cdf'  ;MagEIS file name
;; pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/';path to MagEIS file

;; ;BARREL diffusion results file
;; fnb = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_06_5deg.hdf5'
;; pnb = '~/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/'

;; payload = '2K'
;; periodnormal = 0.001  ;wave period to normalize freq spectra to. Must be done to compare various spectral quantities (hiss amp, Bo, dens, e- flux) to x-rays. Otherwise for some quantities the DC variation totally dominates spectrum
;; T1='2014-01-06/20:00:00'        ;Times for calculating freq spectra
;; T2='2014-01-06/22:00:00'	
;; ;; T1='2014-01-03/20:10:00'        ;Times for calculating freq spectra
;; ;; T2='2014-01-03/21:10:00'	

;**************************************************


;; ;**************************************************
fnb = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_03_193000.hdf5'
pnb = '~/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/'


payload = '2I'
periodnormal = 0.001  ;wave period to normalize freq spectra to. Must be done to compare various spectral quantities (hiss amp, Bo, dens, e- flux) to x-rays. Otherwise for some quantities the DC variation totally dominates spectrum
T1='2014-01-03/19:30:00'        ;Times for calculating freq spectra
T2='2014-01-03/22:30:00'	
;; T1='2014-01-03/20:10:00'        ;Times for calculating freq spectra
;; T2='2014-01-03/21:10:00'	

;; ;**************************************************



timespan,date
rbsp_efw_init
trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL





R2 = FILE_INFO(fnb)
help,r2,/st

print,H5F_IS_HDF5(fnb)
result = h5_parse(fnb,/READ_DATA)

avebounce = transpose(result.avebounce._DATA)
avelocal =  transpose(result.avelocal._DATA)
energy = 1000.*result.energy._DATA   ;keV
time = time_double(time_string(result.time._DATA)) + 30.  ;shift bins by 30 seconds

store_data,payload+'_avebounce',data={x:time,y:avebounce,v:energy}
options,payload+'_avebounce','spec',1
zlim,payload+'_avebounce',1d-8,1d-2,1
tplot,payload+'_avebounce'
store_data,payload+'_avebounce30',data={x:time,y:avebounce[*,30]}
store_data,payload+'_avebounce50',data={x:time,y:avebounce[*,50]}
store_data,payload+'_avebounce75',data={x:time,y:avebounce[*,75]}
store_data,payload+'_avebounce150',data={x:time,y:avebounce[*,150]}

tots = avebounce[*,30] + avebounce[*,50] + avebounce[*,75] + avebounce[*,150]
store_data,payload+'_avebouncetots',data={x:time,y:tots}
tplot,[payload+'_avebounce',payload+'_avebounce50',payload+'_avebouncetots']




rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
rbsp_efw_dcfield_removal_crib,probe,/no_spice_load,/noplot



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
bu2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bv2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bw2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bu2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.
bv2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.
bw2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.

nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}


get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2b
bu2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bv2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bw2.y[*,hissremove_low[0]:hissremove_low[1]] = 0.
bu2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.
bv2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.
bw2.y[*,hissremove_high[0]:hissremove_high[1]] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,['Bfield_hissinta','Bfield_hissintb']
;-----------------------------------------------
;MAGEIS file
cdf2tplot,file=pn+fnt
get_data,'FESA',data=dd
store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESA',data=dd
store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesa_2mev',0.02,100,1
ylim,'FESA',30,4000,1
tplot,'FESA'
zlim,'FESA',0,1d5
;-----------------------------------------------

;spinperiod = 11.8
rbsp_load_barrel_lc,payload,date,type='rcnt'

;Get rid of NaN values in the peak detector data. This messes up the downsampling

for i=0,n_elements(payload)-1 do begin   $
   get_data,'PeakDet_'+payload[i],data=dd  & $
   goo = where(dd.y lt 0.)                & $
   if goo[0] ne -1 then dd.y[goo] = !values.f_nan   & $
   xv = dd.x   & $
   yv = dd.y   & $
   interp_gap,xv,yv  & $
   store_data,'PeakDet_'+payload[i],data={x:xv,y:yv}  & $
   options,'PeakDet_'+payload[i],'colors',250



tinterpol_mxn,payload+'_avebounce50','PeakDet_'+payload
tinterpol_mxn,payload+'_avebouncetots','PeakDet_'+payload


;; get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
;; times = esvy.x



;; ;Transform Bfield into MGSE
;; get_data,'rbspa_spinaxis_direction_gse',data=wsc
;; wsc_gse = reform(wsc.y[0,*])
;; rbsp_gse2mgse,'rbspa_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
;; tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag',times,newname='rbspa_emfisis_l3_1sec_mgse_Mag'


get_data,'FESA',data=fesa
store_data,'fesa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesa144',data={x:fesa.x,y:fesa.y[*,8]}

get_data,'FPSA',data=fpsa
store_data,'fpsa58',data={x:fpsa.x,y:fpsa.y[*,0]}
store_data,'fpsa70',data={x:fpsa.x,y:fpsa.y[*,1]}
store_data,'fpsa83',data={x:fpsa.x,y:fpsa.y[*,2]}
store_data,'fpsa99',data={x:fpsa.x,y:fpsa.y[*,3]}
store_data,'fpsa118',data={x:fpsa.x,y:fpsa.y[*,4]}


;; T1 = '2014-01-03/19:00'
;; T2 = '2014-01-03/23:00'

;; si = 3
;; oi = 4


si = 4
oi = 4
Results1=cross_spec_tplot('PeakDet_'+payload,0,'Bfield_hissinta',0,T1,T2,sub_interval=si,overlap_index=oi)
Results2=cross_spec_tplot('PeakDet_'+payload,0,'densitya',0,T1,T2,sub_interval=si,overlap_index=oi)
Results3=cross_spec_tplot('PeakDet_'+payload,0,'rbspa_emfisis_l3_1sec_gse_Magnitude',0,T1,T2,sub_interval=si,overlap_index=oi)
Results4=cross_spec_tplot('PeakDet_'+payload,0,'fesa30',0,T1,T2,sub_interval=si,overlap_index=oi)
Results5=cross_spec_tplot('PeakDet_'+payload,0,'fesa54',0,T1,T2,sub_interval=si,overlap_index=oi)
Results6=cross_spec_tplot('PeakDet_'+payload,0,'fesa80',0,T1,T2,sub_interval=si,overlap_index=oi)
Results7=cross_spec_tplot('PeakDet_'+payload,0,'fesa108',0,T1,T2,sub_interval=si,overlap_index=oi)
Results8=cross_spec_tplot('PeakDet_'+payload,0,'fpsa58',0,T1,T2,sub_interval=si,overlap_index=oi)
Results9=cross_spec_tplot('PeakDet_'+payload,0,payload+'_avebouncetots',0,T1,T2,sub_interval=si,overlap_index=oi)



Time_rbsp=strmid(T1,0,10)+'_'+strmid(T1,11,2)+strmid(T1,14,2)+'UT'+'_to_'+strmid(T2,0,10)+'_'+strmid(T2,11,2)+strmid(T2,14,2)+'UT'


;Find wave period to normalize to
goo = where(Results1[*,0] ge periodnormal)
Results1[*,3] /= Results1[goo[0],3]
goo = where(Results1[*,0] ge periodnormal)
Results1[*,4] /= Results1[goo[0],4]
goo = where(Results2[*,0] ge periodnormal)
Results2[*,4] /= Results2[goo[0],4]
goo = where(Results3[*,0] ge periodnormal)
Results3[*,4] /= Results3[goo[0],4]
goo = where(Results4[*,0] ge periodnormal)
Results4[*,4] /= Results4[goo[0],4]
goo = where(Results5[*,0] ge periodnormal)
Results5[*,4] /= Results5[goo[0],4]
goo = where(Results6[*,0] ge periodnormal)
Results6[*,4] /= Results6[goo[0],4]
goo = where(Results7[*,0] ge periodnormal)
Results7[*,4] /= Results7[goo[0],4]
goo = where(Results8[*,0] ge periodnormal)
Results8[*,4] /= Results8[goo[0],4]
goo = where(Results9[*,0] ge periodnormal)
Results9[*,4] /= Results9[goo[0],4]


;**************************************************
;plot power spectra
!p.charsize = 1.8
!p.multi = [0,0,5]
;; Plot,Results1[*,0],Results1[*,3],xtitle='f, Hz', ytitle='Power x-rays (counts^2/Hz)',$
;;      title=rbspx+time_rbsp + '. Normalized to power at '+strtrim(1/periodnormal/60.,2) + ' min period',$
;;      xrange=[0,0.01],yrange=[0.001,1],/ylog
;; oplot,[0.0013,0.0013],[1,10d9],thick=2
;; oplot,[0.0067,0.0067],[1,10d9],thick=2
;---
Plot,Results1[*,0],Results1[*,4],xtitle='f, Hz', ytitle='Power hiss (nT^2/Hz)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.0001,1],/ylog
oplot,Results1[*,0],Results1[*,3],color=250
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
;---
Plot,Results9[*,0],Results9[*,4],xtitle='f, Hz', ytitle='<Daa> (1/s)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.0001,1],/ylog
oplot,Results1[*,0],Results1[*,3],color=250
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
;---
Plot,Results2[*,0],Results2[*,4],xtitle='f, Hz', ytitle='Power dens (dens^2/Hz)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.0001,1],/ylog
oplot,Results1[*,0],Results1[*,3],color=250
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2
;---
Plot,Results3[*,0],Results3[*,4],xtitle='f, Hz', ytitle='Power Bmag (nT^2/Hz)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.0001,1],/ylog
oplot,Results1[*,0],Results1[*,3],color=250
oplot,[0.0013,0.0013],[0,10d9],thick=2
oplot,[0.0067,0.0067],[0,10d9],thick=2
;---
Plot,Results5[*,0],Results5[*,4],xtitle='f, Hz', ytitle='Power FESA54 (counts^2/Hz)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.0001,1],/ylog
oplot,Results1[*,0],Results1[*,3],color=250
oplot,[0.0013,0.0013],[1,10d9],thick=2
oplot,[0.0067,0.0067],[1,10d9],thick=2


;; Plot,Results8[*,0],Results8[*,4],xtitle='f, Hz', ytitle='Power FPSA58 (counts^2/Hz)!Cand x-rays (red)',xrange=[0,0.01],yrange=[0.001,1],/ylog
;; oplot,Results8[*,0],Results8[*,4],color=250
;; oplot,[0.0013,0.0013],[1,10d9],thick=2
;; oplot,[0.0067,0.0067],[1,10d9],thick=2
;**************************************************





;**************************************************
;Plot coherency vs freq

!p.multi = [0,0,5]
Plot,Results1[*,0],Results1[*,2],xtitle='f, Hz', ytitle='Coherence!Chiss and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1]/nodata
Plot,Results9[*,0],Results9[*,2],xtitle='f, Hz', ytitle='Coherence!C<Daa> and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1] ;precip and <Daa>
Plot,Results1[*,0],Results1[*,2],xtitle='f, Hz', ytitle='Coherence!Chiss and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1]	;precip and hiss  
Plot,Results2[*,0],Results2[*,2],xtitle='f, Hz', ytitle='Coherence!Cdensity and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1]  ;precip and dens
  ;precip and dens
Plot,Results3[*,0],Results3[*,2],xtitle='f, Hz', ytitle='Coherence!CBo and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1] ;precip and Bmag
Plot,Results5[*,0],Results5[*,2],xtitle='f, Hz', ytitle='Coherence!CFESA54 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.4,1] ;precip and FESA54
;; Plot,Results7[*,0],Results7[*,2],xtitle='f, Hz', ytitle='Coherence!CFESA108 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.6,1] ;precip and FESA108
;; Plot,Results8[*,0],Results8[*,2],xtitle='f, Hz', ytitle='Coherence!CFPSA58 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[0.6,1] ;precip and FPSA58

;**************************************************

;; !p.multi = [0,0,6]
;; Plot,Results1[*,0],Results1[*,1],xtitle='f, Hz', ytitle='Coherence!Chiss and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10]/nodata
;; Plot,Results1[*,0],Results1[*,1],xtitle='f, Hz', ytitle='Coherence!Chiss and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10]	;precip and hiss  
;; Plot,Results2[*,0],Results2[*,1],xtitle='f, Hz', ytitle='Coherence!Cdensity and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10]  ;precip and dens
;;   ;precip and dens
;; Plot,Results3[*,0],Results3[*,1],xtitle='f, Hz', ytitle='Coherence!CBo and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10] ;precip and Bmag
;; Plot,Results4[*,0],Results4[*,1],xtitle='f, Hz', ytitle='Coherence!CFESA30 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10] ;precip and FESA30
;; Plot,Results7[*,0],Results7[*,1],xtitle='f, Hz', ytitle='Coherence!CFESA108 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10] ;precip and FESA108
;; Plot,Results8[*,0],Results8[*,1],xtitle='f, Hz', ytitle='Coherence!CFPSA58 and xrays',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-10,10] ;precip and FPSA58




;; Plot,Results1[*,0],Results1[*,1]/!dtor,xtitle='f, Hz', ytitle='Phase_Ey_Ez',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[-180,180],ystyle=1,/nodata
;; oplot,[0.0013,0.0013],[-180,180],thick=2
;; oplot,[0.0067,0.0067],[-180,180],thick=2
;; oPlot,Results1[*,0],Results1[*,1]/!dtor,color=0	;precip and hiss  
;; oPlot,Results2[*,0],Results2[*,1]/!dtor,color=50  ;precip and dens
;; oPlot,Results10[*,0],Results10[*,1]/!dtor,color=50  ;precip and BzGSE
;; oPlot,Results3[*,0],Results3[*,1]/!dtor,color=100 ;precip and Bz
;; oPlot,Results4[*,0],Results4[*,1]/!dtor,color=150 ;precip and Bx
;; oPlot,Results5[*,0],Results5[*,1]/!dtor,color=200 ;precip and FESA30
;; oPlot,Results9[*,0],Results9[*,1]/!dtor,color=250 ;precip and FESA108



;--------------------------------------------------
;Detrend quantities to plot comparison with x-ray counts
;--------------------------------------------------

ylim,'PeakDet_'+payload,4000,14000
ylim,'Bfield_hissinta',0,80
ylim,'densitya',100,2000,1
ylim,'fesa54',5d4,2d5
;ylim,payload+'_avebouncetots'

;; rbsp_detrend,['rbspa_emfisis_l3_1sec_gse_Magnitude'],60.*60.
;; tplot,['rbspa_emfisis_l3_1sec_gse_Magnitude_detrend','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed']


;Subtract off the DC field T89 model. Otherwise it's very
;difficult to detrend mag data for Jan 3rd event.
get_data,'rbspa_mag_gse_t89',data=bmm
bmagmm = sqrt(bmm.y[*,0]^2 + bmm.y[*,1]^2 + bmm.y[*,2]^2)
store_data,'bmagmm',data={x:bmm.x,y:bmagmm}


tinterpol_mxn,'rbspa_emfisis_l3_1sec_gse_Magnitude','PeakDet_'+payload,newname='rbspa_emfisis_l3_1sec_gse_Magnitude'
tinterpol_mxn,'bmagmm','PeakDet_'+payload,newname='bmagmm'
tinterpol_mxn,'densitya','PeakDet_'+payload,newname='densitya'

dif_data,'rbspa_emfisis_l3_1sec_gse_Magnitude','bmagmm'

;; rbsp_downsample,'rbspa_emfisis_l3_1sec_gse_Magnitude-bmagmm',60.*1.,newname='rbspa_emfisis_l3_1sec_gse_Magnitude-bmagmm'
;; rbsp_downsample,'densitya',60.*1.,newname='densitya'

tplot,['PeakDet_'+payload,'Bfield_hissinta','densitya','rbspa_emfisis_l3_1sec_gse_Magnitude','fesa30',payload+'_avebouncetots']
tlimit,T1,T2

rbsp_detrend,['PeakDet_'+payload,'Bfield_hissinta','densitya','rbspa_emfisis_l3_1sec_gse_Magnitude-bmagmm','fesa30',payload+'_avebouncetots'],60.*15.

ylim,'densitya_detrend',-100,100
ylim,'rbspa_emfisis_l3_1sec_gse_Magnitude-bmagmm_detrend',-3,3
ylim,payload+'_avebouncetots_detrend',-0.0002,0.0002
tplot_options,'title','From coherence_vs_freq_plot.pro'
tplot,['PeakDet_'+payload,payload+'_avebouncetots','Bfield_hissinta','densitya','rbspa_emfisis_l3_1sec_gse_Magnitude-bmagmm','fesa30'] + '_detrend'


;; store_data,'hisscomb',data=['PeakDet_'+payload,'Bfield_hissinta'] + '_detrend'
;; store_data,'denscomb',data=['PeakDet_'+payload,'densitya'] + '_detrend'
;; store_data,'bmagcomb',data=['PeakDet_'+payload,'rbspa_emfisis_l3_1sec_gse_Magnitude'] + '_detrend'
;; store_data,'fesa30comb',data=['PeakDet_'+payload,'fesa30'] + '_detrend'

;; options,'hisscomb','colors',[0,250]
;; options,'denscomb','colors',[0,250]
;; options,'bmagcomb','colors',[0,250]
;; options,'fesa30comb','colors',[0,250]

;; tplot,['hisscomb','denscomb','bmagcomb','fesa30comb']



















ylim,['Precip_hissa_coherence','Precip_hissb_coherence'],0,0.01,0
zlim,'*_coherence*',0.6,1
tplot,['Precip_hissa_coherence','Precip_hissb_coherence','Precip_diffusiontots_coherence','Precip_dens_coherence','Precip_BzFA_coherence','Precip_BxFA_coherence','Precip_fesa30_coherence',v1]
timebar,0.0013,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissa_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_hissb_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_diffusiontots_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_diffusiontots_coherence',/databar,thick=2
;timebar,0.0013,varname='Precip_diffusion30_coherence',/databar,thick=2
;timebar,0.005,varname='Precip_diffusion30_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0013,varname='Precip_fesa30_coherence',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_coherence',/databar,thick=2




;zlim,'*_coherence*',0.5,1
tplot,['Precip_hiss_phase','Precip_dens_phase','Precip_BzFA_phase','Precip_BxFA_phase','Precip_fesa30_phase',v1]
timebar,0.0013,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.0067,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.0013,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0067,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0013,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0013,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0067,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0013,varname='Precip_fesa30_phase',/databar,thick=2
timebar,0.0067,varname='Precip_fesa30_phase',/databar,thick=2










;*****************************************************
;FIND CORRELATION LENGTH FOR HISS ON JAN 3
;*****************************************************


T1='2014-01-03/18:00:00'	
T2='2014-01-03/23:00:00'	


;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'
get_data,'hissa_hissb_coherence',data=coh
get_data,'hissa_hissb_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'hissa_hissb_coherence',data=coh
store_data,'hissa_hissb_phase',data=ph
options,'hissa_hissb_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'hissa_hissb_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['hissa_hissb_coherence','hissa_hissb_phase'],-0.001,0.01
tplot,['hissa_hissb_coherence','hissa_hissb_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']
timebar,0.0013,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0075,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0067,varname='hissa_hissb_coherence',/databar,thick=2
timebar,0.0013,varname='hissa_hissb_phase',/databar,thick=2
timebar,0.0075,varname='hissa_hissb_phase',/databar,thick=2
timebar,0.0067,varname='hissa_hissb_phase',/databar,thick=2


;Total up the hiss coherence for each time
;****REMOVE DATA THAT ARE NOT HISS
;****
get_data,'hissa_hissb_coherence',data=hisscoh
hctot = fltarr(n_elements(hisscoh.x))

for i=0,n_elements(hisscoh.x)-1 do hctot[i] = total(hisscoh.y[i,*],/nan)
hctot = hctot/max(hctot,/nan)
store_data,'hctot',data={x:hisscoh.x,y:hctot}
;hiss_3min = hisscoh.y[*,9]
;hiss_3min = hisscoh.y[*,9]
;store_data,'hc3min',data={x:hisscoh.x,y:hiss_3min}


;ylim,'hc3min',0.5,1,1
;tplot,['hctot','hc3min','hissa_hissb_coherence','hissa_hissb_phase',v1,v2,'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff']

tinterpol_mxn,'rbsp_state_sc_sep','hctot'
tinterpol_mxn,'rbsp_state_lshell_diff','hctot'
;tinterpol_mxn,'Bfield_hissinta','hctot'
get_data,'rbsp_state_sc_sep_interp',data=sep
get_data,'rbsp_state_lshell_diff',data=dl

store_data,'rbsp_state_sc_sep_re',data={x:sep.x,y:1000.*sep.y/6370.}
tplot,'rbsp_state_sc_sep_re'


;get_data,'Bfield_hissinta_interp',data=hia


;Reduce to times of interest
tt0 = time_double('2014-01-03/18:00')
tt1 = time_double('2014-01-03/23:00')
goo = where((hisscoh.x ge tt0) and (hisscoh.x le tt1))


yv = tsample('Bfield_hissinta',[tt0,tt1],times=tms)
store_data,'Bfield_hissinta_reduced',data={x:tms,y:yv}
tinterpol_mxn,'Bfield_hissinta_reduced','hctot'
get_data,'Bfield_hissinta_reduced_interp',data=bi

;Wave periods
periods = 1/hisscoh.v[0:20]/60.


zlim,['dynamic_FFT_1','dynamic_FFT_2'],1d-2,1d0,1
ylim,['dynamic_FFT_1','dynamic_FFT_2'],-0.001,0.01,0
tplot,['dynamic_FFT_1','Bfield_hissinta','dynamic_FFT_2','Bfield_hissintb']
timebar,0.0075,varname='dynamic_FFT_1',/databar,thick=2
timebar,0.0055,varname='dynamic_FFT_1',/databar,thick=2
timebar,0.0075,varname='dynamic_FFT_2',/databar,thick=2
timebar,0.0055,varname='dynamic_FFT_2',/databar,thick=2

get_data,'dynamic_FFT_1',data=ffta
get_data,'dynamic_FFT_2',data=fftb


;twavpol,'Bfield_hissinta',nopfft=nfft,steplength=sl
;freqspec = 1/sp.v/60.


!p.multi = [0,0,3]
;PLOT COHERENCE FOR SELECT FREQUENCIES ON JAN 3rd
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,9],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B!CBlack=15min,Red=3.33min,Green=1.5min waves',/nodata
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,1],psym=4,color=0 ;30 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,2],psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,3],psym=0,color=250 ;10 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,4],psym=4 ;7.5 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,5],psym=0,color=150 ;6 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,6],psym=4 ;5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,7],psym=4,color=100 ;4.3 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,8],psym=0,color=200 ;3.75 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,9],psym=0,color=250 ;3.33 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,10],psym=4,color=175 ;3 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,11],psym=4 ;2.7 min
oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,12],psym=0,color=100 ;2.5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,20],psym=4,color=150 ;1.5 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,19],psym=4,color=220 ;1.57 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,18],psym=4,color=240 ;1.67 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,15],psym=0,color=250 ;2 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,17],psym=4 ;1.76 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,16],psym=4 ;1.87 min
;oplot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,14],psym=0 ;2.14 min


;PLOT POWER FOR SELECT FREQUENCIES ON JAN 6TH
plot,1000.*sep.y[goo]/6370.,1000.*ffta.y[goo,9],xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A',/nodata,yrange=[1.,1000.],/ylog
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,2])),psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,3])),psym=0,color=250 ;10 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,5])),psym=0,color=150 ;6 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,12])),psym=0,color=100 ;2.5 min
plot,1000.*sep.y[goo]/6370.,fftb.y[goo,9],xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B',/nodata,yrange=[1.,1000.],/ylog
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,2])),psym=0,color=0 ;15 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,3])),psym=0,color=250 ;10 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,5])),psym=0,color=150 ;6 min
oplot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,12])),psym=0,color=100 ;2.5 min

;end jan3
;-----------------------------------------------------------





!p.multi = [0,0,3]
;PLOT COHERENCE FOR SELECT FREQUENCIES
ae = 12
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
ae = 3
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
ae = 5
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
;These are the 3min waves at 2000
ae = 10
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog

!p.multi = [0,0,3]
;These are the 2min waves at 2000
ae = 14
print,periods[ae]
plot,1000.*sep.y[goo]/6370.,hisscoh.y[goo,ae],xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss b/t RBSP-A and RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[0,1]
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*ffta.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='Integrated Hiss power (pT) on RBSP-A for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog
plot,1000.*sep.y[goo]/6370.,sqrt(abs(1000.*fftb.y[goo,ae])),xtitle='SC separation (RE)',ytitle='PowerFFT',$
	title='IntegratedHiss power (pT) on RBSP-B for '+strtrim(periods[ae],2)+' min period waves',yrange=[1.,100.],/ylog















;*****************************************************
;FIND CORRELATION LENGTH FOR HISS ON JAN 3
;*****************************************************


;T1='2014-01-03/18:00:00'	
;T2='2014-01-03/23:00:00'	
T1='2014-01-03/19:30:00'	
T2='2014-01-03/22:30:00'	

rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
split_vec,'rbspb_emfisis_l3_1sec_gse_Mag'
split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'


;--------------------------------------------------
;Settle on FFT properties
;--------------------------------------------------

window = 60.*10.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'
get_data,'hissa_hissb_coherence',data=coh
get_data,'hissa_hissb_phase',data=ph

help,coh,/st

var = 'hissa_hissb_coherence'
get_data,var,data=dat
periods = 1/dat.v/60.
for i=0,100 do print,i,periods[i]

;--------------------------------------------------




ae1 = 4
ae2 = 10

print,1/dat.v[ae1:ae2]/60.

v1 = 'Bfield_hissinta'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='hissa_hissb'

var = 'hissa_hissb_coherence'
get_data,var,data=dat

for i=0,n_elements(dat.x)-1 do hc3m_hiss[i] = max(dat.y[i,ae1:ae2],/nan)

get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspa_state_mlt','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_lshell','hissa_hissb_coherence'
tinterpol_mxn,'rbspb_state_mlt','hissa_hissb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

tinterpol_mxn,'rbsp_state_sc_sep','hissa_hissb_coherence'
get_data,'rbsp_state_sc_sep_interp',data=sep







v1 = 'densitya'
v2 = 'densityb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='densitya_densityb'
var = 'densitya_densityb_coherence'
get_data,var,data=dat
;hc3m_dens = dat.y[*,ae]
for i=0,n_elements(dat.x)-1 do hc3m_dens[i] = max(dat.y[i,ae1:ae2],/nan)



v1 = 'rbspa_emfisis_l3_1sec_gse_Mag_z_detrend'
v2 = 'rbspb_emfisis_l3_1sec_gse_Mag_z_detrend'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='bza_bzb'
var = 'bza_bzb_coherence'
get_data,var,data=dat
;hc3m_mag = dat.y[*,ae]
for i=0,n_elements(dat.x)-1 do hc3m_mag[i] = max(dat.y[i,ae1:ae2],/nan)




!p.multi = [0,0,3]
plot,1000.*sep.y/6370.,hc3m_hiss,xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5]
oplot,1000.*sep.y/6370.,hc3m_dens,color=50
oplot,1000.*sep.y/6370.,hc3m_mag,color=250


plot,abs(la.y-lb.y),hc3m_hiss,xtitle='Delta Lshell',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,2.5]
oplot,abs(la.y-lb.y),hc3m_dens,color=50
oplot,abs(la.y-lb.y),hc3m_mag,color=250


plot,abs(mlta.y-mltb.y),hc3m_hiss,xtitle='Delta MLT',ytitle='Coherence',$
	title='Coherence length of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5],xstyle=1
oplot,abs(mlta.y-mltb.y),hc3m_dens,color=50
oplot,abs(mlta.y-mltb.y),hc3m_mag,color=250





;histogram the results to simplify plots
cormin = 0.5
goo = where(hc3m_hiss le cormin)
hc3m_hiss[goo] = !values.f_nan

hc3m_hiss_Lshell = fltarr(5)
hc3m_hiss_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[0] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[1] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[2] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[3] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_lshell[4] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[4] = cnt
;-----
cormin = 0.5
goo = where(hc3m_dens le cormin)
hc3m_dens[goo] = !values.f_nan

hc3m_dens_Lshell = fltarr(5)
hc3m_dens_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[0] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[1] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[2] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[3] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_lshell[4] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[4] = cnt
;---------
cormin = 0.5
goo = where(hc3m_mag le cormin)
hc3m_mag[goo] = !values.f_nan

hc3m_mag_Lshell = fltarr(5)
hc3m_mag_cnt = fltarr(5)
ladiff = abs(la.y - lb.y)
goo = where((ladiff ge 0 ) and (ladiff le 0.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[0] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[0] = cnt
goo = where((ladiff ge 0.5 ) and (ladiff le 1))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[1] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[1] = cnt
goo = where((ladiff ge 1 ) and (ladiff le 1.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[2] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[2] = cnt
goo = where((ladiff ge 1.5 ) and (ladiff le 2.0))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[3] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[3] = cnt
goo = where((ladiff ge 2 ) and (ladiff le 2.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_lshell[4] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[4] = cnt
;-------------------------------------------------------



;histogram the results to simplify plots
cormin = 0.5
goo = where(hc3m_hiss le cormin)
hc3m_hiss[goo] = !values.f_nan

hc3m_hiss_mlt = fltarr(6)
hc3m_hiss_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[0] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[1] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[2] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[3] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[4] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_hiss[goo]) ne 0,cnt)
hc3m_hiss_mlt[5] = total(hc3m_hiss[goo],/nan)/cnt
hc3m_hiss_cnt[5] = cnt


;-----
cormin = 0.5
goo = where(hc3m_dens le cormin)
hc3m_dens[goo] = !values.f_nan

hc3m_dens_mlt = fltarr(6)
hc3m_dens_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[0] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[1] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[2] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[3] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[4] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_dens[goo]) ne 0,cnt)
hc3m_dens_mlt[5] = total(hc3m_dens[goo],/nan)/cnt
hc3m_dens_cnt[5] = cnt

;-----
cormin = 0.5
goo = where(hc3m_mag le cormin)
hc3m_mag[goo] = !values.f_nan

hc3m_mag_mlt = fltarr(6)
hc3m_mag_cnt = fltarr(6)
mltdiff = abs(mlta.y - mltb.y)
goo = where((mltdiff ge 0.5 ) and (mltdiff le 1))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[0] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[0] = cnt
goo = where((mltdiff ge 1 ) and (mltdiff le 1.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[1] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[1] = cnt
goo = where((mltdiff ge 1.5 ) and (mltdiff le 2.0))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[2] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[2] = cnt
goo = where((mltdiff ge 2 ) and (mltdiff le 2.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[3] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[3] = cnt
goo = where((mltdiff ge 2.5 ) and (mltdiff le 3))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[4] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[4] = cnt
goo = where((mltdiff ge 3 ) and (mltdiff le 3.5))
n = where(finite(hc3m_mag[goo]) ne 0,cnt)
hc3m_mag_mlt[5] = total(hc3m_mag[goo],/nan)/cnt
hc3m_mag_cnt[5] = cnt






!p.multi = [0,0,3]
plot,1000.*sep.y/6370.,hc3m_hiss,xtitle='SC separation (RE)',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5]
oplot,1000.*sep.y/6370.,hc3m_dens,color=50
oplot,1000.*sep.y/6370.,hc3m_mag,color=250


lshells = [0.5,1,1.5,2,2.5] - 0.25
plot,lshells,hc3m_hiss_lshell,xtitle='Delta Lshell',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,2.5]
oplot,lshells,hc3m_dens_lshell,color=50
oplot,lshells,hc3m_mag_lshell,color=250

mlts = [1,1.5,2,2.5,3,3.5] - 0.5
plot,mlts,hc3m_hiss_mlt,xtitle='Delta MLT',ytitle='Coherence',$
	title='Avg Coherence of hiss(black), density(blue), BzGSE(red) b/t RBSP-A and RBSP-B for '+strtrim(periods[ae2],2)+'-'+strtrim(periods[ae1],2)+' min period waves',yrange=[0.4,1],xrange=[0,3.5],xstyle=1
oplot,mlts,hc3m_dens_mlt,color=50
oplot,mlts,hc3m_mag_mlt,color=250




