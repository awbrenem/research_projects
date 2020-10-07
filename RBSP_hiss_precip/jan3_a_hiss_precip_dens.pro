
;Jan 3rd A hiss/modulation/density plot
;First run daily_barrel_conjunctions.pro
;Run w/ peak detector and normal LC


;No E12 FBK signal
;50Hz - 1.6 kHz FBK Bw signal

tlimit,'2014-01-03/20:20','2014-01-03/21:40'
ylim,['rbspa_fbk2_7pk_5','rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3'],0,30
ylim,'density_proxy',0,0
ylim,'PeakDet_2I',4d3,1.2d4
options,'*comb*','panel_size',1
options,'*pk*','panel_size',1


get_data,'density_proxy',data=sum12
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)

store_data,'density_actual',data={x:sum12.x,y:density}
options,'density_actual','ytitle','density!Ccm^-3'


det_time = 60.*20.
det_time_st = strtrim(floor(det_time/60.),2) + ' min'
rbsp_detrend,'density_actual',det_time
rbsp_detrend,['LC1_2I'],60.*5.
rbsp_detrend,['LC2_2I','LC3_2I','LC4_2I'],60.*0.1
options,'density_actual_detrend','ytitle','density detrend!C'+det_time_st+'!C'+'[cm-3]'

;calculate density fluctuation %
get_data,'density_actual',data=da
get_data,'density_actual_detrend',data=dad
den_fluc = 100*dad.y/da.y
store_data,'density_flucper',data={x:da.x,y:den_fluc}
options,'density_flucper','ytitle','dn/n!C(density fluc)!C%'
store_data,'density_flucper_abs',data={x:da.x,y:abs(den_fluc)}
options,'density_flucper_abs','ytitle','|dn/n|!C(density fluc)!C%'
store_data,'density_actual_detrend_abs',data={x:da.x,y:abs(den_fluc)}


;options,'density_proxy_detrend','ytitle','(V1+V2)/2!Cdetrend!C'+det_time_st+'!C'+'[volts]'
options,'LC1_2I','ytitle','Payload 2I!CLC1!Cxxx-xxx keV'
options,'LC2_2I','ytitle','Payload 2I!CLC2!Cxxx-xxx keV'
options,'LC3_2I','ytitle','Payload 2I!CLC3!Cxxx-xxx keV'
options,'LC4_2I','ytitle','Payload 2I!CLC4!Cxxx-xxx keV'

options,'*LC*','colors',50
options,'*density*','colors',230

tplot_options,'title','from jan3_a_hiss_precip_dens.pro'
;tplot,['LC1_2I','LC2_2I','LC3_2I','PeakDet_2I','density_actual','density_actual_detrend_abs','density_flucper_abs','rbspa_fbk2_7pk_5','rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3']
tplot,['LC1_2I_smoothed','LC2_2I_smoothed','LC3_2I_smoothed','density_flucper','rbspa_fbk2_7pk_4']

z_buffer,'~/Desktop/jan3_a_hiss_precip_dens'
