;pro test_filter_coherence_plots

;Test of various ways to filter the coherence plots to remove random salt/pepper noise. 
;THIS CODE WAS LARGELY PASTED INTO PY_CREATE_COH_TPLOT.PRO


;**********************
;***THINGS THAT WORK
;Median filter - works very well at reducing salt-pepper noise.
;Filling gaps with amplitude-matched incoherent data. 
;**********************
;***THINGS THAT DON'T WORK
;--bpass.pro (Kyle Murphy's suggested code) 
;--Fill gaps with NAN VALUES - Leaves HUGE (day-long) gaps in the larger period spectra. 
;--Fill gaps with zero or some other value. Ends up with large correlation. 
;--Fill gaps with interp_gap - Ends up with large correlation. 
;**********************
;***THINGS TO TEST
;Include phase info. Maybe filter out -180 deg stuff?
;**********************


;***NOTES:
;For higher freq waves coherence maybe just means both balloons are embedded into 
;a large region with similar period waves. 

;**********************


;pro filter_coherence_plots

  print,'In IDL (filter_coherence_plots.pro)'

  rbsp_efw_init

    mincoherence = 0.7  ;reject any value below this
    minbpasscoherence = 0.4  ;similar to coherence, but not quite. For filtering output of bpass.pro
  ;; args = command_line_args()
  ;; combo = args[0]
  ;; pre = args[1]
  ;; fspc = args[2]
  ;; noplot = args[3]              ;output .ps plot of the coherence for each combo


;  combo = 'TX'   
;  combo = 'IW'
;  combo = 'KL'
;  combo = 'IK'
;    combo = 'XL'
;   combo = 'AB'
;    combo = 'WL'
;    combo = 'WK'
    combo = 'KX'

  pre = '2'
  fspc = 1
  noplot = 1


  combo = strupcase(combo)
  fspc = floor(float(fspc))


  if fspc then fspcS = 'fspc' else fspcS = 'PeakDet'

  cormin = 0.4


;Run cross spec for all payload combinations

  p1 = strmid(combo,0,1)
  p2 = strmid(combo,1,1)


;;--------------------------------------------------
;;  Load the data from the barrel_missionwide text files
;;  Turn this into tplot variables here.
;;  These data have had artifacts and SEP events, etc, removed
;;  so that the cross-correlations aren't messed up
;;  This also has solar flare times removed
;;--------------------------------------------------

;Location of files like barrel_AB_coherence_fullmission.txt
  path = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_missionwide/'
;  path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide/'
;  path2 = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide_plots/'


;tplot_restore,filenames=fileroot+'barrel.tplot'

;Location of output plots showing coherence spectra
  path2 = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/plots/barrel_missionwide_plots/'




;Name of single payload files with:  (Time  quality   fspc  lshell  mlt)
  fn1 = 'barrel_'+pre+p1+'_'+fspcS+'_fullmission.txt'
  fn2 = 'barrel_'+pre+p2+'_'+fspcS+'_fullmission.txt'

  v1 = fspcS + '_'+pre+p1
  v2 = fspcS + '_'+pre+p2

  load_barrel_data_noartifacts,path,fn1,fspcS,pre+p1,times=times1
  load_barrel_data_noartifacts,path,fn2,fspcS,pre+p2,times=times2


;----------------------------------------------------------------------------------------
;Before we fill with uncorrelated data, remove the data that has been turned into NaNs 
;due to solar flares. 
;----------------------------------------------------------------------------------------

get_data,v1,data=dd 
goo = where(finite(dd.y) ne 0)
store_data,v1,dd.x[goo],dd.y[goo]

get_data,v2,data=dd 
goo = where(finite(dd.y) ne 0)
store_data,v2,dd.x[goo],dd.y[goo]


;----------------------------------------------------------------------------------------
;Fill all data gaps in the FSPC single-payload data with uncorrelated data
;----------------------------------------------------------------------------------------

gapmin = 4.01
newcadence = 4.0
fill_with_uncorrelated_data,v1,gapmin,newcadence,timesadded_start=trs1,timesadded_end=tre1
fill_with_uncorrelated_data,v2,gapmin,newcadence,timesadded_start=trs2,timesadded_end=tre2

copy_data,v1+'_interp_fixed',v1
copy_data,v2+'_interp_fixed',v2



;----------------------------------------------------------------------------------------
;Find Lshell and MLT differences b/t balloon payloads
;----------------------------------------------------------------------------------------

  mlt_difference_find,'mlt_'+pre+p1,'mlt_'+pre+p2
  dif_data,'lshell_'+pre+p1,'lshell_'+pre+p2,newname='delta_lshell'
  get_data,'delta_lshell',data=goo
  store_data,'delta_lshell',data={x:goo.x,y:abs(goo.y)}
  ylim,'delta_lshell',0,10,0
  ylim,'delta_mlt',0,24
  store_data,'lshellboth',data=['lshell_'+pre+p1,'lshell_'+pre+p2,'delta_lshell']
  store_data,'mltboth',data=['mlt_'+pre+p1,'mlt_'+pre+p2,'delta_mlt']
  options,'lshellboth','colors',[0,50,250]
  options,'mltboth','colors',[0,50,250]
  ylim,'lshellboth',0,10
  ylim,'mltboth',0,24

;create MLT variable that has dashed line at noon 
get_data,'mlt_'+pre+p1,data=d
store_data,'noonline',d.x,replicate(12.,n_elements(d.x))
store_data,'mlt_'+pre+p1+'_noonline',data=['mlt_'+pre+p1,'noonline']
options,'noonline','linestyle',2

tplot,'mlt_'+pre+p1+'_noonline'

;----------------------------------------------------------------------------------------
;Find T1 and T2 based on common times in tplot variables v1 and v2
;----------------------------------------------------------------------------------------
  T1 = times1[0] > times2[0]
  T2 = times1[n_elements(times1)-1] < times2[n_elements(times2)-1]
  timespan,T1,(T2-T1),/seconds



;-----------------------------------------------
;calculate the cross spectra optimized for ULF waves of <2 mHz (Hartinger15 "The global structure")
;2 mHz = 8.333 min
;-----------------------------------------------

  window_minutes = 120.
;NOTE: keep above number higher than what you actually need. This is b/c bpass.pro will eliminate 
;pixels if it doesn't have neighbors (in time and freq)

  window = 120.*window_minutes
  lag = window/16.
;  lag = window/8.
  coherence_time = window*2.5



get_data,v1,data=v1d



  dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
                           new_name='Precip'

  copy_data,'Precip_coherence','coh_'+p1+p2
  get_data,'coh_'+p1+p2,data=d
  periods = 1/d.v/60.
  periodmin = 1.
  goodperiods = where(periods gt periodmin)

    ;Can't have NaN values for bpass to work. Set to a really low coherence value
    goo = where(finite(d.y) eq 0)
    if goo[0] ne -1 then d.y[goo] = 0.1

  store_data,'coh_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
  options,'coh_'+p1+p2,'spec',1
  ylim,['coh_'+p1+p2,'phase_'+p1+p2],5,60,1
  zlim,'coh_'+p1+p2,0.2,0.9,0
  options,'coh_'+p1+p2,'ytitle','Coherence('+p1+p2+')!C[Period (min)]'
  copy_data,'coh_'+p1+p2,'coh_'+p1+p2+'_band0'


  copy_data,'Precip_phase','phase_'+p1+p2
  get_data,'phase_'+p1+p2,data=d
  store_data,'phase_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
  options,'phase_'+p1+p2,'spec',1
  options,'phase_'+p1+p2,'ytitle','Phase('+p1+p2+')!C[Period (min)]'
  copy_data,'phase_'+p1+p2,'phase_'+p1+p2+'_band0'
  ylim,'phase_'+p1+p2+'_band0',5,60,1
  zlim,'phase_'+p1+p2+'_band0',-180,180,0


;-----------------------------------------------
;calculate the cross spectra optimized for ULF waves of 3-30 mHz (Hartinger15 "ULF wave")
;3 mHz = 5.55 min; 30 mHz = 0.555 min
;-----------------------------------------------
sixmin = 0
if sixmin then begin 

  window_minutes = 6.
  window = 60.*window_minutes
  lag = window/16.
;  lag = window/8.
  coherence_time = window*2.5

  dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
                           new_name='Precip'

  copy_data,'Precip_coherence','coh_'+p1+p2
  get_data,'coh_'+p1+p2,data=d
  periods = 1/d.v/60.
  periodmin = 0.5
  goodperiods = where(periods gt periodmin)

    ;Can't have NaN values for bpass.pro 
    goo = where(finite(d.y) eq 0)
    if goo[0] ne -1 then d.y[goo] = 0.1

  store_data,'coh_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
  options,'coh_'+p1+p2,'spec',1
  ylim,'coh_'+p1+p2,0.5,7,1
  zlim,'coh_'+p1+p2,0.2,0.9,0
  options,'coh_'+p1+p2,'ytitle','Coherence('+p1+p2+')!C[Period (min)]'

;  tplot,'coh_'+p1+p2
  copy_data,'coh_'+p1+p2,'coh_'+p1+p2+'_band1'


  copy_data,'Precip_phase','phase_'+p1+p2
  get_data,'phase_'+p1+p2,data=d
  store_data,'phase_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
  options,'phase_'+p1+p2,'spec',1
  options,'phase_'+p1+p2,'ytitle','Phase('+p1+p2+')!C[Period (min)]'
  copy_data,'phase_'+p1+p2,'phase_'+p1+p2+'_band1'
  ylim,'phase_'+p1+p2+'_band1',0.5,7,1
  zlim,'phase_'+p1+p2+'_band1',-180,180,0

endif

;-------------------------------------------------------------------------
;Detrend and smooth the FSPC values for easy comparison to coherence plots
;-------------------------------------------------------------------------

  pl = 5.*60.
  ph = 10.*60.
  rbsp_detrend,v1,ph
  rbsp_detrend,v1+'_smoothed',pl
  rbsp_detrend,v2,ph
  rbsp_detrend,v2+'_smoothed',pl
copy_data,v1+'_smoothed_detrend',v1+'_smoothed_detrend_5-10min'
copy_data,v2+'_smoothed_detrend',v2+'_smoothed_detrend_5-10min'
    store_data,'fspc_5-10min',data=[v1+'_smoothed_detrend_5-10min',v2+'_smoothed_detrend_5-10min']
    options,'fspc_5-10min','colors',[0,250]


;3 mHz = 5.55 min; 30 mHz = 0.555 min
  pl = 10.*60.
  ph = 20.*60.
  rbsp_detrend,v1,ph
  rbsp_detrend,v1+'_smoothed',pl
  rbsp_detrend,v2,ph
  rbsp_detrend,v2+'_smoothed',pl
copy_data,v1+'_smoothed_detrend',v1+'_smoothed_detrend_10-20min'
copy_data,v2+'_smoothed_detrend',v2+'_smoothed_detrend_10-20min'
    store_data,'fspc_10-20min',data=[v1+'_smoothed_detrend_10-20min',v2+'_smoothed_detrend_10-20min']
    options,'fspc_10-20min','colors',[0,250]


  pl = 20.*60.
  ph = 40.*60.
  rbsp_detrend,v1,ph
  rbsp_detrend,v1+'_smoothed',pl
  rbsp_detrend,v2,ph
  rbsp_detrend,v2+'_smoothed',pl
copy_data,v1+'_smoothed_detrend',v1+'_smoothed_detrend_20-40min'
copy_data,v2+'_smoothed_detrend',v2+'_smoothed_detrend_20-40min'
    store_data,'fspc_20-40min',data=[v1+'_smoothed_detrend_20-40min',v2+'_smoothed_detrend_20-40min']
    options,'fspc_20-40min','colors',[0,250]



tplot,['coh_'+p1+p2+'_band0','coh_'+p1+p2+'_band1',$
'fspc_5-10min','fspc_10-20min','fspc_20-40min','delta_mlt','delta_lshell']




;;-----------------------------------
;;~1-5 min

;if sixmin then begin 

;get_data,'coh_'+p1+p2+'_band1',data=dd,dlim=dlim,lim=lim
;get_data,'phase_'+p1+p2+'_band1',data=pp,dlim=dlim2,lim=lim2
;goo = where(dd.y le mincoherence)
;if goo[0] ne -1 then dd.y[goo] = 0.
;if goo[0] ne -1 then pp.y[goo] = !values.f_nan
;store_data,'phase_'+p1+p2+'_band1_v2',data=pp,dlim=dlim2,lim=lim2

;;for plot prettiness
;dd2 = dd
;goo = where(dd.y eq 0.)
;if goo[0] ne -1 then dd2.y[goo] = !values.f_nan
;store_data,'coh_'+p1+p2+'_band1_v2',data=dd2,dlim=dlim,lim=lim

;;Single value of lobject and lnoise for entire array
;lobject = 25.
;lnoise = 5.


;tmpy = bpass(dd.y,lnoise,lobject,/noclip,/field)
;tmpy /= max(tmpy,/nan)
;goo = where(tmpy le minbpasscoherence)
;if goo[0] ne -1 then dd.y[goo] = !values.f_nan
;store_data,'coh_'+p1+p2+'_band1_snremoved',data=dd,dlim=dlim,lim=lim
;options,'coh_'+p1+p2+'_band1_snremoved','spec',1
;zlim,'coh_'+p1+p2+'_band1_snremoved',minbpasscoherence,0.9,0



;;Dynamic value of lobject and lnoise, different for each freq. 
;deltatime = dd.x[2]-dd.x[1]
;nperiods = 3.  ;number of successive periods required for success

;;test run to find array size
;tmpy = bpass(dd.y,lnoise,lobject,/field,/noclip)

;bpassvals = tmpy
;bpassvals[*] = 0.
;minobjectsize = 3  ;at least this many coherent wave periods in a row to qualify as coherence

;for j=0,n_elements(dd.v)-1 do begin ;$
;    lobject = floor((dd.v[j]*60.)*nperiods/deltatime) > minobjectsize ;& $
;    if not lobject mod 2 then  lobject += 1.  ;& $
;    lnoise = lobject/2.  ;& $
;    print,lnoise,lobject  ;& $
;    tmpy = bpass(dd.y[*,j],lnoise,lobject,/field,/noclip)  ;& $
;    tmpy /= max(tmpy,/nan)  ;& $
;    goo = where(tmpy le minbpasscoherence)  ;& $
;    if goo[0] ne -1 then dd.y[goo,j] = !values.f_nan  ;& $
;    bpassvals[*,j] = dd.y[*,j]
;endfor 

;dd.y = bpassvals
;store_data,'coh_singlebands1',data=dd,dlim=dlim,lim=lim

;endif



;----------------------------------------------------------
;Run results through mean_filter to remove salt/pepper noise
;----------------------------------------------------------

get_data,'coh_'+p1+p2+'_band0',data=dd,dlim=dlim,lim=lim
result = mean_filter(dd.y,3,3,/nan)
boo = where(result le mincoherence)
result[boo] = !values.f_nan
store_data,'coh_'+p1+p2+'_meanfilter',dd.x,result,dd.v,dlim=dlim,lim=lim

;Find bandpassed average coherence. 
freqs = where((dd.v ge 10.) and (dd.v le 60.))
totals = fltarr(n_elements(dd.x))
for i=0,n_elements(dd.x)-1 do totals[i] = total(dd.y[i,freqs],/nan)/n_elements(dd.v[freqs])
store_data,'average_coherence',dd.x,totals
ylim,'average_coherence',0.2,0.8


;-----------------------------------------------------------------
;Plot results
;-----------------------------------------------------------------

options,[v1,v2],'psym',0

ylim,['coh_'+p1+p2+'_band0_v2','coh_'+p1+p2+'_band0_snremoved','coh_singlebands0'],10,60,1
options,['coh_'+p1+p2+'_band0_v2','coh_'+p1+p2+'_band0_snremoved','coh_singlebands0'],'ystyle',1
;Plot results
tplot,[v1,v2,'coh_'+p1+p2+'_meanfilter','coh_'+p1+p2+'_band0',$
'fspc_10-20min','fspc_20-40min','delta_mlt','delta_lshell','mlt_'+pre+p1+'_noonline','average_coherence']
;timebar,v1d.x[goov1],color=50
;timebar,v2d.x[goov1],color=250
timebar,[trs1,tre1,trs2,tre2]


stop








tplot,[v1,v2,'coh_'+p1+p2+'_band1_v2','coh_'+p1+p2+'_band1_snremoved','coh_singlebands1',$
'fspc_5-10min','delta_mlt','delta_lshell']
;timebar,v1d.x[goov1],color=50
;timebar,v2d.x[goov1],color=250


stop

tplot,['coh_'+p1+p2+'_band0_v2','phase_'+p1+p2+'_band0_v2',$
'fspc_5-10min','fspc_10-20min','fspc_20-40','delta_mlt','delta_lshell']


;tplot,['coh_'+p1+p2+'_band1_v2','phase_'+p1+p2+'_band1_v2',$
;'fspc_1-5min','fspc_5-50min','fspc_10-50min','delta_mlt','delta_lshell']


stop
end




