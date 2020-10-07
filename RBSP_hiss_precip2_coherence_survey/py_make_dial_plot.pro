;Take the coherence combo files (e.g. AB.tplot, created from py_create_coh_tplot.pro)
;and plot the coherence values as a dial plot
;This is for a single combo file only. 

;calls extract_timeseries_from_coherence_files()
;      timeseries_reduce_to_pk_and_npk
;      return_L_MLT_grid
;      pertime = percentoccurrence_L_MLT_calculate
;      dial_plot


pro py_make_dial_plot

  print,'In IDL (py_make_dial_plot.pro)'
  rbsp_efw_init

  mincoherence = 0.7  ;reject any value below this
  periodmin = 10.
  periodmax = 60.
  ;periodmin = 2.
  ;periodmax = 20.
  max_mltdiff = 12.
  max_ldiff=10.

  ratiomax = 2.  ;for 2-20 min periods 
  ;ratiomax = 1.05 ;for >20 min periods
  dt = 1*3600./2.  ;time chunk size for dial plot. 
  threshold = 0.0001   ;set low. These have already been filtered.

  folderfilter = 'periods_of_10.00-60.00_min'



  args = command_line_args()
  if keyword_set(args) then begin 
      combos = args[0]
      path = args[1]
  endif else begin 
;    combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']
    combos = ['IT','IW','IK','IL']
    path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014_run1/'
  endelse 








;---------------------------------------------------------
;Sort coherence data by L, MLT for dial plot
;---------------------------------------------------------

  ;---set up grid---
  dlshell = 1
  lmin = 2 & lmax = 20
  dtheta = 2.
  tmin = 0. & tmax = 24.
  grid = return_l_mlt_grid(dtheta,dlshell,lmin,lmax,tmin,tmax)
  ;-----------------

  ts = extract_timeseries_from_coherence_files(combos,path,$
    grid=grid,$
    mincoh=mincoherence,$
    periodrange=[periodmin,periodmax],$
    max_mltdiff=max_mltdiff,max_ldiff=max_ldiff,$
    ratiomax=ratiomax,$
    dt=dt,$
    threshold=threshold,$
    folderfilter=folderfilter)


  ;-------------------------------------
  ;Plot results
  ;-------------------------------------

  dial_plot,ts.peroccavg,ts.totalcounts,grid,minc_vals=0,maxc_vals=0.5,minc_cnt=0,maxc_cnt=100
  stop
  dial_plot,ts.peakavg,ts.totalcounts,grid
  dial_plot,ts.peakmax,ts.totalcounts,grid,minc_vals=0.7,maxc_vals=0.9,minc_cnt=0,maxc_cnt=100
  dial_plot,ts.totalhits,ts.totalcounts,grid


end




;;-----------------------------------------------------------------
;;Make plot of payload separations during times of high correlation
;;-----------------------------------------------------------------

;ylim,['coh_'+combos[i],'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_original'],2,20,1
;
;tplot,['coh_'+combos[i]+'_meanfilter_original','coh_'+combos[i]+'_meanfilter',combos[i]+'_totalcounts_above_threshold',$
;    combos[i]+'_values',$
;    'mlt_2'+p1+'_interp','mlt_2'+p2+'_interp','lshell_2'+p1+'_interp','lshell_2'+p2+'_interp','*flag*']
;
;
;get_data,combos[i]+'_totalcounts_above_threshold',data=tc
;yoo = where(tc.y ne 0.)
;if yoo[0] ne -1 then begin
;  get_data,'mlt_2'+p1+'_interp',data=mlt1
;  get_data,'mlt_2'+p2+'_interp',data=mlt2
;  get_data,'lshell_2'+p1+'_interp',data=lshell1
;  get_data,'lshell_2'+p2+'_interp',data=lshell2
;
;  timestmp = lshell1.x[yoo]
;  mlt1 = mlt1.y[yoo]
;  mlt2 = mlt2.y[yoo]
;  lshell1 = lshell1.y[yoo]
;  lshell2 = lshell2.y[yoo]

;  mlt1_rad = (mlt1/24.)*2*3.14
;  mlt2_rad = (mlt2/24.)*2*3.14


;!p.multi = [0,0,1]
;  plot,[0,0],xrange=[-20,20],yrange=[-20,20],/nodata,/isotropic
;  oplot,Earthx,Earthy
;  polyfill,Earthx,Earthy2
;
;for b=0,n_elements(mlt1)-1 do begin
;
;  lshellF1 = [lshellF1,lshell1[b]]
;  lshellF2 = [lshellF2,lshell2[b]]
;  mltF1 = [mltF1,mlt1_rad[b]]
;  mltF2 = [mltF2,mlt2_rad[b]]

;  xv1 = [xv1,lshell1[b]*sin(mlt1_rad[b])]
;  yv1 = [yv1,-1*lshell1[b]*cos(mlt1_rad[b])]
;  xv2 = [xv2,lshell2[b]*sin(mlt2_rad[b])]
;  yv2 = [yv2,-1*lshell2[b]*cos(mlt2_rad[b])]

;;Plot for each payload combination
;  timebar,timestmp[b]
;  xv1tmp = lshell1[b]*sin(mlt1_rad[b])
;  yv1tmp = -1*lshell1[b]*cos(mlt1_rad[b])
;  xv2tmp = lshell2[b]*sin(mlt2_rad[b])
;  yv2tmp = -1*lshell2[b]*cos(mlt2_rad[b])
;  oplot,[xv1tmp,xv1tmp],[yv1tmp,yv1tmp],psym=-2
;  oplot,[xv2tmp,xv2tmp],[yv2tmp,yv2tmp],psym=-2,color=250
;  oplot,[xv1tmp,xv2tmp],[yv1tmp,yv2tmp]
;
;
;endfor
;endif






; ;Crib sheet for testing timeseries_reduce_to_pk_and_npk.probe

; rbsp_efw_init

; path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014_run1/'
; fn = 'IW.tplot'

; tplot_restore,filenames=path + fn

; get_data,'coh_IW_meanfilter',data=d
; ;get_data,'coh_IW',data=d
; periods = d.v

; ;test at 0.1 Hz
; ;periodtest = 12. ;minutes

; ;-------------------------------------------
; ;Extract timeseries from coherence spectra
; ;-------------------------------------------

; averagev = fltarr(n_elements(d.x))
; peakv = fltarr(n_elements(d.x))

; periodmin = 10. ;min
; periodmax = 60.


; goo = where((d.v ge periodmin) and (d.v le periodmax))

; ;Extract peak coherence value over this period range
; for i=0,n_elements(d.x)-1 do peakv[i] = max(d.y[i,goo],/nan)
; store_data,'IW_peak_test',d.x,peakv

; ;Extract avg coherence of all elements that aren't NaN
; for i=0,n_elements(d.x)-1 do begin $
;     averagev[i] = total(d.y[i,goo],/nan) & $
;     boo = where(finite(d.y[i,goo]) ne 0.) & $
;     if boo[0] ne -1 then averagev[i] /= n_elements(boo)
; ;endfor
; store_data,'IW_average_test',d.x,averagev

; ;tmpp = abs(periods - periodmin)
; ;goo = min(tmpp,wh)
; ;print,periods[wh]
; ;store_data,'IW_test',d.x,d.y[*,wh]
; ;options,'IW_test','psym',-2
; ;tplot,'IW_test'

; dt = 1*3600./2.
; threshold = 0.6
; timeseries_reduce_to_pk_and_npk,'IW_peak_test',dt,threshold

; copy_data,'peakv','IW_peakv'
; copy_data,'totalcounts','IW_totalcounts'
; copy_data,'totalcounts_above_threshold','IW_totalcounts_above_threshold'

; options,'IW_'+['peakv','totalcounts','totalcounts_above_threshold','test'],'psym',-2
; tplot,['IW_peakv','IW_totalcounts','IW_totalcounts_above_threshold','IW_peak_test']


; tinterpol_mxn,'lshell_2I','peakv',newname='lshell_2I_interp'
; tinterpol_mxn,'lshell_2W','peakv',newname='lshell_2W_interp'
; tinterpol_mxn,'mlt_2I','peakv',newname='mlt_2I_interp'
; tinterpol_mxn,'mlt_2W','peakv',newname='mlt_2W_interp'

; ;Find average L and MLT values
; dif_data,'mlt_2I_interp','mlt_2W_interp'
; get_data,'mlt_2I_interp',t1,d1
; get_data,'mlt_2W_interp',t1,d2
; store_data,'2IW_mltavg',t1,(d1+d2)/2.
; get_data,'lshell_2I_interp',t1,d1
; get_data,'lshell_2W_interp',t1,d2
; store_data,'2IW_lshellavg',t1,(d1+d2)/2.


; ylim,['mlt_2I_interp','mlt_2W_interp','2IW_mltavg'],0,24
; tplot,['mlt_2I_interp','mlt_2W_interp','2IW_mltavg']
; tplot,['lshell_2I_interp','lshell_2W_interp','2IW_lshellavg']



;pertime = percentoccurrence_L_MLT_calculate($
;  dt,$
;  'IW_totalcounts_above_threshold',$
;  'IW_peakv',$
;  '2IW_mltavg','2IW_lshellavg',grid=grid)


;values = pertime.percent_peaks
;values = pertime.peaks
;counts = pertime.counts

