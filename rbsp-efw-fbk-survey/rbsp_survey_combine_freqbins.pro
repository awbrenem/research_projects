;;combine various tplot values like
;;'rbsp'+info.probe+'_fbk_pk0102' and 'rbsp'+info.probe+'_fbk_pk0203'
;;into a single tplot variable like 
;;'rbsp'+info.probe+'_fbk_pk0105'


        ;; fn = ['0102',$
        ;;       '0203',$
        ;;       '0304',$
        ;;       '0405']
        ;; rbsp_survey_combine_freqbins,info,fn,newsuffix='0105'


pro rbsp_survey_combine_freqbins,info,fn,newsuffix=newsuffix


  
  get_data,'rbsp'+info.probe+'_fbk_pk'+fn[0],data=dd
  times = dd.x

  ;pack all the files into a single array
  vals_pk = replicate(0.,[n_elements(times),n_elements(fn)])
  valsn_pk = replicate(0.,[n_elements(times),n_elements(fn)])
  vals_av = replicate(0.,[n_elements(times),n_elements(fn)])
  valsn_av = replicate(0.,[n_elements(times),n_elements(fn)])
  for i=0,n_elements(fn)-1 do begin
     get_data,'rbsp'+info.probe+'_fbk_pk'+fn[i],data=dd
     vals_pk[*,i] = dd.y
     get_data,'rbsp'+info.probe+'_nfbk_pk'+fn[i],data=dd
     valsn_pk[*,i] = dd.y
     get_data,'rbsp'+info.probe+'_fbk_av'+fn[i],data=dd
     vals_av[*,i] = dd.y
     get_data,'rbsp'+info.probe+'_nfbk_av'+fn[i],data=dd
     valsn_av[*,i] = dd.y
  endfor


  vals_pk_final = replicate(0.,n_elements(times))
  valsn_pk_final = replicate(0.,n_elements(times))
  vals_av_final = replicate(0.,n_elements(times))
  valsn_av_final = replicate(0.,n_elements(times))
  for i=0L,n_elements(times)-1 do begin

     ;;Find the overall max value
     maxv = 0.
     for j=0L,n_elements(fn)-1 do maxv = maxv > vals_pk[i,j] 
     vals_pk_final[i] = maxv     
     maxv = 0.
     for j=0L,n_elements(fn)-1 do maxv = maxv > vals_av[i,j] 
     vals_av_final[i] = maxv     

     ;;tabulate the total counts
     valsn_pk_final[i] = total(valsn_pk[i,*],/nan)
     valsn_av_final[i] = total(valsn_av[i,*],/nan)
  endfor


  store_data,'rbsp'+info.probe+'_fbk_pk'+newsuffix,data={x:times,y:vals_pk_final}
  store_data,'rbsp'+info.probe+'_nfbk_pk'+newsuffix,data={x:times,y:valsn_pk_final}
  store_data,'rbsp'+info.probe+'_fbk_av'+newsuffix,data={x:times,y:vals_av_final}
  store_data,'rbsp'+info.probe+'_nfbk_av'+newsuffix,data={x:times,y:valsn_av_final}


;;Testing****
;; print,total(valsn_final,/nan)
;; get_data,'rbsp'+info.probe+'_fbk_'+fn[0],data=d0
;; get_data,'rbsp'+info.probe+'_fbk_'+fn[1],data=d1
;; get_data,'rbsp'+info.probe+'_fbk_'+fn[2],data=d2
;; get_data,'rbsp'+info.probe+'_fbk_'+fn[3],data=d3
;; print,total(d0.y + d1.y + d2.y + d3.y,/nan)

;; stop

end

