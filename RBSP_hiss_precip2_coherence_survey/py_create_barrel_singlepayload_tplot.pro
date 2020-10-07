;Creates an ASCII file for each single payload spanning the entire mission
;that consists of

;; payload = 'A'    (BARREL balloon)
;; dates = ['2014-01-01'....]
;; prefix = '1' or '2' for mission 1 or 2
;; fspc => loads fspc instead of PeakDet data

;Data processing: flare values set to NaN
;Called from Coh_analysis.py via coh_analysis_driver.py
;Calls combine_barrel_data.pro

pro py_create_barrel_singlepayload_tplot

  args = command_line_args()

  if keyword_set(args) then begin
    payload = strupcase(args[0])
    dateS = args[1]
    dateE = args[2]
    prefix = args[3]
    fspc = floor(float(args[4]))
    datapath = args[5]
    folder = args[6]
    tsmooth = args[7]
  endif else begin
    payload = 'I'
    dateS = '2014-01-01'
    dateE = '2014-02-15'
    prefix = '2'
    fspc = 0
    datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
    folder = 'folder_singlepayload'
    tsmooth = 30. ;sec
  endelse


  ;Find start and end dates
  ndays = (time_double(dateE) - time_double(dateS))/86400  + 1
  timespan,dateS,ndays,/days

  ;; find array of dates
  dates = time_string(time_double(dateS) + indgen(ndays)*86400)
  dates = strmid(dates,0,10)


  ;Load FSPC (fast spec) or LC (light curve - rate counter) data
  pre = prefix
  if keyword_set(fspc) then pf = 'fspc_' else pf = 'PeakDet_'
  if keyword_set(fspc) then fspc = 1 else fspc = 0



  ;Combine BARREL peak detector values and ephemeris data for multiple days into a single tplot file.
  combine_barrel_data,pre + payload,dates,fspc=fspc
  get_data,pf+pre+payload,data=dd
;  copy_data,pf+pre+payload,'wv1'

;Remove data during times of solar flare events. These are seen as spikes.
  flares = get_flare_list()

  flares_index = 0.
  for i=0, n_elements(dates)-1 do begin
     goo = where(flares.datetime eq dates[i])
     if goo[0] ne -1 then flares_index = [flares_index, goo]
  endfor

  if n_elements(flares_index) ne 1 then begin
     flares_index = flares_index[1:n_elements(flares_index)-1]

     for k=0, n_elements(flares_index)-1 do begin
        t0 = flares.time[flares_index[k]]
        t1 = t0 + flares.duration[flares_index[k]]
        goo = where((dd.x ge t0) and (dd.x le t1))
        if goo[0] ne -1 then dd.y[goo] = !values.f_nan
     endfor
  endif
  ;Reconstitute the tplot variable with the flare data removed
  store_data,pf+pre+payload,data=dd
 ; copy_data,pf+pre+payload,'wv2'



  ;The FSPC/PeakDet data is on an unnecessarily high cadence for my purposes. Put it
  ;on same cadence as Lshell, MLT (4-sec resolution)
  tinterpol_mxn,pf+pre+payload,'L_Kp2_'+pre+payload,newname=pf+pre+payload
  ;Remove first and last data point, which tend to be way off
  get_data,pf+pre+payload,data=dd
  nelem = n_elements(dd.x)
  store_data,pf+pre+payload,data={x:dd.x[1:nelem-2],y:dd.y[1:nelem-2]}

;  copy_data,pf+pre+payload,'wv3'





  ;Remove the NaN gaps entirely
  get_data,pf+pre+payload,data=dd
  noob = where(finite(dd.x) eq 1.)
  if noob[0] ne -1 then store_data,pf+pre+payload,dd.x[noob],dd.y[noob]

;tplot,[pf+pre+payload,pf+pre+payload+'_tst2']
;  rbsp_detrend,pf+pre+payload+'_tst2',tsmooth




  ;Smooth the FSPC data so that random spikes are removed.
  rbsp_detrend,pf+pre+payload,tsmooth
;tplot,[pf+pre+payload,pf+pre+payload+'_smoothed']
  copy_data,pf+pre+payload+'_smoothed',pf+pre+payload

 ; copy_data,pf+pre+payload,'wv4'
 ; tplot,['wv4',pf+pre+payload+'_tst2','tst']



;Smoothing adds a single data point spike at the edge of NaN boundaries.
;Get rid of these.

  get_data,pf+pre+payload,data=dd
  goob = where(finite(dd.y) eq 0.)

  if goob[0] ne -1 then begin
    for b=0,n_elements(goob)-1 do begin
      dd.y[goob[b]-1] = !values.f_nan
      if goob[b] lt n_elements(dd.x)-1 then dd.y[goob[b]+1] = !values.f_nan
    endfor
  endif

  store_data,pf+pre+payload,data=dd
;  copy_data,pf+pre+payload,'wv5'


;timespan,'2013-01-17',1,/day
;tplot,'wv?'
;stop




  ;save tplot variables
  if fspc then fspc_title = 'fspc' else fspc_title = 'PeakDet'
  fn = 'barrel_'+prefix+payload+'_'+fspc_title+'_fullmission'
  savevars = [pf+pre+payload,'L_Kp?_'+pre+payload,'MLT_Kp?_'+pre+payload,'alt_'+pre+payload]
  tplot_save,savevars,filename=datapath + folder + '/' + fn


end
