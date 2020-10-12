;Segment the BARREL mission 2 into different parts based on activity level, precipitation level, 
;coherence level, etc... 

;This is in an attempt to discover why coherence is observed at certain times and not others. 

tplot_options,'title','plot_identify_barrel_mission2_domains.pro'
rbsp_efw_init
timespan,'2014-01-01',45,/days

kyoto_load_ae

rbsp_detrend,'kyoto_ae',3600.*4.

tplot,'kyoto_ae_smoothed'



payloads = strupcase(['i','t','w','k','l','x','a','b','e','o','p'])

      pre = '2'
      fspcs = 'fspc'
      datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
      folder_singlepayload = 'folder_singlepayload'
      folder_coh = 'coh_vars_barrelmission2'

for i=0,n_elements(payloads)-1 do tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+payloads[i]+'_'+fspcS+'_fullmission.tplot
tplot_restore,filenames=datapath + folder_coh + '/' + 'all_coherence_plots_combined_meanfilter.tplot'
;tplot_restore,filenames=datapath + folder_coh + '/' + 'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'



  rbsp_detrend,'*fspc_*',3600.



    times_precip = '2014-' + ['01-01/00:00','01-15/00:00','02-06/00:00','02-13/00:00']

  ylim,'*fspc_2?_smoothed',30,80
  tplot,['coh_allcombos_meanfilter','*fspc_2?_smoothed']
  timebar,times_precip


