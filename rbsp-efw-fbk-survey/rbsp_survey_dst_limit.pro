;; limits the filterbank data to the input range of DST values
;; Overwrites input tplot variable

;; dstL, dstH -> low and high values of DST index
;; tname -> name of tplot variable to limit
;; nhrs -> optional. Set to determine a low res DST index. 
;; 		 This sets the number of hours over which to find the min DST
;; 		 index. A tplot variable the same size as the original DST variable
;; 		 is created but which contains the min DST value over chunks of nhrs
;; 		 for each time. 


pro rbsp_survey_dst_limit,dstL,dstH,tname,info,nhrs=nhrs


  tst = tnames(tname)
  
  for i=0,n_elements(tst)-1 do begin


     get_data,tst[i],data=dd
     get_data,'rbsp' + info.probe + '_dst',data=dst


     if ~keyword_set(nhrs) then begin

        dd2 = dd
        ;; goo = where((dst.y lt dstL) or (dst.y gt dstH))
        goo = where((dst.y ge dstL) and (dst.y le dstH))


        sz = size(dd.y)
        if goo[0] ne -1 then if sz[0] eq 1 then $
           dd2.y[goo] = !values.f_nan else dd2.y[goo,*] = !values.f_nan

        store_data,tst[i],data=dd2

        str_element,info,'dstL',dstL,/add_replace
        str_element,info,'dstH',dstH,/add_replace

     endif else begin
        
        deltat = nhrs*3600. 
        
        nbins = info.ndays * (86400./deltat) ;;number of chunks of size deltat

        dst2 = fltarr(nbins)
        dst2t = fltarr(nbins)

        t0 = time_double(info.d0)
        t1 = time_double(info.d0) + deltat

        for j=0,nbins-1 do begin	
           wh = where((dd.x ge t0) and (dd.x le t1)) 
           dsttmp = dst.y[wh]	
           dsttmpt = dst.x[wh]	
           dst2[j] = max(dsttmp)	
           dst2t[j] = max(dsttmpt)	
           t0 = t0 + deltat
           t1 = t1 + deltat
        endfor


        dsttmp = interpol(dst2,dst2t,dd.x)
        store_data,'dst2',data={x:dd.x,y:dsttmp}
        store_data,'dst_comb',data=['rbsp'+info.probe+'_dst','dst2']
        options,'dst_comb','colors',[0,250]
        tplot,'dst_comb'

        
        dd2 = dd
        ;; goo = where((abs(dsttmp) lt dstL) or (abs(dsttmp) gt dstH))
        goo = where((dsttmp ge dstL) and (dsttmp le dstH))



        sz = size(dd.y)
        if sz[0] eq 1 then if goo[0] ne -1 then $
           dd2.y[goo] = !values.f_nan else if goo[0] ne -1 then dd2.y[goo,*] = !values.f_nan

        store_data,tst[i],data=dd2

        str_element,info,'dstL',dstL,/add_replace
        str_element,info,'dstH',dstH,/add_replace
        str_element,info,'dst_nhrs',nhrs,/add_replace
        
        
     endelse
     
  endfor


end
