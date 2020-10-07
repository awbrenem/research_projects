

;Read THEMIS mag data files which I make by exporting Autoplot data into .dat format.
;Need to do this b/c cdf2tplot won't load anything from THEMIS CDF files.


;Creates a tplot variable with the data

;e.g.
;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'
;fn = 'tha_l2_fgm_20140110_v01.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fgm'

;****FREQ BINS ARE HARDCODED HERE. NEED TO CHECK TO SEE IF THEY ARE
;****CORRECT B/C THEY MAY DIFFER BY FILE.


pro read_themis_dat_mag_files,file,tvarname=tvn



  if ~KEYWORD_SET(tvn) then tvn = 'themis_tplot_variable'


  openr,lun,file,/get_lun

  jnk = ''
  for i=0,4 do readf,lun,jnk

  t = 0d
  v = 0.

  while not eof(lun) do begin $
    readf,lun,jnk & $
    vals = strsplit(jnk,',',/extract) & $
    t = [t,time_double(vals[0])] & $
    tmp = vals[1] & $
    v = [[v],[vals[1]]]
  endwhile

  close,lun & free_lun,lun


  nelem = n_elements(t)
  t = t[1:nelem-1]
  v = v[1:nelem-1]

  store_data,tvn,data={x:t,y:v}
;  split_vec,tvn


end
