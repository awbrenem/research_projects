timespan,'2016-01-20'
timespan,'2015-10-29'
timespan,'2015-10-01'
timespan,'2015-09-30'
timespan,'2015-09-28'
rbsp_efw_init

omni_hro_load,tplotnames=tn


  ;stop
  ;get_data,'OMNI_HRO_1min_BZ_GSM',t,d
  ;store_data,'OMNI_HRO_1min_BZ_GSM',t,d/2.
  ;stop
  tdegap,'OMNI_HRO_1min_SYM_H',/overwrite
  tdeflag,'OMNI_HRO_1min_SYM_H','linear',/overwrite
  tdegap,'OMNI_HRO_1min_BY_GSM',/overwrite
  tdeflag,'OMNI_HRO_1min_BY_GSM','linear',/overwrite
  tdegap,'OMNI_HRO_1min_BZ_GSM',/overwrite
  tdeflag,'OMNI_HRO_1min_Bz_GSM','linear',/overwrite
  tdegap,'OMNI_HRO_1min_proton_density',/overwrite
  tdeflag,'OMNI_HRO_1min_proton_density','linear',/overwrite
  tdegap,'OMNI_HRO_1min_flow_speed',/overwrite
  tdeflag,'OMNI_HRO_1min_flow_speed','linear',/overwrite

  store_data,'omni_imf',data=['OMNI_HRO_1min_BY_GSM','OMNI_HRO_1min_BZ_GSM']

ylim,'OMNI_HRO_1min_SYM_H',-100,0
ylim,'OMNI_HRO_1min_flow_speed',200,500
tplot_options,'title','from sw_omni_plot.pro'
tplot,['OMNI_HRO_1min_BZ_GSM','OMNI_HRO_1min_Pressure','OMNI_HRO_1min_flow_speed',$
  'OMNI_HRO_1min_SYM_H','OMNI_HRO_1min_AE_INDEX']
