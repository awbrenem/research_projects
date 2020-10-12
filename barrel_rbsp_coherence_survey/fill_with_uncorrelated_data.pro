;Get rid of data gaps that haven't already been tagged by introducing random data.
;When there's a data gap in one balloon series, then I've put the gap in the second 
;series (e.g. IK) so that the calculation of the coherence isn't screwed up. 
;However, you can get high coherence values if both balloons have linearly (or whatever) 
;interpolated lines. Fill these gaps with random data so that the coherence calculation 
;doesn't show high coherence during these times. 


;1) establish a new time base with 1 tick every "newcadence" sec. 
;2) interpolate to new time base. 
;3) fill gaps with uncorrelated data using Poisson distribution


pro fill_with_uncorrelated_data,timeseries,gapmin,newcadence,timesadded_start=trs,timesadded_end=tre

    if ~keyword_set(gapmin) then gapmin = 4.01
    if ~keyword_set(newcadence) then newcadence = 4.


    get_data,timeseries,data=v1d


    ;identify data gaps
    tshift = v1d.x - shift(v1d.x,1)
    store_data,'tshift',v1d.x,tshift
    goo = where(tshift ge gapmin)
    tbad = replicate(0.,n_elements(tshift))
    tbad[goo] = 1.
    store_data,'tshiftbad',v1d.x,tbad
    options,'tshiftbad','colors',250
    ylim,'tshiftbad',0,2
    options,'tshiftbad','psym',-2
    lastbadtime = v1d.x[where(tbad)]
    firstbadtime = v1d.x[where(tbad)-1]

    ;tplot,[timeseries,'tshift','tshiftbad']
    ;timebar,lastbadtime  ;end locations of bad data
    ;timebar,firstbadtime  ;start locations of bad data



    ;1) establish a new time base with 1 tick every "cadence" seconds
    tmin = min(v1d.x,/nan)
    tmax = max(v1d.x,/nan)
    cadence = newcadence ;4.0 ;sec 
    nelem = (tmax - tmin)/cadence
    newtimes = cadence*dindgen(nelem) + tmin
    ;print,time_string(newtimes[0:20],prec=3)
    ;plot,v1d.x-v1d.x[0]
    ;oplot,newtimes - newtimes[0],color=250
    tinterpol_mxn,timeseries,newtimes,newname=timeseries + '_interp'


    ;For each element in tbad equal to 1, find the start and end of the gap location for the
    ;interpolated data. 
    get_data,timeseries+'_interp',data=d1

    ;firstbadtime and lastbadtime are the start and end times of the good and bad data. 
    ;In b/t these exist the bad (interpolated as straight line) data in the interpolated version. 

    indexstart = fltarr(n_elements(firstbadtime))
    indexend = fltarr(n_elements(firstbadtime))
    for j=0,n_elements(firstbadtime)-1 do begin 
        yoostart = where(d1.x le firstbadtime[j]) 
        indexstart[j] = yoostart[n_elements(yoostart)-1]
        yooend = where(d1.x ge lastbadtime[j])
        indexend[j] = yooend[0] 
        ;;print,time_string(firstbadtime[j]) + ' - ' + time_string(lastbadtime[j]) 
        ;print,time_string(d1.x[indexstart[j]]) + ' - ' + time_string(d1.x[indexend[j]]) 
    endfor

    get_data,timeseries+'_interp',data=v1di
    ;v2di = v1di ;for testing
    ;ttst = time_double('2014-01-08/10:38:00')  ;J=131

    ;Now fill these gaps with uncorrelated data. In order to choose an amplitude and offset for the 
    ;added data, look at the previous chunk of data (referenced by "si" and "ei", which stand for 
    ;start index and end index)
    for j=0,n_elements(indexstart)-2 do begin 
        nelem = double((indexend[j]-indexstart[j])+1) 
        if indexstart[j]-1 ge 0 and indexend[j] ge 0 then ei = indexstart[j]-1 else ei = indexstart[0] 
        if indexstart[j]-10 ge 0 and indexend[j] ge 0 then si = ei-10. else si = ei 
        nelem2 = (ei - si)+1 
        ampavg = max(v1di.y[si:ei],/nan) - min(v1di.y[si:ei],/nan) 
        if ampavg eq 0. then ampavg = 1. 
        if ampavg gt 1d5 then ampavg = 20.
        offset_avg = total(v1di.y[si:ei])/nelem2 - ampavg
    ;    rv = ampavg*randomu(seed,nelem) + offset_avg 
        rv = randomu(seed,nelem,poisson=ampavg) + offset_avg 
        if indexend[j] - indexstart[j] ge 0. then v1di.y[indexstart[j]:indexend[j]] = rv
    endfor

    ;    print,v2di.y[indexstart[j]:indexend[j]]
    ;    print,v1di.y[indexstart[j]:indexend[j]]

    ;print,time_string(v1di.x[indexstart[j]]) + ' - ' + time_string(v1di.x[indexend[j]])
    ;print,indexstart[j],indexend[j],indexend[j]-indexstart[j]
    ;print,si,ei
    store_data,timeseries+'_interp_fixed',data=v1di
    options,timeseries+'_interp_fixed','psym',-2
    ;tplot,[timeseries,timeseries+'_interp',timeseries+'_interp_fixed']
    ;timebar,lastbadtime  ;end locations of bad data
    ;timebar,firstbadtime  ;start locations of bad data



    trs = v1di.x[indexstart]
    tre = v1di.x[indexend]


    ;Delete variables of interest to only this routine. 
    store_data,['tshift','tshiftbad'],/delete


end
