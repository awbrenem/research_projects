
;Jan 3rd A hiss/modulation/density plot
;First run daily_barrel_conjunctions.pro
;Run w/ peak detector and normal LC


;No E12 FBK signal
;50Hz - 1.6 kHz FBK Bw signal

;zoomed in

rbsp_split_fbk,probe,/combine

;t0 = '2014-01-06/20:30'
;t1 = '2014-01-06/21:30'
t0 = '2014-01-06/20:53'
t1 = '2014-01-06/21:00'
tlimit,t0,t1

ylim,['rbspa_fbk2_7comb_5','rbspa_fbk2_7comb_4','rbspa_fbk2_7comb_3'],0,30
ylim,'density_proxy',0,0
ylim,'PeakDet_2K',4d3,1.2d4
options,'*comb*','panel_size',1


get_data,'density_proxy',data=sum12
density = 7583.26*exp(sum12.y/0.38)+94.62*exp(sum12.y/2.3)
store_data,'density_actual',data={x:sum12.x,y:density}
options,'density_actual','ytitle','density!Ccm^-3'


det_time = 60.*20.
det_time_st = strtrim(floor(det_time/60.),2) + ' min'
rbsp_detrend,'density_actual',det_time
rbsp_detrend,['LC1_2K'],60.*5.
rbsp_detrend,['LC2_2K','LC3_2K','LC4_2K'],60.*0.1
options,'density_actual_detrend','ytitle','density detrend!C'+det_time_st+'!C'+'[cm-3]'

;calculate density fluctuation %
get_data,'density_actual',data=da
get_data,'density_actual_detrend',data=dad
den_fluc = 100*dad.y/da.y
store_data,'density_flucper',data={x:da.x,y:den_fluc}
options,'density_flucper','ytitle','dn/n!C(density fluc)!C%'

;options,'density_proxy_detrend','ytitle','(V1+V2)/2!Cdetrend!C'+det_time_st+'!C'+'[volts]'
options,'LC1_2K','ytitle','Payload 2K!CLC1!Cxxx-xxx keV'
options,'LC2_2K','ytitle','Payload 2K!CLC2!Cxxx-xxx keV'
options,'LC3_2K','ytitle','Payload 2K!CLC3!Cxxx-xxx keV'
options,'LC4_2K','ytitle','Payload 2K!CLC4!Cxxx-xxx keV'

ylim,'PeakDet_2K',3000,6d3
ylim,'rbspa_fbk2_7comb_5',0,5
ylim,'rbspa_fbk2_7comb_4',0,20
ylim,'rbspa_fbk2_7comb_3',0,60
;ylim,'density_actual',300,400
ylim,'density_actual',200,600
zlim,'rbspa_efw_64_spec0',1d-5,1d0
ylim,'rbspa_efw_64_spec0',10,1000,1
tplot_options,'title','from jan6_a_hiss_precip_dens.pro'
tplot,['LC1_2K','LC2_2K','LC3_2K','PeakDet_2K','density_actual','density_flucper','rbspa_fbk2_7comb_4','rbspa_fbk2_7comb_3','rbspa_efw_64_spec0']

;tplot,['LC1_2K_smoothed','LC2_2K_smoothed','LC3_2K_smoothed','LC4_2K_smoothed','PeakDet_2K','density_proxy','density_proxy_detrend','rbspa_fbk2_7comb_5','rbspa_fbk2_7comb_4','rbspa_fbk2_7comb_3']
;tplot,[107,108,109,110]


z_buffer,'~/Desktop/jan3_a_hiss_precip_dens'
