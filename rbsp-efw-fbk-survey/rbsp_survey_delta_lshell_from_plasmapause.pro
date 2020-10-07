;Create a tplot variable that contains the estimated distance from the
;plasmapause based on the times of plasmapause crossings as well as estimates
;from the Goldstein model

;Different ways of determining distance from plasmapause
;1) radial trace from RBSP position to Goldstein PP
;2) Assuming the PP exists at location identified by most recent RBSP PP crossings
;3) Using Scott Thaller's list of inbound and outbound PP crossings



;;Plasmasphere crossing times from
;;plasmasphere_build_database.pro. Note to set the minsep time so short-duration
;;perturbations in Vsvy don't register as plasmapause crossings

pro rbsp_survey_delta_lshell_from_plasmapause


  probe = 'a'
  rbsp_efw_init
;  path = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_fbk13a/'
  path = '~/Desktop/Research/RBSP_FBK_first_results/runtest_fbk13a/'
  fn = 'info.idl'
  restore,path+fn



;-------------------------------------------------
;Open correct file with times (and relevant data) of PP crossings and set start and end dates
;----------------------------------------------------

  d0 = '2012-09-25'
  d1 = '2013-03-15'
  d0t = time_double(d0)
  d1t = time_double(d1)
  d0tt = strmid(d0,0,4) + strmid(d0,5,2) + strmid(d0,8,2)
  d1tt = strmid(d1,0,4) + strmid(d1,5,2) + strmid(d1,8,2)
  fn_pp = 'plasmasphere_rbspa_database_'+d0tt+'_'+d1tt+'.txt'
;  openr,lun,'~/Desktop/code/Aaron/RBSP/survey_programs_hiss/' + 'plasmasphere_rbspa_database.txt',/get_lun
;openr,lun,'~/Desktop/Research/RBSP_FBK_first_results/datafiles/' + 'plasmasphere_rbspa_database_20121231_20130101.txt',/get_lun
openr,lun,'~/Desktop/Research/RBSP_FBK_first_results/datafiles/' + fn_pp,/get_lun

;-------------------------------------------------




;----------------------------------------------------
;Read in PP crossings file
;----------------------------------------------------

  psi = ''                      ;time of inbound plasmasphere entry
  pso = ''                      ;time of outbound plasmasphere exit
  deltaT = ''
  lshelli = ''
  lshello = ''
  mlti = ''
  mlto = ''
  mlati = ''
  mlato = ''
  radiusi = ''
  radiuso = ''
  jnk = ''
  header = ''
  cnt = 0.
  readf,lun,header              ;read header

  while not eof(lun) do begin
     readf,lun,jnk
     vals = strsplit(jnk,/extract)
     psi = [psi,vals[0]]
     pso = [pso,vals[1]]
     deltaT = [deltaT,vals[2]]
     lshelli = [lshelli,vals[3]]
     lshello = [lshello,vals[4]]
     mlti = [mlti,vals[5]]
     mlto = [mlto,vals[6]]
     mlati = [mlati,vals[7]]
     mlato = [mlato,vals[8]]
     radiusi = [radiusi,vals[9]]
     radiuso = [radiuso,vals[10]]

     cnt++

     ;; print,jnk
     ;; print,psi[cnt-1]
     ;; print,pso[cnt-1]
     ;; print,'  '
  endwhile

  close,lun
  free_lun,lun



  psi = time_double(psi[1:cnt])
  pso = time_double(pso[1:cnt])
  deltaT = deltaT[1:cnt]
  lshelli = lshelli[1:cnt]
  lshello = lshello[1:cnt]
  mlti = mlti[1:cnt]
  mlto = mlto[1:cnt]
  mlati = mlati[1:cnt]
  mlato = mlato[1:cnt]
  radiusi = radiusi[1:cnt]
  radiuso = radiuso[1:cnt]

;for i=0,14 do print,time_string(psi[i]) + ' ' + time_string(pso[i])
;----------------------------------------------------





  if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'
  tplot_restore,filename=path+'ephem_RBSP'+probe+'.tplot'
  tplot,'rbsp'+probe+'_'+['mlt','lshell']


stop
  ;Remove some data outside of timerange
  y = tsample('rbsp'+probe+'_mlt',[d0t,d1t + 86400.],times=tms)
  store_data,'rbsp'+probe+'_mlt',tms,y
  y = tsample('rbsp'+probe+'_lshell',[d0t,d1t + 86400.],times=tms)
  store_data,'rbsp'+probe+'_lshell',tms,y
  get_data,'rbsp'+probe+'_mlt',times,mlt


;;--------------------------------------------------
;;Remove day boundaries in entry/exit times
;;--------------------------------------------------

  psiF = time_string(psi)
  psoF = time_string(pso)

  goo = where(strmid(psoF,11,8) eq '23:59:59')
;;Make sure goo doesn't refer to the very last element of the
;;database. It's OK for this element to be the last time of the day
  if goo[n_elements(goo)-1] eq n_elements(psoF)-1 then goo = goo[0:n_elements(goo)-2]
  if goo[0] ne -1 then psoF[goo] = 'xxxxxxxxxxxxxxxxxxx'
  if goo[0] ne -1 then psiF[goo+1] = 'xxxxxxxxxxxxxxxxxxx'
;for i=0,14 do print,psiF[i] + ' ' + psoF[i]



  goo = where(psiF ne 'xxxxxxxxxxxxxxxxxxx')
  if goo[0] ne -1 then begin
     psiF = psiF[goo]
     lshelliF = lshelli[goo]
     mltiF = mlti[goo]
     mlatiF = mlati[goo]
     radiusiF = radiusi[goo]
  endif

  goo = where(psoF ne 'xxxxxxxxxxxxxxxxxxx')
  if goo[0] ne -1 then begin
     psoF = psoF[goo]
     lshelloF = lshello[goo]
     mltoF = mlto[goo]
     mlatoF = mlato[goo]
     radiusoF = radiuso[goo]
  endif





;-----------------------------------------------------
;Determine PP crossing distances from Goldstein model
;-----------------------------------------------------

;for i=0,14 do print,psiF[i] + ' ' + psoF[i]

  get_data,'rbsp'+probe+'_mlt',tt,mlt
  get_data,'rbsp'+probe+'_lshell',tt,lshell
  ttmp = times
  pp = plasmapause_goldstein_boundary(ttmp,mlt,lshell) ;,plot=plotpp,ps=ps,name=name)


  l_nearest = pp.l_nearest
  mlt_nearest = pp.mlt_nearest
  goo = where(pp.distance_from_pp lt 0.)
  if goo[0] ne -1 then l_nearest[goo] = !values.f_nan
  if goo[0] ne -1 then mlt_nearest[goo] = !values.f_nan


  store_data,'gold_l_nearest',times,l_nearest
  store_data,'gold_mlt_nearest',times,mlt_nearest
  store_data,'gold_distance_from_pp',times,pp.distance_from_pp
  store_data,'gold_mlt_offset',times,pp.mlt_offset
;; t0 = time_double('2012-10-13/08:00')
;; mllt = tsample('rbsp'+probe+'_mlt',t0,times=tms)
;; ll = tsample('rbsp'+probe+'_lshell',t0,times=tms)
;; pp = plasmapause_goldstein_boundary(tms,mllt,ll,/plot)







;;------------------------------------------------------------------------------
;; Create distance from plasmapause variable
;;------------------------------------------------------------------------------


;;--first sorting method: values outside of the pp are referenced to
;;the closest measured pp value in time
;;--second sorting method: values outside of the pp are referenced to
;;the closest measured pp value in MLT
;;--third sorting method: Goldstein pp model




;;apogee times (when sc is outside of the plasmasphere)
  mspherei = psoF               ;entry time into low density magnetosphere (exit from PS)
  msphereo = shift(psiF,-1)     ;exit of low density magnetosphere
  lshelli_ms = lshelloF
  lshello_ms = shift(lshelliF,-1)

  mspherei = mspherei[0:n_elements(mspherei)-2]
  msphereo = msphereo[0:n_elements(msphereo)-2]



;;--------------------------------------------------
;;Pad either or both the psi/pso arrays and the msphere arrays
;;I do this b/c I have to account for all the possible times in a day
;;and, for example, if the first ps crossing starts at 01:00 then, at
;;this point, the msphere array won't have any values from 00:00-01:00.
;;I also want to ensure that the apogee and perigee arrays have the
;;same number of entries. This makes the looping easler later on.
;;--------------------------------------------------

;;see if we need to pad the apogee array with a single time
;;that's the start of the first day.
  tt0 = psiF[0]
  tt0t = strmid(tt0,0,10) + '/00:00:00'
  if time_double(tt0) - time_double(tt0t) gt 0 then begin
     mspherei = [tt0t,mspherei]
     msphereo = [tt0,msphereo]
     ;;do this so psi and pso arrays have same number of elements
     psiF = [tt0t,psiF]
     psoF = [tt0t,psoF]

     lshelliF = [lshelliF[0],lshelliF]
     lshelloF = [lshelloF[0],lshelloF]

  endif

;;see if we need to pad the apogee array with a single time
;;that's the end of the last day.
  tt0 = psoF[n_elements(psoF)-1]
  tt0t = strmid(tt0,0,10) + '/23:59:59'
  if time_double(tt0t) - time_double(tt0) ge 0 then begin
     mspherei = [mspherei,tt0]
     msphereo = [msphereo,tt0t]

;   lshelliF = [lshelliF,lshelliF[n_elements(lshelliF)-1]]
;   lshelloF = [lshelloF,lshelloF[n_elements(lshelloF)-1]]
  endif




  print,'ps times'
  for i=0,n_elements(psiF)-1 do print,psiF[i] + ' ' + psoF[i]
  print,'apogee times'
  for i=0,n_elements(mspherei)-1 do print,mspherei[i] + ' ' + msphereo[i]


  psvals = fltarr(n_elements(times))
  lshell_ref = fltarr(n_elements(times))


;----------------------------------------------------------------------
  ;;--first sorting method: values outside of the pp are referenced to
  ;;the closest measured pp value in time
  for i=0L,n_elements(psiF)-2 do begin
     tp0 = time_double(psiF[i])
     tp1 = time_double(psoF[i])
     tm0 = time_double(mspherei[i])
     tm1 = time_double(msphereo[i])
     print,'**********'
     print,'Plasmasphere: ' + time_string(tp0) + ' to ' + time_string(tp1)
     print,'Magsphere:    ' + time_string(tm0) + ' to ' + time_string(tm1)



;--chunk1
     tstart = tp0 < tm0
     tend = (tp1 - (tp1 - tp0)/2.) < (tm1 - (tm1 - tm0)/2.)
     tgoo = where((times ge tstart) and (times le tend))

     if tp0 lt tm0 then region = 'ps' else region = 'ms'
     if tgoo[0] ne -1 then begin
        if region eq 'ps' then lshell_ref[tgoo] = lshelliF[i]
        if region eq 'ms' then lshell_ref[tgoo] = lshelli_ms[i]
     endif

     print,'...Chunk1: ' + region + ' ' + time_string(tstart) + ' to ' + time_string(tend)
     ;; if region eq 'ps' then print,lshelliF[i]
     ;; if region eq 'ms' then print,lshelli_ms[i]



;--chunk2
     tstart = tend
     tend = tp1 < tm1
     tgoo = where((times ge tstart) and (times le tend))

     if tp1 lt tm1 then region = 'ps' else region = 'ms'
     if tgoo[0] ne -1 then begin
        if region eq 'ps' then lshell_ref[tgoo] = lshelloF[i]
        if region eq 'ms' then lshell_ref[tgoo] = lshello_ms[i]
     endif

     print,'...Chunk2: ' + region + ' ' + time_string(tstart) + ' to ' + time_string(tend)
     ;; if region eq 'ps' then print,lshelloF[i]
     ;; if region eq 'ms' then print,lshello_ms[i]

;stop
;--chunk3
     tstart = tp0 > tm0
     tend = (tp1 - (tp1 - tp0)/2.) > (tm1 - (tm1 - tm0)/2.)
     tgoo = where((times ge tstart) and (times le tend))

     if tp0 ge tm0 then region = 'ps' else region = 'ms'
     if tgoo[0] ne -1 then begin
        if region eq 'ps' then lshell_ref[tgoo] = lshelliF[i]
        if region eq 'ms' then lshell_ref[tgoo] = lshelli_ms[i]
     endif

     print,'...Chunk3: ' + region + ' ' + time_string(tstart) + ' to ' + time_string(tend)
     ;; if region eq 'ps' then print,lshelliF[i]
     ;; if region eq 'ms' then print,lshelli_ms[i]

;stop
;--chunk4
     tstart = tend
     tend = tp1 > tm1
     tgoo = where((times ge tstart) and (times le tend))

     if tp1 ge tm1 then region = 'ps' else region = 'ms'
     if tgoo[0] ne -1 then begin
        if region eq 'ps' then lshell_ref[tgoo] = lshelloF[i]
        if region eq 'ms' then lshell_ref[tgoo] = lshello_ms[i]
     endif

     print,'...Chunk4: ' + region + ' ' + time_string(tstart) + ' to ' + time_string(tend)
     ;; if region eq 'ps' then print,lshelloF[i]
     ;; if region eq 'ms' then print,lshello_ms[i]

     print,'**********'

  endfor


  store_data,'lshell_ref',times,lshell_ref
  store_data,'lshelli',time_double(psiF),lshelliF
  dif_data,'rbsp'+probe+'_lshell','lshell_ref'


  tlimit,d0,d1
;  kyoto_load_dst
;  tplot,['rbsp'+probe+'_lshell','lshell_ref','lshelli','kyoto_dst']


  copy_data,'rbsp'+probe+'_lshell-lshell_ref','rbsp'+probe+'_distance_from_pp'



  ;----
  ;remove data outside of timerange. Not doing this results in
  ;differenced data where one quantity has data (RBSP Lshell) and the other doesn't (distance from pp data),
  ;resulting in bad distance from pp data.
  xtmp = tsample('rbsp'+probe+'_distance_from_pp',[d0t,d1t],times=tms)
  store_data,'rbsp'+probe+'_distance_from_pp',tms,xtmp
  ;----


  store_data,'lcomb',data=['lshelli','lshell_ref','gold_l_nearest']
  options,'lcomb','colors',[0,50,250]
  options,'lcomb','ytitle','RBSP'+probe+ ' nearest PP(black)!CRBSPa binned PP(blue)!CGoldstein PP(red)'
  options,'lshelli','thick',2
  options,'lshelli','psym',-4

  store_data,'pp_distance_comb',data=['rbsp'+probe+'_distance_from_pp','gold_distance_from_pp']
  options,'pp_distance_comb','colors',[0,250]
  options,'pp_distance_comb','ytitle','Dist outside PP!Creference=RBSP nearest!Ccrossing(black)!Creference=GoldsteinPP(red)'


  ylim,['rbsp'+probe+'_distance_from_pp','gold_distance_from_pp','pp_distance_comb'],-6,4
  ylim,'lcomb',0,7

  tplot,['rbsp'+probe+'_lshell',$
         'lcomb',$
         'pp_distance_comb',$
         'kyoto_dst']








;;------------------------------------------------------------------------------
;;Load Thaller PP crossing files
;;------------------------------------------------------------------------------

  path2 = '~/Desktop/code/Aaron/datafiles/thaller_pp_files/'
  fn = 'RBSP'+probe+'_inbound_plasmapause_L_times_2013.txt'
  fn2 = 'RBSP'+probe+'_outbound_plasmapause_L_times_2013.txt'
  openr,lun,path2+fn,/get_lun
  openr,lun2,path2+fn2,/get_lun


  th_times = ''
  th_Lout = 0.
  th_Lin = 0.
  jnk = ''
  jnk2 = ''
  i = 0L
  while not eof(lun) do begin            ;$
     readf,lun,jnk                       ;& $
     readf,lun2,jnk2                     ;& $
     vals = strsplit(jnk,' ',/extract)   ;& $
     vals2 = strsplit(jnk2,' ',/extract) ;& $
     th_times = [th_times,vals[0]]       ;& $
     th_Lin = [th_Lin,vals[1]]           ;& $
     th_Lout = [th_Lout,vals2[1]]        ;& $
     i++
  endwhile


  close,lun,lun2
  free_lun,lun,lun2

  th_times = th_times[1:n_elements(th_times)-1]
  th_Lout = th_Lout[1:n_elements(th_times)-1]
  th_Lin = th_Lin[1:n_elements(th_times)-1]

  goo = where(th_times ne '0000-00-00/00:00:00')
  if goo[0] ne -1 then th_times = th_times[goo]
  if goo[0] ne -1 then th_Lout = th_Lout[goo]
  if goo[0] ne -1 then th_Lin = th_Lin[goo]

  store_data,'th_ppoutbound',time_double(th_times),th_Lout
  store_data,'th_ppinbound',time_double(th_times),th_Lin
  tplot,['th_ppoutbound','th_ppinbound']












  timespan,'2013-01-01',365,/days

  store_data,'lcomb2',data=['lshelli','lshell_ref','gold_l_nearest','th_ppinbound','th_ppoutbound']
  options,['th_ppoutbound','th_ppinbound'],'thick',2
  options,['th_ppoutbound','th_ppinbound'],'linestyle',2
  options,'lcomb2','colors',[0,50,250,200,120]
  options,'lcomb2','ytitle','RBSP'+probe+' nearest PP(black)!CRBSP'+probe+' binned PP(blue)!CGoldstein PP(red)!CRBSP ThallerinboundPP(orange)!CRBSP Thalleroutbound(green)'




         ;smooth the distance from pp data to remove abrupt jumps
rbsp_detrend,'rbsp'+probe+'_distance_from_pp',60.*60.
rbsp_detrend,'gold_distance_from_pp',60.*60.

store_data,'pp_distance_smoothed_comb',data=['rbsp'+probe+'_distance_from_pp_smoothed','gold_distance_from_pp_smoothed']
options,'pp_distance_smoothed_comb','colors',[0,250]
options,'pp_distance_smoothed_comb','ytitle','Dist outside PP(smoothed)!Creference=RBSP nearest!Ccrossing(black)!Creference=GoldsteinPP(red)'
ylim,'pp_distance_smoothed_comb',-6,4




tplot,['rbsp'+probe+'_lshell',$
       'lcomb2',$
       'pp_distance_comb',$
       'pp_distance_smoothed_comb']

tplot_save,['rbspa_distance_from_pp','gold_distance_from_pp'],filename=path+'dist_from_pp'




end
