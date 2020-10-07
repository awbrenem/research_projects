;Separate out BARREL FSPC (or rcnt) data by filtering to various ULF wave periods. Save as a tplot file.
;See testing from test_determine_active_barrel_times.pro for various filtering methods.
;The old fashioned smooth and detrend seems to be the most consistent.

;called from coh_analysis_driver.py


pro py_filter_barrel_by_ulf_period

  args = command_line_args()
  if keyword_set(args) then begin
    payload = args[0]
    pre = args[1]
    fspc = args[2]
    pmin = float(args[3])
    pmax = float(args[4])
    folder_singlepayload = args[5]
    datapath = args[6]
  endif else begin
    payload = 'i'
    pre = '2'
    fspc = 1
    pmin = 10*60.
    pmax = 60.*60.
    folder_singlepayload = 'folder_singlepayload'
    datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
  endelse



  tsmooth = pmin/2.
  tdetrend = pmax*2.
  pminS = strtrim(floor(pmin/60.),2)
  pmaxS = strtrim(floor(pmax/60.),2)
  payload = strupcase(payload)

  rbsp_efw_init



  if keyword_set(fspc) then pft = 'fspc_' else pft = 'PeakDet_'
  if keyword_set(fspc) then fspc = 1 else fspc = 0
  if fspc then fspc_title = 'fspc' else fspc_title = 'PeakDet'


  ;Load single payload data that has solar flares removed
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + 'barrel_'+pre+payload+'_'+fspc_title+'_fullmission.tplot'
  ;Note: could also load single payload data with load_barrel_data_noartifacts.pro, which removes
  ;data gaps and fills with uncorrelated data. However, for this routine it's probably better to use the 
  ;more unprocessed data. 





  ;BARREL data at this point is at 4 sec cadence (same as L and MLT values).
  ;First apply a low pass filter using digital_filter b/c most of the time the BARREL signal 
  ;is dominated by strong high freq (<1 min) fluctuations
  ;fluctuations. Not sure what this is in general (e.g. Woodger15 Fig5).
  copy_data,pft+pre+payload,pft+pre+payload+'_orig'
  get_data,pft+pre+payload+'_orig',t,d
  boo = sample_rate(t,out_med_avg=srt)
  srt = srt[0]
  nyquist = srt/2.

  hf = (1/pmin) * 4.

  ; Get coefficients:
  nterms = 60.
  frac_nyquist = hf/nyquist/2.
  Coeff = DIGITAL_FILTER(0, frac_nyquist, 50, Nterms)
  Yout = CONVOL(d, Coeff)


  store_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min',t,yout
  ;tplot,[pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min',pft+pre+payload+'_orig']



  ;Now detrend the low pass filtered data
  rbsp_detrend,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min',tdetrend



  ;FFT the remaining data to find where the power is.
  tspanmax = pmax
  npts_min = srt*tspanmax
  npts = 2d
  b=1.
  while npts le npts_min do begin ;$
    npts = 2^b ;& $
    b++
    if npts ge npts_min then npts = 2^b  ;once more
  endwhile

  

  get_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend',ttmp,dtmp
  gap_size = 10*(1/hf)
  nan_gap, ttmp, dtmp, gap_size;, tdim
  store_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_nonans',ttmp,dtmp


  rbsp_spec,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_nonans',npts=npts,n_ave=2,/nan_fill_gaps
  copy_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_nonans_SPEC',pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPEC'

  get_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPEC',data=d
  periods = 1/d.v/60.
  periodmin = 0.1
  goodperiods = where((periods gt periodmin) and (finite(periods) ne 0))
  ;Set NaN values to a really low coherence value
  goo = where(finite(d.y) eq 0)
  if goo[0] ne -1 then d.y[goo] = 0.1
  store_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPECP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.


  options,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPECP','spec',1

  ylim,'*SPECP*',pmin/1.1/60.,pmax*1.1/60.,0
  zrange = [1d1,1d5]
  zlim,'*SPECP*',zrange[0],zrange[1],1





  ;Calculate RMS power for all bins b/t min and max period
  get_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPECP',data=ds
  goodbins = where((ds.v ge pmin/60.) and (ds.v le pmax/60.))
  bandw = abs(ds.v - shift(ds.v,1))

  power = fltarr(n_elements(ds.x))
  for q=0,n_elements(ds.x)-1 do power[q] = total(ds.y[q,goodbins]*bandw[goodbins],/nan)
  ;Remove first two and last two bins for power. These are always spurious
  nelem = n_elements(power)
  power[0:2] = !values.f_nan
  power[nelem-2:nelem-1] = !values.f_nan
  boo = where(power le 1.)  ;should be "zero" 
  if boo[0] ne -1 then power[boo] = !values.f_nan 

  store_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_power',ds.x,power
  ylim,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_power',1d2,1d6,1


  ;Save max power for each bin 
  powermax = fltarr(n_elements(ds.x))
  for q=0,n_elements(ds.x)-1 do powermax[q] = max(ds.y[q,goodbins],/nan)
  goober = where(powermax lt 5.)
  if goober[0] ne -1 then powermax[goober] = !values.f_nan
  store_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_powermax',ds.x,powermax
  ylim,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_powermax',1d2,1d6,1


  ;Some renaming for later clarity
  copy_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min',pft+pre+payload+'_lowpass'
  copy_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend',pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend'
  copy_data,pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_detrend_SPECP',pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend_SPECP'


  ;Variables to save
  tplotvars = [pft+pre+payload+'_lowpass',$
        pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend',$
        pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend_SPECP',$
        pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend_power',$
        pft+pre+payload+'_'+pminS+'-'+pmaxS+'_min'+'_lowpass_detrend_powermax']
 ; tplot,tplotvars




  ;Save tplot variables to file
  periodstr = 'periods_'+strtrim(floor(pmin/60.),2)+'to'+strtrim(floor(pmax/60.),2)+'_min'
  fn = 'barrel_'+pre+payload+'_'+fspc_title + '_power_'+periodstr
  tplot_save,tplotvars,filename=datapath + folder_singlepayload + '/' + fn


end
