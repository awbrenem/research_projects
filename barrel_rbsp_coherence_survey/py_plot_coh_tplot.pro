;Outputs tplot files with the coherence values for every combination
;of BARREL balloons (e.g. AB.tplot). Called from Coh_analysis.py via coh_analysis_driver.py




;***THINGS TO TEST
;Include phase info. Maybe filter out -180 deg stuff?
;**********************


;***NOTES:
;For higher freq waves coherence maybe just means both balloons are embedded into
;a large region with similar period waves. Phase filtering may help here.

;**********************


pro py_plot_coh_tplot,args_manual=args_manual,noplot=noplot

  print,'In IDL (plot_coh_tplot.pro)'
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
;      combo = 'BD'
      combo = 'CT'
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
      combo = 'WK'
      pre = '2'
      fspc = 1
      datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
      folder_plots = 'barrel_missionwide_plots'
      folder_coh = 'coh_vars_barrelmission2v2'
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
  max_mltdiff=12.
  max_ldiff=15.
;  ratiomax=1.2  ;better for 10-60 min periods
  ratiomax=2 ;better for 2-30 min periods




  if fspc then fspcS = 'fspc' else fspcS = 'PeakDet'


  p1 = strmid(combo,0,1)
  p2 = strmid(combo,1,1)

  pmin /= 60.
  pmax /= 60.
  pminS = strtrim(floor(pmin),2)
  pmaxS = strtrim(floor(pmax),2)


  ;load the single payload file
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+p1+'_'+fspcS+'_fullmission.tplot
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+p2+'_'+fspcS+'_fullmission.tplot

  ;load the filtered single payload file
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+p1+'_'+fspcS+'_power_periods_'+pminS+'to'+pmaxS+'_min.tplot'
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+p2+'_'+fspcS+'_power_periods_'+pminS+'to'+pmaxS+'_min.tplot'
  ;NOTE: can also use load_barrel_data_noartifacts here, but in this case it's probably best to use the
  ;version that's as unaltered as possible (i.e. no uncorrelated noise inserted)



  ;Find Lshell and MLT differences b/t balloon payloads
  get_barrel_dl_dmlt_vars,'L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,combo
;  tplot,['dL_'+combo,'dMLT_'+combo,'dMLT_'+combo+'_both','dMLT_'+combo+'_both']



  ;load the coherence tplot variables (unfiltered versions) --> e.g. AB.tplot
  tplot_restore,filenames=datapath + folder_coh + '/' + combo + '.tplot'

  ;load the coherence tplot variables (mean filtered) --> e.g. AB_meanfilter.tplot
  tplot_restore,filenames=datapath + folder_coh + '/' + combo + '_meanfilter.tplot'




;  ;Load distance from plasmapause for each balloon
;  load_barrel_plasmapause_distance,pre+p1
;  load_barrel_plasmapause_distance,pre+p2





  copy_data,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_orig'



    filter_coherence_spectra,'coh_'+p1+p2+'_meanfilter','L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2,$
      mincoh,$
      pmin,pmax,$
      max_mltdiff,$
      max_ldiff,$
      'fspc'+'_'+pre+p1,'fspc'+'_'+pre+p2,$
      phase_tplotvar='phase_'+p1+p2+'_meanfilter',$
      anglemax=anglemax,$
      /remove_lshell_undefined,$
      /remove_mincoh,$
      /remove_slidingwindow,$
      /remove_max_mltdiff,$
      /remove_max_ldiff,$
      /remove_anglemax,$
      /remove_lowsignal_fluctuation,$
      ratiomax=ratiomax

;   tplot,['coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_meanfilter_orig','phase_'+p1+p2+'_meanfilter']



;-----------------------------------------------------------------
;Plot results
;-----------------------------------------------------------------

;Find overlap timerange
get_data,'coh_'+p1+p2+'_meanfilter',tt,dd
Tmin = min(tt,/nan)
Tmax = max(tt,/nan)
timespan,Tmin,(Tmax-Tmin),/seconds


ylim,'dist_pp_'+pre+p1,-5,5
ylim,'dist_pp_'+pre+p2,-5,5
ylim,'coh_'+p1+p2+'_meanfilter',pmin,pmax,0


;A couple of the filtered plots have wacky y-ranges. 
;Set them more carefully here.
get_data,fspcS+'_'+pre+p1+'_lowpass',data=dd 
goo = where(dd.y lt 1d3) 
ylim,fspcS+'_'+pre+p1+'_lowpass',-1*max(dd.y[goo]),max(dd.y[goo])

get_data,fspcS+'_'+pre+p2+'_lowpass',data=dd 
goo = where(dd.y lt 1d3) 
ylim,fspcS+'_'+pre+p2+'_lowpass',-1*max(dd.y[goo]),max(dd.y[goo])

get_data,fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',data=dd 
goo = where(dd.y lt 1d3) 
ylim,fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',-1*max(dd.y[goo]),max(dd.y[goo])

get_data,fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',data=dd 
goo = where(dd.y lt 1d3) 
ylim,fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',-1*max(dd.y[goo]),max(dd.y[goo])


;ylim,'coh_'+p1+p2+'_meanfilter_orig',10,40,0
ylim,['coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter'],1,40,1


if ~keyword_set(noplot) then begin

;  tplot,['coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter','flag_comb',$
;        fspcS+'_'+pre+p1+'_lowpass',fspcS+'_'+pre+p2+'_lowpass',$
;        fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
;        fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
;        'dL_'+p1+p2+'_both','dMLT_'+p1+p2+'_both',$
;        'dist_pp_'+pre+p1+'_comb','dist_pp_'+pre+p2+'_comb']



  popen,'~/Desktop/plot_'+combo+'.ps',/landscape
    !p.charsize = 0.8
    tplot,['coh_'+p1+p2+'_meanfilter_orig','coh_'+p1+p2+'_meanfilter','flag_comb',$
          fspcS+'_'+pre+p1+'_lowpass',fspcS+'_'+pre+p2+'_lowpass',$
          fspcS+'_'+pre+p1+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
          fspcS+'_'+pre+p2+'_'+pminS+'-'+pmaxS+'_min_lowpass_detrend',$
          'dL_'+p1+p2+'_both','dMLT_'+p1+p2+'_both',$
          'dist_pp_'+pre+p1+'_comb','dist_pp_'+pre+p2+'_comb']
  pclose
endif

end
