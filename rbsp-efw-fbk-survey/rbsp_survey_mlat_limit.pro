;;limits the filterbank data to the input range of magnetic latitudes
;;Overwrites input tplot variable

pro rbsp_survey_mlat_limit,mlatL,mlatH,tname,info

  tst = tnames(tname)

  for i=0,n_elements(tst)-1 do begin

     get_data,tst[i],data=dd
     get_data,'rbsp' + info.probe + '_mlat',data=mlat


     dd2 = dd
     goo = where((abs(mlat.y) lt mlatL) or (abs(mlat.y) gt mlatH))

     sz = size(dd.y)
     if goo[0] ne -1 then if sz[0] eq 1 then $
        dd2.y[goo] = !values.f_nan else dd2.y[goo,*] = !values.f_nan

     store_data,tst[i],data=dd2


  endfor


  str_element,info,'mlatL',mlatL,/add_replace
  str_element,info,'mlatH',mlatH,/add_replace


end
