;Calculates crosscorrelation b/t two tplot variables after normalizing them.
;Returns the delay time corresponding to the max correlation coefficient
;in the considered timerange "maxlag".





pro cross_correlation_normalized_plot,var1,var2,t0z,t1z,$
    mincc=mincc,tshift=tshift,maxcc=maxcc


    if ~keyword_set(mincc) then mincc = 0.

    ;abs value of max possible cc lag to consider.
    maxlag = 60.*40.


;    tinterpol_mxn,var2,var1,/ignore_nans
;    v1 = tsample(var1,[t0z,t1z],times=tms1)
;    v2 = tsample(var2+'_interp',[t0z,t1z],times=tms2)

    v1 = tsample(var1,[t0z,t1z],times=tms1)
    v2 = tsample(var2,[t0z,t1z],times=tms2)


    ;Normalize values
    goo = max(v1,/nan) & v1 /= goo
    goo = max(v2,/nan) & v2 /= goo
    store_data,var1+'_N',tms1,v1
    store_data,var2+'_N',tms1,v2

    store_data,'comb_notshift_'+var1+'_'+var2,data=[var1+'_N',var2+'_N'] & options,'comb_notshift_'+var1+'_'+var2,'colors',[0,250]
;    store_data,'comb_notshift_'+var1+'_'+var2,data=['var1','var2'] & options,'comb_notshift_'+var1+'_'+var2,'colors',[0,250]
    ;tplot,'comb_notshift_'+var1+'_'+var2 & tlimit,t0z,t1z


    sr = 1/(tms1[1] - tms1[0])
;    lag = maxlag*findgen(n_elements(tms1)/2.)/(n_elements(tms1)/2.-1)  ;sec
;    lag = double((lag - max(lag)/2.))

;    good = where(abs(lag/sr) le maxlag)
;    good = where(abs(lag) le maxlag)




;lag = findgen(n_elements(tms1))/(n_elements(tms1)/2.-1)  ;sec
;lag = n_elements(lag)*(lag - max(lag)/2.)

  lag = 4*indgen((n_elements(v1))/2.)
  lag = lag -max(lag)/2.
  good = where(abs(lag) le maxlag)



  ccresult = c_correlate(v1,v2,lag[good])
    ;plot,lag[good]/sr,ccresult



    ;determine time shift for cross-correlation peak
    maxcc = max(ccresult,delayindex)
    tshift = lag[good[delayindex]]/sr
    print,var2
    print,'tshift = ',tshift,' sec for maxcc value of ',maxcc


    ;If the max cc value is too low, then don't timeshift the data
    if maxcc lt mincc then tshift = 0.


end
