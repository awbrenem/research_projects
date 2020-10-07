;Download BARREL light curves and turn into tplot variables
;Ex, rbsp_load_barrel_lc,['2T','2W'],type='rcnt'

;type -> set to load types of data other than fspc (fast spectral)
;		rcnt -> rate counter (peak detector every 4s)
;		ephm -> ephemeris
;		magn -> magnetometer
;               fspc -> fast spec
;		mspc -> medium rate spec
;		sspc -> slow spec

;The fast spectral data files are by far the largest (~60 MB)
;The rest are on the order of a few MB.


pro rbsp_load_barrel_lc,payloads,type=type,version=version,level=level

  if ~keyword_set(level) then level = 'l2'
  if ~keyword_set(version) then version = 'v05' else begin
     if float(version) lt 10 then version = 'v0' + version
  endelse

  tr = timerange()
  ndays = floor((tr[1]-tr[0])/86400.)


  if ~keyword_set(type) then type = 'fspc'

  path = 'http://barreldata.ucsc.edu/data_products/'
  remote_data_dir = path + version + '/l2/'
  if type eq 'ephm' then remote_data_dir = path + version + '/l2/'
  local_data_dir = '~/data/rbsp/barrel/'


  cdf_leap_second_init

  mission = strmid(payloads[0],0,1)



  for j=0,n_elements(payloads)-1 do begin
     rcnt = 0.
     rcntt = 0D
     lshell2 = 0.
     lshell2t = 0D
     lshell6 = 0.
     lshell6t = 0D
     mlt2 = 0.
     mlt2t = 0D
     mlt6 = 0.
     mlt6t = 0D
     alt = 0.
     altt = 0D
     lat = 0.
     latt = 0D
     long = 0.
     longt = 0D
     lc1 = 0.
     lc1t = 0D

     lc1a = 0.
     lc1at = 0D
     lc1b = 0.
     lc1bt = 0D
     lc1c = 0.
     lc1ct = 0D

     lc2 = 0.
     lc2t = 0D
     lc3 = 0.
     lc3t = 0D
     lc4 = 0.
     lc4t = 0D

     mspc = replicate(0,1,48)
     mspct = 0D

     sspc = replicate(0,1,256)
     sspct = 0D

     for q=0,ndays-1 do begin

        date = time_string(time_double(tr[0])+86400.*q,tformat='YYYYMMDD')
        date2 = strmid(date,2,6)
        dirpath = payloads + '/' + date2 + '/'

        store_data,'PeakDet',/delete
        store_data,'L_Kp?',/delete
        store_data,'MLT_Kp?_T89c',/delete
        store_data,'GPS_???',/delete
        store_data,'FSPC?',/delete
        store_data,'FSPC??',/delete


;; Find out what files are online


        FILE_HTTP_COPY,dirpath[j],url_info=ui,links=links,localdir=local_data_dir,$
                       serverdir=remote_data_dir

        file = 'bar_'+payloads[j]+'_'+level+'_'+type+'_'+date+'_'+version+'.cdf'
        relpathnames = dirpath[j] + file

                                ;download the file
        file_loaded = file_retrieve(relpathnames,remote_data_dir=remote_data_dir,$
                                    local_data_dir=local_data_dir,/last_version)



        if type eq 'rcnt' then begin
           cdf2tplot,files=file_loaded

           goo = 0.
           get_data,'PeakDet',data=goo
           if is_struct(goo) then rcnt = [rcnt,goo.y]
           if is_struct(goo) then rcntt = [rcntt,goo.x]

           store_data,'PeakDet',/delete
        endif

        if type eq 'ephm' then begin

           cdf2tplot,files=file_loaded

           goo = 0.
           get_data,'L_Kp2',data=goo
           if is_struct(goo) then lshell2 = [lshell2,goo.y]
           if is_struct(goo) then lshell2t = [lshell2t,goo.x]

           goo = 0.
           get_data,'L_Kp6',data=goo
           if is_struct(goo) then lshell6 = [lshell6,goo.y]
           if is_struct(goo) then lshell6t = [lshell6t,goo.x]

           goo = 0.
           get_data,'MLT_Kp2_T89c',data=goo
           if is_struct(goo) then lshell6 = [lshell6,goo.y]
           if is_struct(goo) then lshell6t = [lshell6t,goo.x]

           goo = 0.
           get_data,'MLT_Kp6_T89c',data=goo
           if is_struct(goo) then mlt2 = [mlt2,goo.y]
           if is_struct(goo) then mlt2t = [mlt2t,goo.x]

           goo = 0.
           get_data,'MLT_Kp6_T89c',data=goo
           if is_struct(goo) then mlt6 = [mlt6,goo.y]
           if is_struct(goo) then mlt6t = [mlt6t,goo.x]

           goo = 0.
           get_data,'GPS_Alt',data=goo ;; alt in mm
           if is_struct(goo) then alt = [alt,goo.y]
           if is_struct(goo) then altt = [altt,goo.x]

           goo = 0.
           get_data,'GPS_Lat',data=goo
           if is_struct(goo) then lat = [lat,goo.y]
           if is_struct(goo) then latt = [latt,goo.x]

           goo = 0.
           get_data,'GPS_Lon',data=goo
           if is_struct(goo) then long = [long,goo.y]
           if is_struct(goo) then longt = [longt,goo.x]

           store_data,['L_Kp?','MLT_Kp?_T89c','GPS_Alt','GPS_Lat','GPS_Lon'],/delete

        endif


        if type eq 'fspc' then begin

           cdf2tplot,files=file_loaded


           if mission eq '2' or mission eq '3' then begin
              get_data,'FSPC1a',data=goo
              if is_struct(goo) then lc1a = [lc1a,goo.y]
              if is_struct(goo) then lc1at = [lc1at,goo.x]

              get_data,'FSPC1b',data=goo
              if is_struct(goo) then lc1b = [lc1b,goo.y]
              if is_struct(goo) then lc1bt = [lc1bt,goo.x]

              get_data,'FSPC1c',data=goo
              if is_struct(goo) then lc1c = [lc1c,goo.y]
              if is_struct(goo) then lc1ct = [lc1ct,goo.x]
           endif else begin
              goo = 0.
              get_data,'FSPC1',data=goo
              if is_struct(goo) then lc1 = [lc1,goo.y]
              if is_struct(goo) then lc1t = [lc1t,goo.x]
           endelse

           goo = 0.
           get_data,'FSPC2',data=goo
           if is_struct(goo) then lc2 = [lc2,goo.y]
           if is_struct(goo) then lc2t = [lc2t,goo.x]

           goo = 0.
           get_data,'FSPC3',data=goo
           if is_struct(goo) then lc3 = [lc3,goo.y]
           if is_struct(goo) then lc3t = [lc3t,goo.x]

           goo = 0.
           get_data,'FSPC4',data=goo
           if is_struct(goo) then lc4 = [lc4,goo.y]
           if is_struct(goo) then lc4t = [lc4t,goo.x]

           store_data,['FSPC1?','FSPC?'],/delete

        endif


        if type eq 'mspc' then begin

           cdf2tplot,files=file_loaded

           goo = 0.
           get_data,'MSPC',data=goo
           if is_struct(goo) then mspc = [mspc,goo.y]
           if is_struct(goo) then mspct = [mspct,goo.x]

           store_data,'MSPC',/delete
        endif

        if type eq 'sspc' then begin

           cdf2tplot,files=file_loaded

           goo = 0.
           get_data,'SSPC',data=goo
           if is_struct(goo) then sspc = [sspc,goo.y]
           if is_struct(goo) then sspct = [sspct,goo.x]

           store_data,'SSPC',/delete
        endif

        links = ''
     endfor


;;--------------------------------------------------
;;Now store the data in tplot variables
;;--------------------------------------------------

     if type eq 'rcnt' then begin
        nelem = n_elements(rcntt)
        rcnt =  rcnt[0:nelem-1]
        rcntt = rcntt[0:nelem-1]

        store_data,'PeakDet_'+payloads[j],data={x:rcntt,y:double(rcnt)}
        ylim,'PeakDet_'+payloads[j],0,max(rcnt,/nan)
     endif

     if type eq 'ephm' then begin

        nelem = n_elements(lshell2t)

        if nelem ne 1 then begin
           lshell2 = lshell2[1:nelem-1]
           lshell6 = lshell6[1:nelem-1]
           lshell2t = lshell2t[1:nelem-1]
           lshell6t = lshell6t[1:nelem-1]

           mlt2 = mlt2[1:nelem-1]
           mlt6 = mlt6[1:nelem-1]
           mlt2t = mlt2t[1:nelem-1]
           mlt6t = mlt6t[1:nelem-1]

           alt = alt[1:nelem-1]
           altt = altt[1:nelem-1]
           long = long[1:nelem-1]
           longt = longt[1:nelem-1]
           lat = lat[1:nelem-1]
           latt = latt[1:nelem-1]


           store_data,'L_Kp2_'+payloads[j],data={x:lshell2t,y:lshell2}
           ylim,'L_Kp2_'+payloads[j],0,max(lshell2,/nan)

           store_data,'L_Kp6_'+payloads[j],data={x:lshell2t,y:lshell2}
           ylim,'L_Kp6_'+payloads[j],0,max(lshell2,/nan)

           store_data,'MLT_Kp2_'+payloads[j],data={x:mlt2t,y:mlt2}
           ylim,'MLT_Kp2_'+payloads[j],0,max(mlt2,/nan)

           store_data,'MLT_Kp6_'+payloads[j],data={x:mlt6t,y:mlt6}
           ylim,'MLT_Kp6_'+payloads[j],0,max(mlt6,/nan)

           store_data,'alt_'+payloads[j],data={x:altt,y:alt}
           ylim,'alt_'+payloads[j],0,max(alt,/nan)

           store_data,'lat_'+payloads[j],data={x:latt,y:lat}
           ylim,'lat_'+payloads[j],0,max(lat,/nan)

           store_data,'lon_'+payloads[j],data={x:longt,y:long}
           ylim,'lon_'+payloads[j],0,max(long,/nan)

        endif

     endif

     if type eq 'fspc' then begin

        nelem = n_elements(lc2t)

        if nelem ne 1 then begin

           if mission eq '2' or mission eq '3' then begin
              lc1a = lc1a[1:nelem-1]
              lc1b = lc1b[1:nelem-1]
              lc1c = lc1c[1:nelem-1]
              lc1at = lc1at[1:nelem-1]
              lc1bt = lc1bt[1:nelem-1]
              lc1ct = lc1ct[1:nelem-1]

              store_data,'FSPC1a_'+payloads[j],data={x:lc1at,y:lc1a}
              store_data,'FSPC1b_'+payloads[j],data={x:lc1bt,y:lc1b}
              store_data,'FSPC1c_'+payloads[j],data={x:lc1ct,y:lc1c}
           endif else begin
              lc1 = lc1[1:nelem-1]
              lc1t = lc1t[1:nelem-1]

              store_data,'LC1_'+payloads[j],data={x:lc1t,y:lc1}
           endelse

           lc2 = lc2[1:nelem-1]
           lc2t = lc2t[1:nelem-1]
           lc3 = lc3[1:nelem-1]
           lc3t = lc3t[1:nelem-1]
           lc4 = lc4[1:nelem-1]
           lc4t = lc4t[1:nelem-1]

           store_data,'FSPC2_'+payloads[j],data={x:lc2t,y:lc2}
           store_data,'FSPC3_'+payloads[j],data={x:lc3t,y:lc3}
           store_data,'FSPC4_'+payloads[j],data={x:lc4t,y:lc4}

        endif
     endif


     if type eq 'mspc' then begin
        nelem = n_elements(mspct)
        mspc = mspc[1:nelem-1,*]
        mspct = mspct[1:nelem-1]
        store_data,'MSPC_'+payloads[j],data={x:mspct,y:mspc}
        options,'MSPC_'+payloads[j],'spec',1
     endif

     if type eq 'sspc' then begin
        nelem = n_elements(sspct)
        sspc = sspc[1:nelem-1,*]
        sspct = sspct[1:nelem-1]
        store_data,'SSPC_'+payloads[j],data={x:sspct,y:sspc}
        options,'SSPC_'+payloads[j],'spec',1
     endif


  endfor  ;; For each payload


  list = ['Quality','GPS_Lat','GPS_Lon','GPS_Alt','MLT_Kp2','MLT_Kp6','L_Kp2','L_Kp6',$
          'FSPC1','FSPC1a','FSPC1b','FSPC1c','FSPC2','FSPC3','FSPC4','MSPC','SSPC']
  store_data,list,/delete


end
