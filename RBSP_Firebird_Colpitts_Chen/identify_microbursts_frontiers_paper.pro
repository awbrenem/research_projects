;Plot identified microbursts for the 2017-12-05 for Frontiers paper
;Purpose is to check my id. Actual microbursts come from microbursts_and_properties_20171205.pro

rbsp_efw_init

timespan,'2017-12-05'

firebird_load_data,'3' 
firebird_load_data,'4' 

copy_data,'fu3_fb_col_hires_flux','fu3_fb_col_hires_fluxlog'
copy_data,'fu4_fb_col_hires_flux','fu4_fb_col_hires_fluxlog'
ylim,'fu3_fb_col_hires_flux',0,0,0
ylim,'fu3_fb_col_hires_fluxlog',0.01,100,1
ylim,'fu4_fb_col_hires_flux',0,0,0
ylim,'fu4_fb_col_hires_fluxlog',0.01,100,1

rbsp_detrend,'fu3_fb_col_hires_flux',10.
copy_data,'fu3_fb_col_hires_flux_smoothed','fu3_fb_col_hires_flux_smoothedlog'
ylim,'fu3_fb_col_hires_flux_smoothed',0,0,0
ylim,'fu3_fb_col_hires_flux_smoothedlog',0.01,100,1

rbsp_detrend,'fu4_fb_col_hires_flux',10.
copy_data,'fu4_fb_col_hires_flux_smoothed','fu4_fb_col_hires_flux_smoothedlog'
ylim,'fu4_fb_col_hires_flux_smoothed',0,0,0
ylim,'fu4_fb_col_hires_flux_smoothedlog',0.01,100,1


split_vec,'fu3_fb_col_hires_flux_smoothed'
div_data,'fu3_fb_col_hires_flux_smoothed_0','fu3_fb_col_hires_flux_smoothed_1'
options,'fu3_fb_col_hires_flux_smoothed_0/fu3_fb_col_hires_flux_smoothed_1','ytitle','Ratio 0/1'


split_vec,'fu4_fb_col_hires_flux_smoothed'
div_data,'fu4_fb_col_hires_flux_smoothed_0','fu4_fb_col_hires_flux_smoothed_1'
options,'fu4_fb_col_hires_flux_smoothed_0/fu4_fb_col_hires_flux_smoothed_1','ytitle','Ratio 0/1'

split_vec,'fu3_fb_col_hires_flux'
ylim,'fu3_fb_col_hires_flux_smoothed_?',0,0,0
ylim,'fu3_fb_col_hires_flux_?',0,0,0
div_data,'fu3_fb_col_hires_flux_0','fu3_fb_col_hires_flux_1'
options,'fu3_fb_col_hires_flux_0/fu3_fb_col_hires_flux_1','ytitle','Ratio 0/1'

split_vec,'fu4_fb_col_hires_flux'
ylim,'fu4_fb_col_hires_flux_smoothed_?',0,0,0
ylim,'fu4_fb_col_hires_flux_?',0,0,0
div_data,'fu4_fb_col_hires_flux_0','fu4_fb_col_hires_flux_1'
options,'fu4_fb_col_hires_flux_0/fu4_fb_col_hires_flux_1','ytitle','Ratio 0/1'



store_data,'bin0comb',data=['fu3_fb_col_hires_flux_0','fu3_fb_col_hires_flux_smoothed_0']
store_data,'bin1comb',data=['fu3_fb_col_hires_flux_1','fu3_fb_col_hires_flux_smoothed_1']
store_data,'bin2comb',data=['fu3_fb_col_hires_flux_2','fu3_fb_col_hires_flux_smoothed_2']
store_data,'bin3comb',data=['fu3_fb_col_hires_flux_3','fu3_fb_col_hires_flux_smoothed_3']
store_data,'bin4comb',data=['fu3_fb_col_hires_flux_4','fu3_fb_col_hires_flux_smoothed_4']
store_data,'bin5comb',data=['fu3_fb_col_hires_flux_5','fu3_fb_col_hires_flux_smoothed_5']
options,'bin?comb','colors',[0,250]

tplot,['bin?comb']


options,['fu?_fb_mcilwainL_from_hiresfile','fu?_fb_mlt_from_hiresfile'],'panel_size',1.




;tplot,['fu3_fb_col_hires_flux_smoothed','fu3_fb_col_hires_flux','fu3_fb_col_hires_fluxlog','fu3_fb_col_hires_flux_smoothedlog','fu3_fb_mlt_from_hiresfile','fu3_fb_mcilwainL_from_hiresfile']

;tplot,['fu3_fb_col_hires_flux_smoothed_0/fu3_fb_col_hires_flux_smoothed_1',$
;'fu3_fb_col_hires_flux_smoothed_0',$
;'fu3_fb_col_hires_flux_smoothed_1',$
;'fu3_fb_col_hires_flux_smoothed_2',$
;'fu3_fb_col_hires_flux_smoothed_3',$
;'fu3_fb_col_hires_flux_smoothed_4',$
;'fu3_fb_col_hires_flux_smoothed_5']

;tplot,['fu3_fb_col_hires_flux_0/fu3_fb_col_hires_flux_1',$
;'fu3_fb_col_hires_flux_0',$
;'fu3_fb_col_hires_flux_1',$
;'fu3_fb_col_hires_flux_2',$
;'fu3_fb_col_hires_flux_3',$
;'fu3_fb_col_hires_flux_4',$
;'fu3_fb_col_hires_flux_5',$
;'fu3_fb_mcilwainL_from_hiresfile',$
;'fu3_fb_mlt_from_hiresfile']

;tplot,['fu4_fb_col_hires_flux_0/fu4_fb_col_hires_flux_1',$
;'fu4_fb_col_hires_flux_0',$
;'fu4_fb_col_hires_flux_1',$
;'fu4_fb_col_hires_flux_2',$
;'fu4_fb_col_hires_flux_3',$
;'fu4_fb_col_hires_flux_4',$
;'fu4_fb_col_hires_flux_5',$
;'fu4_fb_mcilwainL_from_hiresfile',$
;'fu4_fb_mlt_from_hiresfile']


;-----------------------------------------------
;Shumko's microburst list 
;--using this only as comparison to my my-eye list
ub = load_firebird_microburst_list('3')                                              

;Mike's data aren't time-corrected
datestmp = strarr(n_elements(ub.time))
for i=0,n_elements(datestmp)-1 do datestmp[i] = strmid(ub.time[i],0,10)
goob = where(datestmp eq '2017-12-05')


for i=0,n_elements(goob)-1 do begin $
     corr = tsample('fu3_fb_count_time_correction',time_double(ub.time[goob[i]]),times=tms) & $
     ttmp = time_double(ub.time[goob[i]]) + corr & $
     ub.time[goob[i]] = time_string(ttmp,prec=3)
endfor

;for i=0,1000 do print,ub.time[goob[i]],ub.flux_ch1[goob[i]],ub.flux_ch2[goob[i]],ub.flux_ch3[goob[i]],ub.flux_ch4[goob[i]],ub.flux_ch5[goob[i]]
;-----------------------------------------------




;-----------------------------------------------------------------
;Aaron's by-eye microburst list 
uba = microbursts_and_properties_20171205()

t_ancillary_fu3 = uba.t_ancillary_fu3
t_ancillary_fu4 = uba.t_ancillary_fu4
tpeak_fu3 = uba.tpeak_fu3
tpeak_fu4 = uba.tpeak_fu4
fluxpeak_fu3 = uba.fluxpeak_fu3
fluxpeak_fu4 = uba.fluxpeak_fu4
bgleft_fu3 = uba.bgleft_fu3
bgleft_fu4 = uba.bgleft_fu4
bgright_fu3 = uba.bgright_fu3
bgright_fu4 = uba.bgright_fu4
tstart_fu3 = uba.tstart_fu3
tstart_fu4 = uba.tstart_fu4
tstop_fu3 = uba.tstop_fu3
tstop_fu4 = uba.tstop_fu4






Lvals_fu3a = fltarr(n_elements(t_ancillary_fu3))
MLTvals_fu3a = fltarr(n_elements(t_ancillary_fu3))
for i=0,n_elements(t_ancillary_fu3)-1 do Lvals_fu3a[i] = tsample('fu3_fb_mcilwainL_from_hiresfile',time_double(t_ancillary_fu3[i]))
for i=0,n_elements(t_ancillary_fu3)-1 do MLTvals_fu3a[i] = tsample('fu3_fb_mlt_from_hiresfile',time_double(t_ancillary_fu3[i]))
;Print all FU3 ancillary microbursts
for i=0,n_elements(t_ancillary_fu3)-1 do print,t_ancillary_fu3[i],lvals_fu3a[i],mltvals_fu3a[i]


Lvals_fu4a = fltarr(n_elements(t_ancillary_fu4))
MLTvals_fu4a = fltarr(n_elements(t_ancillary_fu4))
for i=0,n_elements(t_ancillary_fu4)-1 do Lvals_fu4a[i] = tsample('fu4_fb_mcilwainL_from_hiresfile',time_double(t_ancillary_fu4[i]))
for i=0,n_elements(t_ancillary_fu4)-1 do MLTvals_fu4a[i] = tsample('fu4_fb_mlt_from_hiresfile',time_double(t_ancillary_fu4[i]))
;Print all FU4 ancillary microbursts
for i=0,n_elements(t_ancillary_fu4)-1 do print,t_ancillary_fu4[i],lvals_fu4a[i],mltvals_fu4a[i]


Lvals_fu3 = fltarr(n_elements(tpeak_fu3))
MLTvals_fu3 = fltarr(n_elements(tpeak_fu3))
for i=0,n_elements(tpeak_fu3)-1 do Lvals_fu3[i] = tsample('fu3_fb_mcilwainL_from_hiresfile',time_double(tpeak_fu3[i]))
for i=0,n_elements(tpeak_fu3)-1 do MLTvals_fu3[i] = tsample('fu3_fb_mlt_from_hiresfile',time_double(tpeak_fu3[i]))
;Print all FU3 microbursts
for i=0,n_elements(tpeak_fu3)-1 do print,tpeak_fu3[i],lvals_fu3[i],mltvals_fu3[i]

Lvals_fu4 = fltarr(n_elements(tpeak_fu4))
MLTvals_fu4 = fltarr(n_elements(tpeak_fu4))
for i=0,n_elements(tpeak_fu4)-1 do Lvals_fu4[i] = tsample('fu4_fb_mcilwainL_from_hiresfile',time_double(tpeak_fu4[i]))
for i=0,n_elements(tpeak_fu4)-1 do MLTvals_fu4[i] = tsample('fu4_fb_mlt_from_hiresfile',time_double(tpeak_fu4[i]))
;Print all FU4 microbursts
for i=0,n_elements(tpeak_fu4)-1 do print,tpeak_fu4[i],lvals_fu4[i],mltvals_fu4[i]




;------------------------------------------------------------
;Make plots of all the microbursts 

fu = '3'

if fu eq '3' then nelem = n_elements(tpeak_fu3) else nelem = n_elements(tpeak_fu4)
if fu eq '3' then t = time_double(tpeak_fu3) else t = time_double(tpeak_fu4)
if fu eq '3' then ta = time_double(t_ancillary_fu3) else ta = time_double(t_ancillary_fu4)
ylim,'fu'+fu+'_fb_mcilwainL_from_hiresfile',0,12
ylim,'fu'+fu+'_fb_mlt_from_hiresfile',0,24
ylim,'fu'+fu+'_fb_col_hires_fluxlog',0.001,100,1
options,'fu'+fu+'_fb_col_hires_fluxlog','panel_size',2
if fu eq '3' then tstart = tstart_fu3 else tstart = tstart_fu4
if fu eq '3' then tstop = tstop_fu3 else tstop = tstop_fu4

skip = 0 
if not skip then begin 
for i=0,nelem-1 do begin
     tlimit,t[i]-4,t[i]+4
     tplot,['fu'+fu+'_fb_col_hires_fluxlog',$
     'fu'+fu+'_fb_col_hires_flux_0',$
     'fu'+fu+'_fb_col_hires_flux_1',$
     'fu'+fu+'_fb_col_hires_flux_2',$
     'fu'+fu+'_fb_col_hires_flux_3',$
     'fu'+fu+'_fb_col_hires_flux_4',$
     'fu'+fu+'_fb_mcilwainL_from_hiresfile',$
     'fu'+fu+'_fb_mlt_from_hiresfile'] 
     timebar,t 
     timebar,ta,color=250
     timebar,tstart,color=50 
     timebar,tstop,color=50
     stop
endfor 
endif



;------------------------------------------------------------------------------
;Make plots of all the ANCILLARY microbursts 
if fu eq '3' then nelem = n_elements(t_ancillary_fu3) else nelem = n_elements(t_ancillary_fu4)
if fu eq '3' then ta = time_double(t_ancillary_fu3) else ta = time_double(t_ancillary_fu4)
ylim,'fu'+fu+'_fb_mcilwainL_from_hiresfile',0,12
ylim,'fu'+fu+'_fb_mlt_from_hiresfile',0,24
ylim,'fu'+fu+'_fb_col_hires_fluxlog',0.001,100,1
options,'fu'+fu+'_fb_col_hires_fluxlog','panel_size',2

skip = 1 
if not skip then begin 
for i=0,nelem-1 do begin
     tlimit,ta[i]-4,ta[i]+4
     tplot,['fu'+fu+'_fb_col_hires_fluxlog',$
     'fu'+fu+'_fb_col_hires_flux_0',$
     'fu'+fu+'_fb_col_hires_flux_1',$
     'fu'+fu+'_fb_col_hires_flux_2',$
     'fu'+fu+'_fb_col_hires_flux_3',$
     'fu'+fu+'_fb_col_hires_flux_4',$
     'fu'+fu+'_fb_mcilwainL_from_hiresfile',$
     'fu'+fu+'_fb_mlt_from_hiresfile'] 
     timebar,ta,color=250
     timebar,t
     stop
endfor 
endif





     ;timebar,1.,/databar,varname='fu3_fb_col_hires_flux_0'


end