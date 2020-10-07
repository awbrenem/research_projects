function get_goes_ncdf, file, mag_2 = mag_2, verbose = verbose

  
  
  fileID = ncdf_open(file)
  
  if keyword_set(mag_2) then mag_2 = 8 else mag_2 = 0
  
  ;add west longitude and inclination
  
  ;look at the time attributes
  field_var = 3
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,time
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;look at the magnetic field attributes and get magnetic field data
  ;quality
  field_var = 32+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HP_Q
   if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;data
  field_var = 33+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HP
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;look at the magnetic field attributes and get magnetic field data
  ;quality
  field_var = 34+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HE_Q
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;data
  field_var = 35+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HE
   if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;look at the magnetic field attributes and get magnetic field data
  ;quality
  field_var = 36+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HN_Q
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;data
  field_var = 37+mag_2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,HN
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  ;west_long
  field_var = 1
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,w_lon
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  
  ;inclination
  field_var = 2
  varinq = ncdf_varinq(fileID,field_var)
  ncdf_varget,fileID,field_var,inclination
  if keyword_set(verbose) then begin
    print, varinq.name
    for i =0L, (varinq.natts)-1 do begin
      attname = ncdf_attname(fileID,field_var,i)
      ncdf_attget,fileID,varinq.name,attname,x
      print, attname+': '+string(x)
    end
    print, '--------------'
  endif
  
  t = time_struct((time-time[0])/1000.)
  time_day = t.sod/3600.
  
  r_data = {name:'goes_data', time_linux:time/1000.,hp:hp,hp_Q:hp_Q,hn:hn,hn_Q:hn_Q,he:he,he_Q:he_Q, tod:time_day, west_long:w_lon, inclination:inclination}
  
  ncdf_close, fileID
  
  return, r_data

end
