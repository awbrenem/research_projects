;Outputs tplot files with the coherence values for various combinations of 
;a) single BARREL balloon and 
;b) other quantity (e.g. OMNI dynamic pressure)
;Called from Coh_analysis.py via coh_analysis_driver.py



pro py_plot_coh_tplot_general,args_manual=args_manual,noplot=noplot

  print,'In IDL (plot_coh_tplot_general.pro)'
  rbsp_efw_init

  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1



  if ~is_struct(args_manual) then begin
    args = command_line_args()
    if KEYWORD_SET(args) then begin
      combo = args[0]
      pre = args[1]
      fspc = args[2]
      datapath = args[3]
      folder_plots = args[4]
      folder_coh = args[5]
      folder_singlepayload = args[6]
      pmin = args[7]
      pmax = args[8]
    endif else begin
       combo = 'A_OMNI_press_dyn'
;      combo = 'BD'
;      combo = 'CT'
;      combo = 'GH'
;      combo = 'CK'
;      combo = 'AV'
;      combo = 'QU'
;      combo = 'QT'
;      combo = 'KM'
;      combo = 'IV'
;      combo = 'IU'
;      combo = 'IT'
;      combo = 'IS'
;      combo = 'IR'
;      combo = 'IQ'
;      combo = 'IM'
;      combo = 'WK'
      pre = '2'
      fspc = 1
      datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
      folder_plots = 'barrel_missionwide_plots'
      folder_coh = 'coh_vars_barrelmission2'
      folder_singlepayload = 'folder_singlepayload'
      pmin = 2*60.
      pmax = 40*60.
    endelse
  endif else begin
    combo = args_manual.combo
    pre = args_manual.pre
    fspc = args_manual.fspc
    datapath = args_manual.datapath
    folder_plots = args_manual.folder_plots
    folder_coh = args_manual.folder_coh
    folder_singlepayload = args_manual.folder_singlepayload
    pmin = args_manual.pmin
    pmax = args_manual.pmax
  endelse




  ;Define some filtering variables
  mincoh = 0.7
  threshold = 0.0001   ;set low. These have already been filtered.
;  ratiomax=1.2  ;better for 10-60 min periods
  ratiomax=2 ;better for 2-30 min periods


  if fspc then fspcS = 'fspc' else fspcS = 'PeakDet'


  p1 = strmid(combo,0,1)
  p2 = strmid(combo,2)

  pmin /= 60.
  pmax /= 60.
  pminS = strtrim(floor(pmin),2)
  pmaxS = strtrim(floor(pmax),2)




  ;load the coherence tplot variables (unfiltered versions) --> e.g. AB.tplot
  tplot_restore,filenames=datapath + folder_coh + '/' + combo + '.tplot'

  ;load the coherence tplot variables (mean filtered) --> e.g. AB_meanfilter.tplot
  tplot_restore,filenames=datapath + folder_coh + '/' + combo + '_meanfilter.tplot'




  copy_data,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_orig'

  get_data,'coh_'+p1+'_'+p2+'_meanfilter',data=d
  store_data,'Ldummy1',d.x,replicate(1.,n_elements(d.x))
  store_data,'Ldummy2',d.x,replicate(1.,n_elements(d.x))
  store_data,'MLTdummy1',d.x,replicate(1.,n_elements(d.x))
  store_data,'MLTdummy2',d.x,replicate(1.,n_elements(d.x))
  store_data,'fspcdummy1',d.x,replicate(1.,n_elements(d.x))
  store_data,'fspcdummy2',d.x,replicate(1.,n_elements(d.x))

;  max_mltdiff = 1000.
;  max_ldiff = 1000.
;  anglemax = 1000.
;stop


    filter_coherence_spectra,'coh_'+p1+'_'+p2+'_meanfilter','Ldummy1','Ldummy2','MLTdummy1','MLTdummy2',$
      mincoh,$
      pmin,pmax,$
      max_mltdiff,$
      max_ldiff,$
      'fspc'+'_'+pre+p1,'fspc'+'_'+pre+p2,$
      /remove_mincoh,$
      /remove_slidingwindow,$
      ratiomax=ratiomax

;   tplot,['coh_'+p1+'_'+p2+'_meanfilter','coh_'+p1+'_'+p2+'_meanfilter_orig','phase_'+p1+'+'+p2+'_meanfilter']



;-----------------------------------------------------------------
;Plot results
;-----------------------------------------------------------------

;Find overlap timerange
get_data,'coh_'+p1+'_'+p2+'_meanfilter',tt,dd
Tmin = min(tt,/nan)
Tmax = max(tt,/nan)
timespan,Tmin,(Tmax-Tmin),/seconds


;ylim,'coh_'+p1+'_'+p2+'_meanfilter',pmin,pmax,0


ylim,['coh_'+p1+'_'+p2+'_meanfilter_orig','coh_'+p1+'_'+p2+'_meanfilter'],pmin,pmax,1


if ~keyword_set(noplot) then begin

;  tplot,['coh_'+p1+'_'+p2+'_meanfilter_orig','coh_'+p1+'_'+p2+'_meanfilter','flag_comb']


  popen,'~/Desktop/plot_'+combo+'.ps',/landscape
    !p.charsize = 0.8
    tplot,['coh_'+p1+'_'+p2+'_meanfilter_orig','coh_'+p1+'_'+p2+'_meanfilter','flag_comb']
          ;fspcS+'_'+pre+p1+'_lowpass',fspcS+'_'+pre+p2+'_lowpass',$
          ;fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
          ;fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
          ;'dL_'+p1+p2+'_both','dMLT_'+p1+p2+'_both',$
          ;'dist_pp_'+pre+p1+'_comb','dist_pp_'+pre+p2+'_comb']
  pclose
endif

end
