;;Calculate the coherence spectra with artificial timeshifts. This
;;will be used to estimate the timeshift of max coherence, which
;;hopefully is the correct timeshift for the FB data



;;ad hoc time correction for the FB4 data on Jan 20th at ~19:40
;;According to Alex this should be around 4.1 sec
;    times = time_double(times) + 4.1


;Add all the FB4 channels to get better signal.
;Change to binary to reduce noise.



pro jan20_chorus_microburst_coherence ;,sc,fb,date,no_spice_load=no_spice_load

  sc = 'a'
  date = '2016-01-20'
  timespan,date
  fb = '4'


  t0 = date + '/19:43'
  t1 = date + '/19:45:30'

;  rbsp_load_efw_fbk,probe=sc,type='calibrated',/pt
;;  rbsp_load_efw_spec,probe=sc,type='calibrated'
;  rbsp_split_fbk,'a'

rbsp_efw_init


;  path = '/Users/aaronbreneman/Desktop/Research/OTHER/meetings/2016-Aerospace/'
;  fn = 'FU_4_Hires_2016-01-20_L1_v02.txt'

  fileroot = '~/Desktop/Research/RBSP_FIREBIRD_microburst_conjunction_jan20/IDL/'
  tplot_restore,filenames=fileroot+'aaron_fb4_rbspa.tplot'

  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk'],0,3000,0
  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']




  ;-------------------------------------------------
  ;Create binary variables for correlation analysis
  ;-------------------------------------------------

  ;combine all FB4 quantities for better signal-noise
  get_data,'hr0_0',tt,h0
  get_data,'hr0_1',tt,h1
  get_data,'hr0_2',tt,h2
  get_data,'hr0_3',tt,h3
  get_data,'hr0_4',tt,h4
  get_data,'hr0_5',tt,h5

  store_data,'hr0_T',tt,h0+h1+h2+h3+h4+h5
  tplot,'hr0_T'

  tinterpol_mxn,'hr0_T','rbspa_fbk2_7pk_5',newname='hr0_T'

  rbsp_detrend,'hr0_T',2.

  get_data,'hr0_T_detrend',tt,uu

  goo = where(uu ge 50.)
  new = replicate(0.,n_elements(uu))
  new[goo] = 1.
  store_data,'hr0_T_bin',tt,new
  ylim,'hr0_T_bin',0,2
  tplot,['hr0_T','hr0_T_detrend','hr0_T_bin']




  goo = where((vtt le 0) or (vtt gt 500))
  vtt[goo] = !values.f_nan
  store_data,'hr0_0',times,vtt
  rbsp_detrend,'hr0_0',0.1
    tplot,['hr0_0_detrend','rbspa_fbk2_7pk_5']

  stop


;  openr,lun,path+fn,/get_lun
;
;  jnk = ''
;  for i=0,107 do readf,lun,jnk
;
;  data = strarr(90000,27)
;  i=0L
;
;  while not eof(lun) do begin           ;$
;     readf,lun,jnk                      ;& $
;     data[i,*] = strsplit(jnk,/extract) ;& $
;     i++
;  endwhile

  ;; while not eof(lun) do begin  $
  ;;    readf,lun,jnk   & $
  ;;    data[i,*] = strsplit(jnk,/extract)  & $
  ;;    i++

;  close,lun
;  free_lun,lun
;  times = data[*,0]
;  goo = where(times eq '')
;  vtt = goo[0]-1
;  times = time_double(times[0:vtt])


;  store_data,'hr0_0',data={x:times,y:float(data[0:vtt,11])}


  t0 = time_double('2016-01-20/19:42:15')
  t1 = time_double('2016-01-20/19:45:10')
  tz = time_double('2016-01-20/19:44:00.615')


  ;; ;;Reduce data only to times of overlap
  ;; v1 = 'hr0_0'
  ;; v2 = 'rbspa_fbk2_7pk_5'
  ;; v = tsample(v1,[t0,t1],times=t)
  ;; store_data,v1,t,v
  ;; v = tsample(v2,[t0,t1],times=t)
  ;; store_data,v2,t,v


  ;;Sample limited set of FB data out of entire set.
  v1 = 'hr0_0'
  v2 = 'rbspa_fbk2_7pk_5'
  t0l = time_double('2016-01-20/19:43:50')
  t1l = time_double('2016-01-20/19:44:10')
  v = tsample(v1,[t0l,t1l],times=t)
  store_data,v1,t,v
  v = tsample(v2,[t0,t1],times=t)
  store_data,v2,t,v


  tinterpol_mxn,'hr0_0','rbspa_fbk2_7pk_5',newname='hr0_0'
  get_data,'hr0_0',times,vtt



;;--------------------------------------------------
;;Define coherence window
;;--------------------------------------------------


;;--ROUGH WINDOW FOR LARGER TIMESHIFTS
;; ;--works great
     ;; window = 4.                ;seconds
     ;; lag = window/8.
     ;; coherence_time = window*4.5


;;--ROUGH WINDOW FOR LARGER TIMESHIFTS
;; ;--too large - picks up to many misses in addition to the hits.
     ;; window = 8.                ;seconds
     ;; lag = window/2.
     ;; coherence_time = window*4.5


;;--FINER WINDOW FOR EXACT LINEUPS. USE THIS WHEN TRYING TO DETERMINE
;;THE EXACT TIMESHIFT
;; ;--works great
  ;; window = 2.
  ;; lag = window/4.
  ;; coherence_time = window*4.5

  window = 3.
  lag = window/6.
;  coherence_time = window*4.5
  coherence_time = window*4


;  rbsp_detrend,['rbspa_fbk2_7pk_5'],0.1
  ylim,'rbspa_fbk1_7pk_5',0,2.5

  timespan,t0-175./2.,(t1-t0)+175,/seconds

;;--------------------------------------------------
;;START LOOPING HERE. Add in small corrections to FB times
;;--------------------------------------------------

;  corrfac = 1/16.                ;time correction factor (delta-t of FBK data)
  corrfac = 1/8.                ;time correction factor (delta-t of FBK data)
;  nsecs = 175.
  nsecs = 10.

  ntimes = nsecs/corrfac

;  ntimes = 200.
  totscoh = fltarr(ntimes)          ;total coherence over entire timerange
  corrarr = fltarr(ntimes)

  coh_int_maxv = fltarr(ntimes)
  coh_int_maxt = fltarr(ntimes)
  coh_int_dt = fltarr(ntimes)
  coh_int_avg = fltarr(ntimes)
  coh_int_med = fltarr(ntimes)
  coh_int_med2 = fltarr(ntimes)

  tshifts = indgen(ntimes)*corrfac
  tshifts = tshifts - max(tshifts)/2.

  for i=0,ntimes-1 do begin
     times2 = times + tshifts[i]   ;corrfac

     store_data,'hr0_0t',data={x:times2,y:vtt}


;;--------------------------------------------------
;;Calculate coherence spectrum
;;--------------------------------------------------


     v1 = 'hr0_0t'
     v2 = 'rbspa_fbk2_7pk_5'

     TT1 = t0
     TT2 = t1
     dynamic_cross_spec_tplot,v1,0,v2,0,TT1,TT2,window,lag,coherence_time,$
                              new_name='chorus_mb'

     cormin = 0.6
     get_data,'chorus_mb_coherence',data=coh
     ;;get rid of first element which has t=0
     coh = {x:coh.x[1:n_elements(coh.x)-1],y:coh.y[1:n_elements(coh.x)-1,*],v:coh.v,spec:1}
     goo = where(coh.y lt cormin)
     if goo[0] ne -1 then coh.y[goo] = !values.f_nan

     store_data,'chorus_mb_coherence',data={x:coh.x,y:coh.y,v:1/coh.v}
     options,'chorus_mb_coherence','ytitle','Chorus, MB!Ccoherence!C[period (sec)]'

     copy_data,'chorus_mb_coherence','chorus_mb_coherence_log'

     options,'chorus_mb_coherence*','spec',1

     ylim,'chorus_mb_coherence',0.2,10,1
     zlim,'chorus_mb_coherence',0.5,0.9,0
     tplot_options,'title','from jan20_chorus_microburst_coherence.pro'


;     spectral_integrator,'chorus_mb_coherence',0.3,3,10,1
     spectral_integrator,'chorus_mb_coherence',0.3,3,10,0.2,/noplot



     print,'*************************'
     print,i
     print,tshifts[i]
     print,'*************************'
     ylim,'chorus_mb_coherence_integrated',0,100
     ylim,v1,0,500
    tplot,[v1,v2,'chorus_mb_coherence','chorus_mb_coherence_integrated']
;    tplot,[v1,v2,'chorus_mb_coherence_integrated']
    wait,0.05
stop



     get_data,'chorus_mb_coherence_integrated',data=ci
     coh_int_maxv[i] = max(ci.y, wh)
     coh_int_maxt[i] = ci.x[wh]
     coh_int_dt[i] = tshifts[i]   ;corrfac*i
     coh_int_avg[i] = mean(ci.y)
     coh_int_med[i] = median(ci.y)
     tmp = moment(ci.y)
     coh_int_med2[i] = tmp[0]

  endfor

  !p.multi = [0,0,5]
  plot,coh_int_dt,coh_int_maxv,xrange=[0,6]
  plot,coh_int_dt,coh_int_maxv,xrange=[-100,100]
  plot,coh_int_dt,coh_int_avg,xrange=[-100,100]
  plot,coh_int_dt,coh_int_med,xrange=[-100,100]
  plot,coh_int_dt,coh_int_med2,xrange=[-100,100]

stop







;;Plot coherence slices
  store_data,'coh_1s',coh.x,coh.y[*,4]
  ylim,'coh_1s',0.6,1
  ylim,'chorus_mb_coherence',0.2,1
  tplot,['chorus_mb_comb','chorus_mb_coherence_log','chorus_mb_coherence','coh_1s']







  cs = cross_spec_tplot(v1,0,v2,0,TT1,TT2,overlap_index=3,sub_interval = 2.)
;; Return,[[E_FREQUENCE_coordinate],[PHASE_E1_E2],[COHERENCE_E1_E2],[Aver_Pow_E_1],[Aver_Pow_E_2]]


  tms = t0 + indgen(n_elements(cs[*,0]))*(t1-t0)/n_elements(cs[*,0])

  store_data,'cc',tms,cs[*,2]

  tplot,['hr0_0','rbspa_fbk2_7pk_5','chorus_mb_coherence','chorus_mb_coherence_log','cc']





  stop

end















;;      rbsp_detrend,'hr0_0',60.*0.005
;;      rbsp_detrend,'hr0_0_smoothed',60.*0.1

;;      tlimit,'2016-01-20/19:42','2016-01-20/19:47'
;;      tplot,['rbspa_fbk1_7pk_5','hr0_0_smoothed_detrend','hr0','hr0_v2']

;; ;; tmp = strsplit(data[0])

;;      ;; ;;Load more accurate Firebird H5 files

;; ;; file_loaded = '20150813_firebird-fu3_T89D_MagEphem.h5'
;; ;; ;; 20150813_firebird-fu4_T89D_MagEphem.h5
;; ;; ;; 20150826_firebird-fu3_T89D_MagEphem.h5
;; ;; ;; 20150827_firebird-fu3_T89D_MagEphem.h5
;; ;; ;; 20150827_firebird-fu4_T89D_MagEphem.h5
;; ;; ;; 20150828_firebird-fu3_T89D_MagEphem.h5
;; ;; ;; 20150828_firebird-fu4_T89D_MagEphem.h5
;; ;; fileroot = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/FB_Mag_for_aaron/'


;; ;;   unixtime = [0d]
;; ;; l = [0.]

;; ;; result = h5_parse(fileroot+file_loaded,/READ_DATA)

;; ;; offset = time_double('1980-01-06/00:00:00') - time_double('1970-01-01/00:00:00')
;; ;; gpstime = result.gpstime._data
;; ;; unixtime = [unixtime,gpstime + offset]


;; ;;                                 ;L*  (L-star parameter)
;; ;; l = [l,transpose(result.l._data)]






;; ;;--------------------------------------------------



;; ;Calculate MLT
;;      get_data,'firebird_gse',data=pos_gse_fb
;;      angle_tmp = atan(pos_gse_fb.y[*,1],pos_gse_fb.y[*,0])/!dtor
;;      goo = where(angle_tmp lt 0.)
;;      if goo[0] ne -1 then angle_tmp[goo] = 360. - abs(angle_tmp[goo])
;;      angle_rad = angle_tmp * 12/180. + 12.
;;      goo = where(angle_rad ge 24.)
;;      if goo[0] ne -1 then angle_rad[goo] = angle_rad[goo] - 24
;;      store_data,'firebird_mlt',data={x:times,y:angle_rad}


;; ;Calculate MLAT
;;      cotrans,'firebird_gse','firebird_gsm',/gse2gsm
;;      cotrans,'firebird_gsm','firebird_sm',/gsm2sm
;;      get_data,'firebird_sm',data=posfb_sm
;;      posfb_sm_mag = sqrt(posfb_sm.y[*,0]^2 + posfb_sm.y[*,1]^2 + posfb_sm.y[*,2]^2)


;;      rad_a = sqrt(pos_gse_fb.y[*,0]^2 + pos_gse_fb.y[*,1]^2 + pos_gse_fb.y[*,2]^2)/6370.
;;      store_data,'firebird_radius',data={x:pos_gse_fb.x,y:rad_a}


;;      dr2a = sqrt(posfb_sm.y[*,0]^2 + posfb_sm.y[*,1]^2)
;;      dz2a = posfb_sm.y[*,2]
;;      mlat_a = atan(dz2a,dr2a)

;;      store_data,'firebird_mlat',data={x:posfb_sm.x,y:mlat_a/!dtor}


;; ;calculate Lshell and compare to what's in file

;;      Lshell_a = rad_a/(cos(mlat_a)^2) ;L-shell in centered dipole
;;      store_data,'firebird_lshell2',data={x:posfb_sm.x,y:lshell_a}

;;      ylim,['firebird_lshell','firebird_lshell2'],0,20
;;      tplot,['firebird_lshell','firebird_lshell2']



;; ;Load Tsyganenko 04 model Lshell
;; ;  rbsp_read_ect_mag_ephem,'a',type='TS04D'

;; ;; ;;------------------------------
;; ;; ;;For dates with no definitive spice use this
;; ;; rbsp_read_ect_mag_ephem,sc,type='T89Q',/pre
;; ;; copy_data,'rbsp'+sc+'_ME_pos_gse','rbsp'+sc+'_state_pos_gse'
;; ;; copy_data,'rbsp'+sc+'_ME_pos_gsm','rbsp'+sc+'_state_pos_gsm'

;; ;; stop
;; ;; ;;------------------------------

;; ;Load state data
;;      rbsp_load_spice_state,probe=sc,coord='gse',/no_spice_load






;; ;Calculate MLT
;;      get_data,'rbsp'+sc+'_state_pos_gse',data=pos_gse
;;      angle_tmp = atan(pos_gse.y[*,1],pos_gse.y[*,0])/!dtor
;;      goo = where(angle_tmp lt 0.)
;;      if goo[0] ne -1 then angle_tmp[goo] = 360. - abs(angle_tmp[goo])
;;      angle_rad = angle_tmp * 12/180. + 12.
;;      goo = where(angle_rad ge 24.)
;;      if goo[0] ne -1 then angle_rad[goo] = angle_rad[goo] - 24
;;      store_data,'rbsp'+sc+'_mlt',data={x:pos_gse.x,y:angle_rad}


;; ;Calculate MLAT
;;      cotrans,'rbsp'+sc+'_state_pos_gse','rbsp'+sc+'_state_pos_gsm',/gse2gsm
;;      cotrans,'rbsp'+sc+'_state_pos_gsm','rbsp'+sc+'_state_pos_sm',/gsm2sm
;;      get_data,'rbsp'+sc+'_state_pos_sm',data=pos_sm
;;      pos_sm_mag = sqrt(pos_sm.y[*,0]^2 + pos_sm.y[*,1]^2 + pos_sm.y[*,2]^2)

;;      dr2a = sqrt(pos_sm.y[*,0]^2 + pos_sm.y[*,1]^2)
;;      dz2a = pos_sm.y[*,2]
;;      mlat_a = atan(dz2a,dr2a)
;;      store_data,'rbsp'+sc+'_mlat',data={x:pos_sm.x,y:mlat_a/!dtor}



;; ;calculate dipole Lshell
;;      get_data,'rbsp'+sc+'_state_pos_gse',data=pos_gse
;;      rad_a = sqrt(pos_gse.y[*,0]^2 + pos_gse.y[*,1]^2 + pos_gse.y[*,2]^2)/6370.
;;      store_data,'rbsp'+sc+'_state_radius',data={x:pos_gse.x,y:rad_a}

;;      Lshell_a = rad_a/(cos(!dtor*mlat_a)^2) ;L-shell in centered dipole
;;      store_data,'rbsp'+sc+'_lshell',data={x:pos_sm.x,y:lshell_a}


;; ;;compare Tsy Lshell with dipole Lshell
;;      dif_data,'RBSPa!CL-shell-t04','rbsp'+sc+'_lshell'
;;      tplot,['RBSPa!CL-shell-t04-rbsp'+sc+'_lshell']


;; ;;--------------------------------------------------
;; ;;Calculate separations b/t RBSP and FIREBIRD
;; ;;--------------------------------------------------

;;      ;; dif_data,'rbsp'+sc+'_mlt','firebird_mlt'
;;      ;; dif_data,'rbsp'+sc+'_ME_lshell','firebird_lshell'

;;      ;;Use the higher firebird cadence for differencing
;;      dif_data,'firebird_mlt','rbsp'+sc+'_mlt'
;;      get_data,'firebird_mlt-rbsp'+sc+'_mlt',data=dd
;;      store_data,'rbsp'+sc+'_mlt-firebird_mlt',data={x:dd.x,y:-1*dd.y}

;;      dif_data,'firebird_lshell','rbsp'+sc+'_lshell'
;;      get_data,'firebird_lshell-rbsp'+sc+'_lshell',data=dd
;;      store_data,'rbsp'+sc+'_lshell-firebird_lshell',data={x:dd.x,y:-1*dd.y}


;; ;;Find absolute separation b/t payloads

;;      dif_data,'rbsp'+sc+'_state_pos_gse','firebird_gse',newname='gse_diff'
;;      get_data,'gse_diff',data=pos_diff
;;      store_data,'gse_diff',/delete

;;      dx = pos_diff.y[*,0]/1000.
;;      dy = pos_diff.y[*,1]/1000.
;;      dz = pos_diff.y[*,2]/1000.

;;      sc_sep = sqrt(dx^2 + dy^2 + dz^2)

;;      store_data,'sc_sep',data={x:pos_diff.x,y:sc_sep}
;;      options,'sc_sep','labflag',0
;;      options,'sc_sep','ytitle','SC GSE!Cabsolute!Cseparation!C[x1000 km]'

;;      store_data,'gse_sep',data={x:pos_diff.x,y:[[dx],[dy],[dz]]}
;;      options,'gse_sep','labels',['dx gse','dy gse','dz gse']
;;      options,'gse_sep','ytitle','SC GSE!Cseparation!C[x1000 km]'

;;      store_data,'mltzero',data={x:pos_diff.x,y:replicate(0.,n_elements(pos_diff.x))}
;;      store_data,'lshellzero',data={x:pos_diff.x,y:replicate(0.,n_elements(pos_diff.x))}
;;      options,['mltzero','lshellzero'],'linestyle',2
;;      store_data,'lshellcomb',data=['rbsp'+sc+'_lshell','firebird_lshell']
;;      store_data,'mltcomb',data=['rbsp'+sc+'_mlt','firebird_mlt']
;;      store_data,'mltcompare',data=['rbsp'+sc+'_mlt-firebird_mlt','mltzero']
;;      store_data,'lshellcompare',data=['rbsp'+sc+'_lshell-firebird_lshell','lshellzero']


;;      options,'lshellcomb','colors',[0,250]
;;      options,'mltcomb','colors',[0,250]
;;      options,'mltcompare','colors',[0,50]
;;      options,'lshellcompare','colors',[0,50]


;;      options,'mltcompare','ytitle','deltaMLT!CRBSP'+sc+'-FIREBIRD'+fb
;;      options,'lshellcompare','ytitle','deltaLSHELL!CRBSP'+sc+'-FIREBIRD'+fb
;;      options,'lshellcomb','ytitle','Lshell!CRBSP'+sc+' and!CFIREBIRD'+fb
;;      options,'mltcomb','ytitle','MLT!CRBSP'+sc+' and!CFIREBIRD'+fb

;;      ylim,'lshellcomb',0,10
;;      ylim,'mltcomb',0,24
;;      ylim,'mltcompare',-10,10
;;      ylim,'lshellcompare',-10,10


;;      store_data,'mlatcomb',data=['rbsp'+sc+'_mlat','firebird_mlat']
;;      options,'mlatcomb','colors',[0,250]
;;      options,'mlatcomb','ytitle','mlat!CRBSP'+sc+' and!CFIREBIRD'+fb

;;      tplot_options,'title','From rbsp_firebird_conjunctions.pro'
;;      tplot,['lshellcomb','mltcomb',$
;;             'sc_sep',$
;;             'mltcompare','lshellcompare']


;;      outname = 'firebird'+fb+'_RBSP'+sc+'_'+strmid(date,0,4)+strmid(date,5,2)+strmid(date,8,2)+$
;;                '_conjunction.ps'
;;      popen,'~/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/'+outname
;;      !p.charsize = 0.8
;;      tplot
;;      pclose







;;      options,'*shell*','panel_size',0.5
;;      options,'*mlt*','panel_size',0.5
;;      options,'*mlat*','panel_size',0.5


;;      ylim,'rbsp'+sc+'_fbk2_7pk_?',0,0
;;      ylim,'rbsp'+sc+'_efw_64_spec0',100,10000,1
;;      tplot,['mlatcomb','lshellcomb','mltcomb',$
;; ;         'sc_sep',$
;;             'mltcompare','lshellcompare',$
;;             'rbsp'+sc+'_efw_64_spec0',$
;; ;         'rbsp'+sc+'_efw_64_spec4',$
;; ;         'rbsp'+sc+'_fbk2_7pk_2',$
;; ;         'rbsp'+sc+'_fbk2_7pk_3',$
;; ;         'rbsp'+sc+'_fbk2_7pk_4',$
;;             'rbsp'+sc+'_fbk2_7pk_5',$
;;             'rbsp'+sc+'_fbk2_7pk_6']


;;      ylim,'rbsp'+sc+'_fbk1_7pk_?',0,2
;;      ylim,'rbsp'+sc+'_efw_64_spec4',50,1000,1

;;      tplot,['firebird_mlat','lshellcomb','mltcomb',$
;;             'sc_sep',$
;;             'mltcompare','lshellcompare',$
;;             'rbsp'+sc+'_efw_64_spec4',$
;;             'rbsp'+sc+'_fbk1_7pk_2',$
;;             'rbsp'+sc+'_fbk1_7pk_3',$
;;             'rbsp'+sc+'_fbk1_7pk_4',$
;;             'rbsp'+sc+'_fbk1_7pk_5',$
;;             'rbsp'+sc+'_fbk1_7pk_6']




;;      ylim,'rbsp'+sc+'_fbk2_7pk_?',0,0,0
;;      ylim,'rbsp'+sc+'_fbk2_7pk_1',0,50
;;      tplot_options,'thick',1

;;      tplot,['firebird_mlat','lshellcomb','mltcomb',$
;;             'mltcompare','lshellcompare',$
;;             'rbsp'+sc+'_efw_64_spec4',$
;;             'rbsp'+sc+'_fbk2_7pk_1',$
;;             'rbsp'+sc+'_fbk2_7pk_2',$
;;             'rbsp'+sc+'_fbk2_7pk_3',$
;;             'rbsp'+sc+'_fbk2_7pk_4']




;;      tplot,['mlatcomb','lshellcomb','mltcomb',$
;;                                 ;'sc_sep',$
;;             'mltcompare','lshellcompare',$
;;             'rbsp'+sc+'_efw_64_spec0',$
;;             'rbsp'+sc+'_efw_64_spec4']
;; ;         'rbsp'+sc+'_efw_64_spec4',$
;; ;         'rbsp'+sc+'_fbk2_7pk_2',$
;; ;         'rbsp'+sc+'_fbk2_7pk_3',$
;; ;         'rbsp'+sc+'_fbk2_7pk_4',$
;; ;         'rbsp'+sc+'_fbk1_7pk_5',$
;; ;         'rbsp'+sc+'_fbk1_7pk_4',$
;; ;         'rbsp'+sc+'_fbk1_7pk_3',$
;; ;         'rbsp'+sc+'_fbk1_7pk_2',$
;; ;         'rbsp'+sc+'_fbk2_7pk_5',$
;; ;         'rbsp'+sc+'_fbk2_7pk_4',$
;; ;         'rbsp'+sc+'_fbk2_7pk_3',$
;; ;         'rbsp'+sc+'_fbk2_7pk_2']



;;      tplot,['rbsp'+sc+'_efw_64_spec0',$
;; ;         'rbsp'+sc+'_fbk2_7pk_2',$
;; ;         'rbsp'+sc+'_fbk2_7pk_3',$
;;             'rbsp'+sc+'_fbk1_7pk_6',$
;;             'rbsp'+sc+'_fbk1_7pk_5',$
;; ;         'rbsp'+sc+'_fbk1_7pk_4',$
;;             'rbsp'+sc+'_efw_64_spec4',$
;;             'rbsp'+sc+'_fbk2_7pk_6',$
;;             'rbsp'+sc+'_fbk2_7pk_5',$
;;             'rbsp'+sc+'_fbk2_7pk_4']


;;      stop
;;   end
