
rbsp_efw_init
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission2/'
;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission1/'

;OMNI quantities
timespan,'2014-01-01',50,/days
;timespan,'2013-01-01',50,/days
omni_hro_load


;ARTEMIS quantities
folder_singlepayload2 = 'artemis'
th_sc = 'b'    ;'c'    ;Which ARTEMIS?
datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
file_singlepayload2 = 'thb_ptotQ_values_campaign1.tplot'
;file_singlepayload2 = 'thb_ptotQ_values_campaign2.tplot'
tplotvar = 'th'+th_sc+'_peem_ptotQ'
tplot_restore,filename=datapath + folder_singlepayload2 + '/' + file_singlepayload2


tplot_restore,filenames=path+'all_coherence_plots_combined.tplot'
tplot_restore,filenames=path+'all_coherence_plots_combined_omni_press_dyn.tplot'
tplot_restore,filenames=path+'all_coherence_plots_combined_PeakDet_themis_a_press_dyn.tplot'
copy_data,'coh_allcombos_meanfilter_binary_thb_peem_ptotQ','coh_allcombos_meanfilter_binary_PeakDet_thb_peem_ptotQ'
copy_data,'coh_allcombos_meanfilter_thb_peem_ptotQ','coh_allcombos_meanfilter_PeakDet_thb_peem_ptotQ'
copy_data,'coh_allcombos_meanfilter_normalized_thb_peem_ptotQ','coh_allcombos_meanfilter_normalized_PeakDet_thb_peem_ptotQ'
copy_data,'coh_allcombos_meanfilter_normalized2_thb_peem_ptotQ','coh_allcombos_meanfilter_normalized2_PeakDet_thb_peem_ptotQ'
tplot_restore,filenames=path+'all_coherence_plots_combined_themis_a_press_dyn.tplot'


;zlim,'coh_?_thb_peem_ptotQ_meanfilter',0,0.7
;ylim,'thb_peem_ptotQ',0,400
;tplot,['thb_peem_ptotQ','coh_?_thb_peem_ptotQ_meanfilter','coh_?_PeakDet_thb_peem_ptotQ_meanfilter']





tplot,['coh_allcombos_meanfilter_normalized',$
'thb_peem_ptotQ',$
'coh_allcombos_meanfilter_normalized_thb_peem_ptotQ',$
'coh_allcombos_meanfilter_normalized_PeakDet_thb_peem_ptotQ',$
'OMNI_HRO_1min_Pressure',$
'coh_allcombos_meanfilter_normalized_OMNI_press_dyn']


;'coh_?_thb_peem_ptotQ_meanfilter']
