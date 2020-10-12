;Create plots of single combo coherence values.
;see call_plot_single_combo_coherence.pro


pro plot_single_combo_coherence,p1,p2,fn,path,$
  period_fspc_low=pl,period_fspc_high=ph,$
  anglemax=anglemax,tbperiod=tbperiod,$
  yrangespec=yrangespec,$
  mincoh=mincoh,$
  max_mltdiff=max_mltdiff,max_ldiff=max_ldiff,ratiomax=ratiomax,$
  filter_spec=filter_spec

  tplot_options,'title','plot_single_combo_coherence.pro'
  rbsp_efw_init 

  fspcS = 'fspc'
  pre = '2'
  v1 = fspcS + '_'+pre+p1
  v2 = fspcS + '_'+pre+p2

  combo = p1+p2

  tplot_restore,filename=path+fn

  substorms = read_supermag_substorm_list()

  if ~keyword_set(mincoh) then mincoh = 0.7
  if ~keyword_set(pl) then pl = 5.
  if ~keyword_set(ph) then ph = 60.
  if ~keyword_set(max_mltdiff) then max_mltdiff = 12.
  if ~keyword_set(max_ldiff) then max_ldiff=10.
  if ~keyword_set(ratiomax) then ratiomax = 1.2
  if ~keyword_set(anglemax) then anglemax = 40.


;--------------------------------------------
;;Smooth detrend
;  rbsp_detrend,v1,ph
;  rbsp_detrend,v1+'_smoothed',pl
;  rbsp_detrend,v2,ph
;  rbsp_detrend,v2+'_smoothed',pl
;  copy_data,v1+'_smoothed_detrend',v1+'_smoothed_detrend_s1-s2min'
;  copy_data,v2+'_smoothed_detrend',v2+'_smoothed_detrend_s1-s2min'
;  store_data,'fspc_s1-s2min_'+p1+p2,data=[v1+'_smoothed_detrend_s1-s2min',v2+'_smoothed_detrend_s1-s2min']
;  options,'fspc_s1-s2min_'+p1+p2,'colors',[0,250]



  tplot,['coh_'+p1+p2+'_meanfilter','phase_'+p1+p2+'_meanfilter']

  if keyword_set(filter_spec) then begin
    filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','lshell_2'+p1,'lshell_2'+p2,'mlt_2'+p1,'mlt_2'+p2,$
      mincoh,$
      pl,ph,$
      max_mltdiff,$
      max_ldiff,$
      phase_tplotvar='phase_'+p1+p2+'_meanfilter',$
      anglemax=anglemax,$
      /remove_lshell_undefined,$
      /remove_mincoh,$
      /remove_slidingwindow,$
      /remove_max_mltdiff,$
      /remove_max_ldiff,$
      /remove_anglemax,$
      ratiomax=ratiomax
    
    tplot,['coh_'+p1+p2+'_meanfilter','phase_'+p1+p2+'_meanfilter']

  endif




  ;-------------------------------------------------------
  ;create timebar lines corresponding to the period of interest
  ;-------------------------------------------------------

  tbperiod2 = tbperiod * 60.
  get_data,'coh_'+p1+p2+'_meanfilter',data=d,dlim=dlim,lim=lim
  t0 = min(d.x,/nan)
  t1 = max(d.x,/nan)
  ntimes = (t1-t0)/tbperiod2
  tlines = dindgen(ntimes)*tbperiod2 + t0


  ylim,'delta_mlt',0,5
  ylim,'delta_lshell',0,5
  ylim,['coh_'+p1+p2+'_band0','coh_'+p1+p2+'_meanfilter','cohtmp_meanfilter','cohtmp_phasefilteronly','phasetmp_band0'],yrangespec,1
  zlim,['coh_'+p1+p2+'_band0','coh_'+p1+p2+'_meanfilter','cohtmp_meanfilter','cohtmp_phasefilteronly'],0.6,1



  tplot,['fspc_2'+p1,'fspc_2'+p2,'coh_'+p1+p2+'_band0','coh_'+p1+p2+'_meanfilter','cohtmp_phasefilteronly','cohtmp_meanfilter',$
    'average_coherence',$
    'fspc_s1-s2min_'+p1+p2,$
;    'fspc_s1-s2min_'+p2,$
    'delta_mlt','delta_lshell',$
    'mlt_'+pre+p1+'_noonline',$
    'phasetmp_band0']
  timebar,substorms.times

  stop
  tplot & timebar,tlines

end
