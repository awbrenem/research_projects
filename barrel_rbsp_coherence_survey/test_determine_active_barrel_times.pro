;Test three different methods to determine how much ULF activity BARREL balloons are seeing. 

;METHOD 1: vector_bandpass. Often leaves an artificial low freq signal, particularly when trying to filter to keep longer 
;			wave periods. Impulses can also cause this low freq signal. DON'T USE!!! 
;METHOD 2: Instead of detrending, subtract a highly smoothed version of background trend, leaving only fluctuations
;Usually works well. Can invert the signal. Susceptible to end effects
;METHOD 3: Regular old smooth and detrend. Usually works well. 




rbsp_efw_init

payload = 'I'
dateS = '2014-01-06'
dateE = '2014-01-10'
prefix = '2'
fspc = 1

  ;Find start and end dates
  ndays = (time_double(dateE) - time_double(dateS))/86400  + 1
  timespan,dateS,ndays,/days

  ;; find array of dates
  dates = time_string(time_double(dateS) + indgen(ndays)*86400)
  dates = strmid(dates,0,10)



  pre = prefix
  if keyword_set(fspc) then pf = 'LC12_' else pf = 'PeakDet_'
  if keyword_set(fspc) then fspc = 1 else fspc = 0

  if fspc then fspc_title = 'fspc' else fspc_title = 'PeakDet'
  fn = 'barrel_'+prefix+payload+'_'+fspc_title+'_fullmission.txt'


  ;Combine BARREL peak detector values and ephemeris data for multiple days into a single tplot file.
  combine_barrel_data,pre + payload,dates,fspc=fspc



;-----------------------------------------
;min and max periods to evaluate
pmin = 20*60.   
pmax = 25.*60.
tsmooth = pmin/2.
tdetrend = pmax*2. 

;--------------------------------
;smooth out the high freq noise. This essentially always dominates the DC-detrended fluctuations
;copy_data,'LC12_2I','LC12_2I_orig'
;rbsp_detrend,'LC12_2I', 5.
;copy_data,'LC12_2I_smoothed','LC12_2I'
;store_data,'LC12_2I_smoothed',/delete

;Hard cutoff of high freq noise. (NOTE THAT THIS REMOVES THE DC OFFSET)
copy_data,'LC12_2I','LC12_2I_orig'
get_data,'LC12_2I_orig',t,d
srt = 1/(t[1]-t[0])

lf = 0.
hf = 1/pmin    * 4.
dat = [[d],[d],[d]]
x = vector_bandpass(dat,srt,lf,hf)
store_data,'LC12_2I',t,x[*,0]
;tplot,['LC12_2I','LC12_2I_orig']
;stop
;--------------------------------


;--------------------------------
;METHOD 1 (DON'T USE)
;Vector Bandpass method
lf = 1/pmax    / 2.
hf = 1/pmin    * 2.
dat = [[d],[d],[d]]
x = vector_bandpass(dat,srt,lf,hf)
store_data,'LC12_2I_vbp',t,x[*,0]
;--------------------------------
;METHOD 2
;Instead of detrending, subtract a highly smoothed version of background trend, leaving only fluctuations
rbsp_detrend,'LC12_2I',2*pmax
copy_data,'LC12_2I_smoothed','LC12_2I_bkg'
rbsp_detrend,'LC12_2I',tsmooth
tplot,['LC12_2I_bkg','LC12_2I']

dif_data,'LC12_2I_bkg','LC12_2I_smoothed',newname='LC12_2I_diff'
;----------------------------------
;METHOD 3
;Regular old smooth and detrend
rbsp_detrend,'LC12_2I_smoothed',tdetrend
;----------------------------------
;--------------------------------
;;METHOD 4
;;Vector Bandpass ONLY high freqs, detrend away low freqs. 
;lf = 0.
;hf = 1/pmin    * 2.
;dat = [[d],[d],[d]]
;x = vector_bandpass(dat,srt,lf,hf)
;store_data,'LC12_2I_vbp2',t,x[*,0]
;rbsp_detrend,'LC12_2I_vbp2',tdetrend



;Test how well the three methods are working compared to the original (unfiltered) data detrended
;to remove > 1 hr variation
rbsp_detrend,'LC12_2I',3600.
rbsp_detrend,'LC12_2I_orig',3600.
options,'LC12_2I_orig_detrend','color',50


store_data,'combtest_vbp',data=['LC12_2I_detrend','LC12_2I_vbp']
store_data,'combtest_diff',data=['LC12_2I_detrend','LC12_2I_diff']
store_data,'combtest_rdet',data=['LC12_2I_detrend','LC12_2I_smoothed_detrend']
store_data,'combtest_vbp2',data=['LC12_2I_detrend','LC12_2I_vbp2_detrend']

options,'combtest_*','colors',[0,250]

options,['LC12_2I_vbp','LC12_2I_diff','LC12_2I_smoothed_detrend','LC12_2I_vbp2_detrend'],'color',250


stop
;Method 1 test
tplot,['LC12_2I_orig_detrend',$  ;Original data w/ high freq noise, detrended
		'combtest_vbp',$   ;Original data w/o high freq noise, detrended, compared to Vector Bandpassed version
		'LC12_2I_detrend',$ ;Original data w/o high freq noise, detrended
		'LC12_2I_vbp']    ;Vector bandpass version

;Method 2 test
tplot,['LC12_2I_orig_detrend',$  ;Original data w/ high freq noise, detrended
		'combtest_diff',$ ;Original data w/o high freq noise, detrended, compared to rbsp_detrend version
		'LC12_2I_detrend',$ ;Original data w/o high freq noise, detrended
		'LC12_2I_diff'] ;rbsp_detrend version

;Method 3 test
tplot,['LC12_2I_orig_detrend',$  ;Original data w/ high freq noise, detrended
		'combtest_rdet',$ ;Original data w/o high freq noise, detrended, compared to rbsp_detrend version
		'LC12_2I_detrend',$ ;Original data w/o high freq noise, detrended
		'LC12_2I_smoothed_detrend'] ;rbsp_detrend version

;;;Method 4 test
;;tplot,['LC12_2I_orig_detrend',$  ;Original data w/ high freq noise, detrended
;;		'combtest_vbp2',$ ;Original data w/o high freq noise, detrended, compared to rbsp_detrend version
;;		'LC12_2I_detrend',$ ;Original data w/o high freq noise, detrended
;;		'LC12_2I_vbp2_detrend'] ;rbsp_detrend version




;Method intercomparison
ylim, ['LC12_2I_vbp','LC12_2I_diff','LC12_2I_smoothed_detrend'],-10,10
tplot,['LC12_2I_vbp','LC12_2I_diff','LC12_2I_smoothed_detrend']


;Notes on the various methods
;Method 1
;-bad for longer periods (like 10-30 min) b/c there's a clear ringing tone near the end 
;	of data set 

;Method 2 
;-leaves lots of high freq noise in. 






ylim,['LC12_2I','LC12_2I_smoothed'],0,300
ylim,'LC12_2I_smoothed_detrend',-5,5
;----------------------------

;tplot,['LC12_2I','LC12_2I_smoothed','LC12_2I_diff','LC12_2I_diff_smoothed'];,'LC12_2I_smoothed_detrend']



;FFT the remaining data to find where the power is. 

tspanmax = pmax 
npts_min = srt*tspanmax
npts = 2d
i=1.
while npts le npts_min do begin ;$
npts = 2^i ;& $
i++ 
;if npts ge npts_min then npts = 2^i  ;once more
endwhile

rbsp_spec,'LC12_2I_vbp',npts=npts,n_ave=2,/nan_fill_gaps
rbsp_spec,'LC12_2I_diff',npts=npts,n_ave=2,/nan_fill_gaps
rbsp_spec,'LC12_2I_smoothed_detrend',npts=npts,n_ave=2,/nan_fill_gaps
;rbsp_spec,'LC12_2I_vbp2_detrend',npts=npts,n_ave=2,/nan_fill_gaps


stop


  get_data,'LC12_2I_diff_SPEC',data=d
  periods = 1/d.v/60.
  periodmin = 0.1
  goodperiods = where(periods gt periodmin)
  ;Set NaN values to a really low coherence value
  goo = where(finite(d.y) eq 0)
  if goo[0] ne -1 then d.y[goo] = 0.1
  store_data,'LC12_2I_diff_SPECP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.


  get_data,'LC12_2I_vbp_SPEC',data=d
  periods = 1/d.v/60.
  periodmin = 0.1
  goodperiods = where(periods gt periodmin)
  ;Set NaN values to a really low coherence value
  goo = where(finite(d.y) eq 0)
  if goo[0] ne -1 then d.y[goo] = 0.1
  store_data,'LC12_2I_vbp_SPECP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.

  get_data,'LC12_2I_smoothed_detrend_SPEC',data=d
  periods = 1/d.v/60.
  periodmin = 0.1
  goodperiods = where(periods gt periodmin)
  ;Set NaN values to a really low coherence value
  goo = where(finite(d.y) eq 0)
  if goo[0] ne -1 then d.y[goo] = 0.1
  store_data,'LC12_2I_smoothed_detrend_SPECP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.


;  get_data,'LC12_2I_vbp2_detrend_SPEC',data=d
;  periods = 1/d.v/60.
;  periodmin = 0.1
;  goodperiods = where(periods gt periodmin)
;  ;Set NaN values to a really low coherence value
;  goo = where(finite(d.y) eq 0)
;  if goo[0] ne -1 then d.y[goo] = 0.1
;  store_data,'LC12_2I_vbp2_detrend_SPECP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.

options,['LC12_2I_vbp','LC12_2I_diff','LC12_2I_smoothed_detrend'] + '_SPECP','spec',1



ylim,'LC12_2I_diff_smoothed',-1,1
ylim,'*SPECP*',pmin/1.2/60.,pmax*1.2/60.,0
;zlim,'LC12_2I_diff_SPECP',0.001,10,1  ;1-2 min
zlim,'*SPECP*',0.01,100,1
;tplot,['LC12_2I_smoothed','LC12_2I_diff_smoothed','LC12_2I_diff_SPECP','LC12_2I_vbp','LC12_2I_vbp_SPECP']


tplot,['LC12_2I_vbp','LC12_2I_diff','LC12_2I_smoothed_detrend'] + '_SPECP'


;'LC12_2I_smoothed_detrend'
stop

end

;------------------------------------------
;------------------------------------------
;------------------------------------------
;------------------------------------------














;get_data,'LC12_2I_diff',t,d

;store_data,'*wavelet*',/delete
;ttmp = t;[0:10*170000]
;dtmp = d;[0:10*170000]
;wavelet_to_tplot,ttmp,dtmp,dscale=4*0.125



;;  copy_data,'Precip_coherence','coh_'+p1+p2
 ; get_data,'wavelet_power_spec',data=d
 ; periods = 1/d.v/60.
 ; periodmin = 0.5
 ; goodperiods = where(periods gt periodmin)

 ; ;Set NaN values to a really low coherence value
 ; goo = where(finite(d.y) eq 0)
 ; if goo[0] ne -1 then d.y[goo] = 0.1

;  store_data,'wavelet_power_specP',d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
;  options,'wavelet_power_specP','spec',1
;ylim,'wavelet_power_specP',0.5,60,1
;zlim,'wavelet_power_specP',10,10000,1

;tplot,['wavelet_power_specP','LC12_2I_diff_smoothed','LC12_2I','GPS_Lat']


;  ylim,['coh_'+p1+p2,'phase_'+p1+p2],5,60,1
;  zlim,'coh_'+p1+p2,0.2,0.9,0
;  options,'coh_'+p1+p2,'ytitle','Coherence('+p1+p2+')!C[Period (min)]'
;  copy_data,'coh_'+p1+p2,'coh_'+p1+p2+'_band0'



;zlim,'wavelet_power_spec',1d0,1d3,1
;tplot,['wavelet_power_spec','LC12_2I_diff_smoothed']

;PRO wavelet_to_tplot,tt,dd,ORDER=order,DSCALE=dscale,NSCALE=nscale,START_SCALE=sscale,$
;                           NEW_NAME=new_name,KILL_CONE=kill_cone,SIGNIF=signif,       $
;                           PERIOD=period,FFT_THEOR=fft_theor,MOTHER=mother,           $
;                           SCALES=scales,CONE=cone,CONF_95LEV=conf_95lev

