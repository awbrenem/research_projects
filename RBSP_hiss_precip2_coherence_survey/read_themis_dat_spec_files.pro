;Read THEMIS data files which I make by exporting Autoplot data into .dat format.
;Need to do this b/c cdf2tplot won't load anything from THEMIS CDF files.
;As an example, the cdf file tha_l2_fbk_20140110_v01.cdf won't plot.
;So, load this up in Autoplot and "export data" the channels you want.


;Creates a tplot variable with the data

;e.g.
;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'
;fn = 'tha_l2_fbk_spec_20140110_edc12.dat'
;read_themis_dat_spec_files,ptmp+fn,tvarname='tha_l2_fbk_spec_edc12'

;****FREQ BINS ARE HARDCODED HERE. NEED TO CHECK TO SEE IF THEY ARE
;****CORRECT B/C THEY MAY DIFFER BY FILE.


pro read_themis_dat_spec_files,file,tvarname=tvn

  if ~KEYWORD_SET(tvn) then tvn = 'themis_tplot_variable'

  ;ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan10/'
  ;fn = 'tha_l2_fbk_spec_20140110_edc12.dat'
  ;fn = 'tha_l2_fbk_spec_20140110_scm1.dat'

  fbins = [2689.0, 572.0, 144.20, 36.200, 9.05, 2.26] ;Hz


stop
  openr,lun,file,/get_lun

  jnk = ''
  for i=0,4 do readf,lun,jnk

  t = 0d
  v = replicate(0.,6.)

  while not eof(lun) do begin $
    readf,lun,jnk & $
    vals = strsplit(jnk,',',/extract) & $
    t = [t,time_double(vals[0])] & $
    tmp = vals[1:5] & $
    v = [[v],[vals[1:6]]]
  endwhile

  close,lun & free_lun,lun


  nelem = n_elements(t)
  t = t[1:nelem-1]
  v = transpose(v[*,1:nelem-1])

  store_data,tvn,data={x:t,y:v,v:fbins}
;  split_vec,tvn

  options,tvn,'spec',1
  ylim,tvn,1,3000,1
  zlim,tvn,0.1,100,1


end
