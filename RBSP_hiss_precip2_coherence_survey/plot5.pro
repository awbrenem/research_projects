
;Create plot 5 (coherence survey) for the BARREL paper

tplot_restore,filename='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission1/all_coherence_plots_combined_themis_a_press_dyn.tplot'

timespan,'2013-01-13',25,/days
kyoto_load_ae
kyoto_load_dst
omni_load_data

copy_data,'kyoto_ae','kyoto_ae1'
copy_data,'kyoto_dst','kyoto_dst1'
copy_data,'OMNI_HRO_1min_Pressure','OMNI_HRO_1min_Pressure1'
copy_data,'coh_allcombos_meanfilter_normalized_thb_peem_ptotQ','coh1'

rbsp_detrend,'OMNI_HRO_1min_Pressure1',60.*80.


ylim,'coh_allcombos*',0,60,0
zlim,'coh_allcombos*',0,0.6
ylim,'coh1',0,60,0
zlim,'coh1',0,0.4
;ylim,'OMNI_HRO_1min_Pressure1',0,20
ylim,'OMNI_HRO_1min_Pressure1',0.8,20,1
ylim,'kyoto_dst1',-60,40
ylim,'kyoto_ae1',0,1000

tplot,['kyoto_ae1','kyoto_dst1','OMNI_HRO_1min_Pressure1','OMNI_HRO_1min_Pressure1_detrend','coh1']



;*************
tplot_restore,filename='/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission2/all_coherence_plots_combined_themis_a_press_dyn.tplot'

timespan,'2014-01-03',12,/days
kyoto_load_ae
kyoto_load_dst
omni_load_data

copy_data,'kyoto_ae','kyoto_ae2'
copy_data,'kyoto_dst','kyoto_dst2'
copy_data,'OMNI_HRO_1min_Pressure','OMNI_HRO_1min_Pressure2'
copy_data,'coh_allcombos_meanfilter_normalized_thb_peem_ptotQ','coh2'

rbsp_detrend,'OMNI_HRO_1min_Pressure2',3600.

ylim,'coh_allcombos*',0,60,0
zlim,'coh_allcombos*',0,0.6
ylim,'coh2',0,60,0
zlim,'coh2',0,0.4
;ylim,'OMNI_HRO_1min_Pressure2',0,5
ylim,'OMNI_HRO_1min_Pressure2',0.4,8,1
ylim,'kyoto_dst2',-60,40
ylim,'kyoto_ae2',0,1000

tplot,['kyoto_ae2','kyoto_dst2','OMNI_HRO_1min_Pressure2','coh2']



