;Make A dial plot of total burst minutes per L, MLT sector
;for entire RBSP mission.
;One plot for each cadence

;FU3-RBSPa
;2016-01-21 22:46:18.367340,2016-01-21 22:47:17.142860,5.98154388278364,10.290091318891958,0.1539312771287893,132.51940785756446
;FU3-RBSPb
;2016-01-21 22:46:23.265300,2016-01-21 22:47:17.142860,5.880070277424812,10.290315715398416,0.2263108826296385,78.54373698295173

;FINISHED FILES
;L_MLT_16k_RBSPa_vals


rbsp_efw_init
tplot_options,'title','rbsp_burst1_availability_plots.pro'
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1


d0 = time_double('2012-09-01')
d1 = time_double('2019-11-01')
timespan,d0,d1-d0,/sec

probe = 'b'


;get B2 times
;b2ta = rbsp_get_burst2_times_list('a')
;b2tb = rbsp_get_burst2_times_list('b')

;get B1 times and rates from this routine
b1t = rbsp_get_burst_times_rates_list(probe)

;goo = where((b1t.samplerate gt 15000) and (b1t.samplerate lt 18000))
;goo = where((b1t.samplerate gt 6000) and (b1t.samplerate lt 11000))
;goo = where((b1t.samplerate gt 3500) and (b1t.samplerate lt 5500))
;goo = where((b1t.samplerate gt 1700) and (b1t.samplerate lt 3000))
;goo = where((b1t.samplerate gt 900) and (b1t.samplerate lt 1600))
goo = where((b1t.samplerate gt 0) and (b1t.samplerate lt 800))



;Create a .txt file for each rate with the number of minutes in each L and MLT
;grid value.

structv = goo


;Continue previous run or start a new one?
result = FILE_TEST('~/Desktop/goo5'+probe)
if result then begin $
  restore,filename='~/Desktop/goo5'+probe & $
  ilast = j + 1
endif else ilast=0


for i=ilast,n_elements(structv)-1 do begin


  if i ne 0 then restore,filename='~/Desktop/goo5'+probe


  ;determine whether we have to load 1 or 2 days of survey data.
  startday = strmid(time_string(b1t.startb1[structv[i]]),0,10)
  endday = strmid(time_string(b1t.endb1[structv[i]]),0,10)
  ndays = floor(1 + (time_double(endday) - time_double(startday))/86400)


  ;Determine if we need to load data for a new day
  if ~keyword_set(endday_prev) then endday_prev = endday  ;initial value
  if i ne 0 then begin
    if startday eq endday_prev then loaddat=0 else loaddat=1
    if i eq ilast then loaddat=1
  endif else loaddat=1

  timespan,startday,ndays

;print,startday + '  ' +  endday + '  ' + endday_prev + '  ' + string(loaddat)
;stop

  ;update previous date
  endday_prev = endday


  if loaddat then store_data,tnames(),/del
  if loaddat then rbsp_efw_position_velocity_crib,probe=probe
  ;if i gt 0 then rbsp_efw_position_velocity_crib,probe='a',/no_spice_load

  get_data,'rbsp'+probe+'_state_lshell',data=l
  get_data,'rbsp'+probe+'_state_mlt',data=mlt


  ;find range of L and MLT values
  goodv = where((l.x ge b1t.startb1[structv[i]]) and (l.x le b1t.endb1[structv[i]]))
  lvals = l.y[goodv]
  mltvals = mlt.y[goodv]
;  tvals = l.x[goodv]


  ;Find the number of once/min times burst data exists in each L, MLT grid value
  binL = 1.    ;binsize
  binMLT = 1.
  maxL = 8.
  maxMLT = 24.
  minL = 0.
  minMLT = 0.

  if n_elements(lvals) gt 1 then begin
    h2d_tmp = HIST_2D(lvals, mltvals, bin1=binL, bin2=binMLT, max1=maxL, max2=maxMLT, min1=minL, min2=minMLT)
  endif else begin
    h2d_tmp = lonarr(9,25)
    h2d_tmp[floor(lvals),floor(mltvals)] = 1
  endelse

  if i ne 0 then h2d += h2d_tmp else h2d = h2d_tmp



  j = i
  save,j,h2d,filename='~/Desktop/goo5'+probe



  rbsp_load_spice_kernels,/unload  ;verbose=verbose,unload=unload,all=all,_extra=extra

endfor


;**********************************************
;**********************************************
;**********************************************
;**********************************************
  ;NEED TO UNLOAD SPICE KERNELS HERE
  ;**********************************************
  ;**********************************************
  ;**********************************************
  ;**********************************************



stop

end
