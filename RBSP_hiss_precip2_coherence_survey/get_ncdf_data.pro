function get_ncdf_data, file, field_var = field_var, help=help, verbose=verbose

  ;open net cdf file
  fileID = ncdf_open(file)
  ;figure out whats in the file
  file_IQ = ncdf_inquire(fileID)
  
  ;if help is active then print all the variables in 
  ; the net cdf file
  if keyword_set(help) then begin
    for w = 0L, file_IQ.nvars-1 do begin
      
      varinq = ncdf_varinq(fileID,w)
      print, 'Variable ID: ',strtrim(w,2),' ', varinq.name
      for i =0L, (varinq.natts)-1 do begin
        attname = ncdf_attname(fileID,w,i)
        ncdf_attget,fileID,varinq.name,attname,x
        print, attname+': '+string(x)
      end
      print, '=========='
    endfor
    
    print, ' '
    print, ' '
    return, 0
  endif else begin
    
    ;if you know what field variable you want get it
    if keyword_set(field_var) then field_var = field_var else field_var = 0
    
    varinq = ncdf_varinq(fileID,field_var)
    ncdf_varget,fileID,field_var,data
    ;if verbose is set then print the info about
    ; the variable
    if keyword_set(verbose) then begin
      print, '=========='
      print, varinq.name
      for i =0L, (varinq.natts)-1 do begin
        attname = ncdf_attname(fileID,field_var,i)
        ncdf_attget,fileID,varinq.name,attname,x
        print, attname+': '+string(x)
      end
    endif    
     
    r_d = {name:varinq.name,data:data}
  
    return, r_d
  endelse
end