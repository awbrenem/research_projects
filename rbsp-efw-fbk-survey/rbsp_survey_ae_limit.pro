;; limits the filterbank data to the input range of AE index
;; Overwrites input tplot variable

;; aeL, aeH -> low and high values of AE index
;; tname -> name of tplot variable(s) to limit
;; nhrs -> optional. Set to determine a low res AE index. 
;; 		 This sets the number of hours over which to find the max AE
;; 		 index. A tplot variable the same size as the original AE variable
;; 		 is created but which contains the max AE value over chunks of nhrs
;; 		 for each time. 



pro rbsp_survey_ae_limit,aeL,aeH,tname,info,nhrs=nhrs


  tst = tnames(tname)

  for i=0,n_elements(tst)-1 do begin


     get_data,tst[i],data=dd
     get_data,'rbsp' + info.probe + '_ae',data=ae

     if ~keyword_set(nhrs) then begin

        dd2 = dd
        goo = where((abs(ae.y) lt aeL) or (abs(ae.y) gt aeH))

        sz = size(dd.y)
        if goo[0] ne -1 then if sz[0] eq 1 then $
           dd2.y[goo] = !values.f_nan else dd2.y[goo,*] = !values.f_nan

        store_data,tst[i],data=dd2


        str_element,info,'aeL',aeL,/add_replace
        str_element,info,'aeH',aeH,/add_replace

     endif else begin
        
        
        dt = nhrs*3600. 

        nbins = info.ndays * (86400./dt)

        ae2 = fltarr(nbins)
        ae2t = fltarr(nbins)

        t0 = time_double(info.d0)
        t1 = time_double(info.d0) + dt

        for j=0,nbins-1 do begin	
           wh = where((dd.x ge t0) and (dd.x le t1)) 
           aetmp = ae.y[wh]	
           aetmpt = ae.x[wh]	
           ae2[j] = max(aetmp)	
           ae2t[j] = max(aetmpt)	
           t0 = t0 + dt
           t1 = t1 + dt
        endfor


        aetmp = interpol(ae2,ae2t,dd.x)
        store_data,'ae2',data={x:dd.x,y:aetmp}
        
        
        
        dd2 = dd
        goo = where((abs(aetmp) lt aeL) or (abs(aetmp) gt aeH))

        sz = size(dd.y)
        if goo[0] ne -1 then if sz[0] eq 1 then dd2.y[goo] = !values.f_nan else dd2.y[goo,*] = !values.f_nan

        store_data,tst[i],data=dd2

        str_element,info,'aeL',aeL,/add_replace
        str_element,info,'aeH',aeH,/add_replace
        str_element,info,'ae_nhrs',nhrs,/add_replace
        
        
     endelse

  endfor

end
