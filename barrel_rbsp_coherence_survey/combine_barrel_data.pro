;Combine BARREL fast spec (FSPC) or peak detector values for multiple days into a single tplot file.

;ephem -> only load ephemeris data (L, MLT from Kp2 and Kp6, and altitude)
;fspc  -> load fast spec data instead of peak detector

pro combine_barrel_data,payload,dates,ephem=ephem,fspc=fspc

  ;Remove pre-existing variables that will be created in this routine
  store_data,'fspc_' + payload,/delete
  store_data,'PeakDet_' + payload,/delete
  store_data,'L_Kp2_*' + payload,/delete
  store_data,'L_Kp6_*' + payload,/delete
  store_data,'MLT_Kp2_*' + payload,/delete
  store_data,'MLT_Kp6_*' + payload,/delete

  n = n_elements(dates)


  ;Load multiple days of rate count data, if requested
  if ~keyword_set(ephem) and ~keyword_set(fspc) then begin

    data = [0.] & tms = [0d] & qual = [0.]

    for i=0,n-1 do begin
      timespan,dates[i]
      load_barrel_lc,payload,type='rcnt'

      get_data,'PeakDet_' + payload,data=d
      get_data,'Quality',data=q

      if is_struct(d) then data = [data,d.y]
      if is_struct(d) then tms = [tms,d.x]
      if is_struct(q) then qual = [qual,q.y]

      store_data,'PeakDet_' + payload,/delete
    endfor

    data = data[1:n_elements(data)-1]
    tms = tms[1:n_elements(tms)-1]
    if fspc then qual = qual[1:n_elements(qual)-1]

    store_data,'PeakDet_' + payload,data={x:tms,y:data}
    if fspc then store_data,'Quality_' + payload,data={x:tms,y:qual}

  endif

  ;Load multiple days of fast spec data, if requested
  if keyword_set(fspc) then begin

    data = [0.] & tms = [0d] & qual = [0.]

    for i=0,n-1 do begin

      timespan,dates[i]
      load_barrel_lc,payload,type='fspc'

      ;Load BARREL data for missions 2 or 3
      if strmid(payload,0,1) eq '2' or strmid(payload,0,1) eq '3' or strmid(payload,0,1) eq '4' then begin
          get_data, 'FSPC1a_'+payload, DATA=LC1a
          get_data, 'FSPC1b_'+payload, DATA=LC1b
          get_data, 'FSPC1b_'+payload, DATA=LC1c
          get_data, 'FSPC2_'+payload, DATA=LC2
          get_data, 'FSPC3_'+payload, DATA=LC3
          get_data, 'FSPC4_'+payload, DATA=LC4
          if is_struct(LC1a) then peak = LC1a.y + LC1b.y + LC1c.y + LC2.y + LC3.y + LC4.y
      endif else begin
      ;Load BARREL data for mission 1
          get_data, 'FSPC1_'+payload, DATA=LC1
          get_data, 'FSPC2_'+payload, DATA=LC2
          get_data, 'FSPC3_'+payload, DATA=LC3
          get_data, 'FSPC4_'+payload, DATA=LC4
          if is_struct(LC1) then peak = LC1.y + LC2.y + LC3.y + LC4.y
      endelse

      ;If the LC2 structure exists, then all should be well.
      if is_struct(LC2) then data = [data,peak]
      if is_struct(LC2) then tms = [tms,LC2.x]

    endfor

    store_data,'fspc_'+payload,data={x:tms,y:data}


    if n_elements(data) gt 1 then begin
      data = data[1:n_elements(data)-1]
      tms = tms[1:n_elements(tms)-1]
      store_data,'fspc_'+payload,data={x:tms,y:data}
    endif

    undefine,peak,LC1a,LC1b,LC1c,LC1,LC2,LC3,LC4

  endif



  ;Load multiple days worth of ephemeris data
  dataL1 = [0.]
  dataL2 = [0.]
  dataMLT1 = [0.]
  dataMLT2 = [0.]
  dataalt = [0.]

  tmsL1 = [0d]
  tmsL2 = [0d]
  tmsMLT1 = [0d]
  tmsMLT2 = [0d]
  tmsalt = [0d]

  d=0d

  for i=0,n-1 do begin
    timespan,dates[i]
    load_barrel_lc,payload,type='ephm'
    get_data,'L_Kp2_' + payload,data=d
    if is_struct(d) then dataL1 = [dataL1,d.y]
    if is_struct(d) then tmsL1 = [tmsL1,d.x]
    store_data,'L_Kp2_' + payload,/delete
    d=0D
    get_data,'L_Kp6_' + payload,data=d
    if is_struct(d) then dataL2 = [dataL2,d.y]
    if is_struct(d) then tmsL2 = [tmsL2,d.x]
    store_data,'L_Kp6_' + payload,/delete
    d=0D
    get_data,'MLT_Kp2_' + payload,data=d
    if is_struct(d) then dataMLT1 = [dataMLT1,d.y]
    if is_struct(d) then tmsMLT1 = [tmsMLT1,d.x]
    store_data,'MLT_Kp2_' + payload,/delete
    d=0D
    get_data,'MLT_Kp6_' + payload,data=d
    if is_struct(d) then dataMLT2 = [dataMLT2,d.y]
    if is_struct(d) then tmsMLT2 = [tmsMLT2,d.x]
    store_data,'MLT_Kp6_' + payload,/delete
    d=0D
    get_data,'alt_'+payload,data=d
    if is_struct(d) then dataalt = [dataalt,d.y]
    if is_struct(d) then tmsalt = [tmsalt,d.x]
    store_data,'alt_' + payload,/delete
    d=0D
  endfor

  ;Remove leading "0"
  if n_elements(dataL1) gt 1 then begin
    dataL1 = dataL1[1:n_elements(dataL1)-1]
    tmsL1 = tmsL1[1:n_elements(tmsL1)-1]
    goo = where(dataL1 eq 9999.)
    if goo[0] ne -1 then dataL1[goo] = !values.f_nan
    store_data,'L_Kp2_' + payload,data={x:tmsL1,y:dataL1}
  endif
  if n_elements(dataL2) gt 1 then begin
    dataL2 = dataL2[1:n_elements(dataL2)-1]
    tmsL2 = tmsL2[1:n_elements(tmsL2)-1]
    goo = where(dataL2 eq 9999.)
    if goo[0] ne -1 then dataL2[goo] = !values.f_nan
    store_data,'L_Kp6_' + payload,data={x:tmsL2,y:dataL2}
  endif
  if n_elements(dataMLT1) gt 1 then begin
    dataMLT1 = dataMLT1[1:n_elements(dataMLT1)-1]
    tmsMLT1 = tmsMLT1[1:n_elements(tmsMLT1)-1]
    store_data,'MLT_Kp2_' + payload,data={x:tmsMLT1,y:dataMLT1}
  endif
  if n_elements(dataMLT2) gt 1 then begin
    dataMLT2 = dataMLT2[1:n_elements(dataMLT2)-1]
    tmsMLT2 = tmsMLT2[1:n_elements(tmsMLT2)-1]
    store_data,'MLT_Kp6_' + payload,data={x:tmsMLT2,y:dataMLT2}
  endif
  if n_elements(dataalt) gt 1 then begin
    dataalt = dataalt[1:n_elements(dataalt)-1]
    tmsalt = tmsalt[1:n_elements(tmsalt)-1]
    store_data,'alt_' + payload,data={x:tmsalt,y:dataalt}
  endif

  ;Remove temporary tplot vars
  store_data,['FSPC1?_','FSPC2_','FSPC3_','FSPC4_','lat_','lon_']+payload,/delete

end
