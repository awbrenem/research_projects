;Create tplot files that have the distance of each barrel payload
;from the Goldstein plasmapause as a function of time

pro py_create_barrel_plasmapause_distance


  args = command_line_args()

  if keyword_set(args) then begin
    payload = strupcase(args[0])
    pre = args[1]
    fspc = floor(float(args[2]))
    datapath = args[3]
    folder_ephem = args[4]
    folder_singlepayload = args[5]
  endif else begin 
    payload = 'I'
    pre = '2'
    fspc = 1
    datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
    folder_ephem = 'barrel_ephemeris'
    folder_singlepayload = 'folder_singlepayload'
  endelse


  if fspc then fspcS = 'fspc' else fspcS = 'PeakDet'

  ;;Limit to available PP model data. Note that although the data starts
  ;;at 00:00 on 01-01, the first usable data isn't until about 12
  ;;UT. Jerry starts the PP run with a HUGE plasmapause. This then
  ;;starts reducing to its actual size after an initiation time.
  T0 = time_double('2014-01-01/12:00')
  T1 = time_double('2014-02-14')


  ;Load single payload data that has had artifacts like solar flares removed
  fn1 = 'barrel_'+pre+payload+'_'+fspcS+'_fullmission.tplot'
  tplot_restore,filenames=datapath + folder_singlepayload + '/' + fn1
  ;Note: could also load single payload data with load_barrel_data_noartifacts.pro, which removes
  ;data gaps and fills with uncorrelated data. However, for this routine it's probably better to use the 
  ;more unprocessed data. 



  y = tsample('MLT_Kp2_'+pre+payload,[T0,T1],times=tms)
  store_data,'MLT_Kp2_'+pre+payload,data={x:tms,y:y}
  y = tsample('L_Kp2_'+pre+payload,[T0,T1],times=tms)
  store_data,'L_Kp2_'+pre+payload,data={x:tms,y:y}

  get_data,'MLT_Kp2_'+pre+payload,data=mlt
  times = mlt.x

  ;;Downsample the times to a lower cadence. Goldstein simulations on 15
  ;;minute cadence
  dt = 15*60.                ;new sample period
  nloop = floor((max(times,/nan)-min(times,/nan))/dt)
  times2 = lindgen(nloop)*(max(times,/nan)-min(times,/nan))/nloop + min(times,/nan)


  tinterpol_mxn,'MLT_Kp2_'+pre+payload,times2
  tinterpol_mxn,'L_Kp2_'+pre+payload,times2
  get_data,'MLT_Kp2_'+pre+payload+'_interp',data=mlt_i
  get_data,'L_Kp2_'+pre+payload+'_interp',data=lshell_i

  dmltv = fltarr(n_elements(times2))
  dlshellv = fltarr(n_elements(times2))

  for q=0,n_elements(times2)-1 do begin
  ;****NEED TO FIX. THIS IS NO LONGER A FUNCTION****
  ;****
  ;****
  ;****
    pp = plasmapause_goldstein_boundary(times2[q],mlt_i.y[q],lshell_i.y[q]) ;,/plot)
    dmltv[q] = pp.mlt_offset
    dlshellv[q] = pp.distance_from_pp
  endfor

  store_data,'dist_pp_'+pre+payload,data={x:times2,y:dlshellv}
  store_data,'dist_mlt_'+pre+payload,data={x:times2,y:dmltv}


  ;;Create the tplot binary variables that indicate whether balloon is
  ;;inside/outside of PS
  get_data,'dist_pp_'+pre+payload,data=goo

  line = replicate(0.,n_elements(goo.x))
  store_data,'zerolinePPD',data={x:goo.x,y:line}
  options,'zerolinePPD','linestyle',4
  store_data,'dist_pp_'+pre+payload+'_comb',$
  data=['dist_pp_'+pre+payload,'zerolinePPD']


  bin1 = fltarr(n_elements(goo.x))
  too = where(goo.y gt 0)
  if too[0] ne -1 then bin1[too] = 1
  too = where(goo.y le 0)
  if too[0] ne -1 then bin1[too] = -1
  store_data,'dist_pp_'+pre+payload+'_bin',$
  data={x:goo.x,y:bin1}

  bin1v = fltarr(n_elements(goo.x))
  too = where(goo.y ge 0.5)
  if too[0] ne -1 then bin1v[too] = 1
  too = where(goo.y le -0.5)
  if too[0] ne -1 then bin1v[too] = -1
  store_data,'dist_pp_'+pre+payload+'_bin_0.5',$
  data={x:goo.x,y:bin1v}




  tsave = ['dist_pp_'+pre+payload,$
  'dist_mlt_'+pre+payload,$
  'dist_pp_'+pre+payload+'_bin',$
  'dist_pp_'+pre+payload+'_bin_0.5']

  tplot_save,tsave,filename=datapath + folder_ephem + '/' + pre + payload + '_pp_dist'

end
