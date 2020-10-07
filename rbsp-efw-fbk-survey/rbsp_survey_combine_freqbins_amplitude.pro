
;combine amplitude tplot variables. 

;;For example, combine the following to create the amplitude counts
;;for all the lowerband chorus
;;Files are of type 'rbsp'+info.probe+'_amp_ampdist_pk0102_counts
        ;; fn = ['pk0102_counts',$
        ;;       'pk0203_counts',$
        ;;       'pk0304_counts',$
        ;;       'pk0405_counts']
        ;; rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix='pk0105_counts'




pro rbsp_survey_combine_freqbins_amplitude,info,fn,newsuffix=newsuffix


  get_data,'rbsp'+info.probe+'_amp_ampdist_'+fn[0],data=dd
  times = dd.x
  amps = dd.v
  
                                ;pack all the files into a single array
  vals = replicate(0.,[n_elements(times),n_elements(dd.v),n_elements(fn)])
  for i=0,n_elements(fn)-1 do begin
     get_data,'rbsp'+info.probe+'_amp_ampdist_'+fn[i],data=dd
     vals[*,*,i] = dd.y
  endfor


  vals_final = replicate(0.,n_elements(times),n_elements(dd.v))
  for i=0L,n_elements(times)-1 do begin
     totes = fltarr(n_elements(dd.v))
     for q=0,n_elements(dd.v)-1 do totes[q] = total(vals[i,q,*],/nan)
     vals_final[i,*] = totes
  endfor

  store_data,'rbsp'+info.probe+'_amp_ampdist_'+newsuffix,data={x:times,y:vals_final,v:amps}

  ;;Test (working fine)

  ;; print,total(vals_final,/nan)
  

  ;; get_data,fn[0],data=d0
  ;; get_data,fn[1],data=d1
  ;; get_data,fn[2],data=d2
  ;; get_data,fn[3],data=d3
  
  ;; print,total(d0.y + d1.y + d2.y + d3.y,/nan)


end

