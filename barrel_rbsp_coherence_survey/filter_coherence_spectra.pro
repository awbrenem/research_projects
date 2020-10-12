;Take the coherence spectra from py_create_coh_tplot.pro and filter them to remove 
;values based on some or all of the following: 

;Remove data if (each of these is optional): 
;---one or both of the payloads are not on a defined Lshell 
;---the L or MLT difference is greater than some maximum value. 
;---the coherence falls below a threshold value 
;---the high coherence values are too bursty -- i.e. too salt and peppery. I do this 
;   by comparing average values (from periodmin to periodmax) for every time to those 
;   calculated using a sliding window. If the average coherence in, say 5 consecutive time 
;   stamps is close to the average value for a single time stamp then the coherence is "persistent", 
;   and less likely to be a salt/pepper fluke. 
;---The phase angle of the two payloads exceeds some min value
;---NEW** Remove coherence if the FSPC signals on each balloon aren't significantly above DC background

;filter_coherence_spectra,'coh_KL_meanfilter','lshell_2K','lshell_2L','MLT_2K','MLT_2L'

pro filter_coherence_spectra,coh_tplotvar,$
    lshell1,lshell2,$
    mlt1,mlt2,$
    mincoh,$
    periodmin,periodmax,$
    max_mltdiff,$
    max_ldiff,$
    fspc1,$
    fspc2,$
    phase_tplotvar=phase_tplotvar,$
    ratiomax=ratiomax,$
    anglemax=anglemax,$
    winsize=winsize,$
    remove_lshell_undefined=remove_lshell_undefined,$
    remove_mincoh=remove_mincoh,$
    remove_slidingwindow=remove_slidingwindow,$
    remove_max_ldiff=remove_max_ldiff,$
    remove_max_mltdiff=remove_max_mltdiff,$
    remove_anglemax=remove_anglemax,$
    remove_lowsignal_fluctuation=remove_lowsignal_fluctuation



    if ~keyword_set(ratiomax) then ratiomax = 1.05 
    if ~keyword_set(winsize) then winsize = 5. 
    if ~keyword_set(max_ldiff) then max_ldiff = 30.
    if ~keyword_set(anglemax) then anglemax = 90.

    copy_data,coh_tplotvar,coh_tplotvar+'_orig'

    get_data,coh_tplotvar,data=d,dlim=dlim,lim=lim
    times = d.x

    ntimes = n_elements(times)
    nperiods = n_elements(d.v)

    ;Use IDL's built-in interpolation here (tinterpol_mxn can have occasional problems)
    ;make sure everything's on the same time cadence
    get_data,lshell1,data=ddd & ytst = interpol(ddd.y,ddd.x,times,/nan) & store_data,lshell1+'_interpTMP',times,ytst
    get_data,lshell2,data=ddd & ytst = interpol(ddd.y,ddd.x,times,/nan) & store_data,lshell2+'_interpTMP',times,ytst
    get_data,mlt1,data=ddd & ytst = interpol(ddd.y,ddd.x,times,/nan) & store_data,mlt1+'_interpTMP',times,ytst
    get_data,mlt2,data=ddd & ytst = interpol(ddd.y,ddd.x,times,/nan) & store_data,mlt2+'_interpTMP',times,ytst


    rbsp_efw_init

    flag_lshell = bytarr(ntimes)
    flag_mlt = bytarr(ntimes)
    flag_ratio = bytarr(ntimes)
    flag_signalsize = bytarr(ntimes)

    periods = d.v
    t0 = min(d.x,/nan)
    t1 = max(d.x,/nan)
    goodperiods = where((d.v ge periodmin) and (d.v le periodmax))




    ;------------------------------------------------
    ;Filter out coherence when the FSPC signal has insignificant
    ;variations (in 10-60 min periods, for example) relative to 
    ;the time-varying "DC" levels (e.g. diurnal variation)
    ;------------------------------------------------

    if keyword_set(remove_lowsignal_fluctuation) then begin


        ;Find the smoothed "DC" signal
        rbsp_detrend,[fspc1,fspc2],3600.*4. 

        dif_data,fspc1,fspc1+'_smoothed',newname='diff1'
        dif_data,fspc2,fspc2+'_smoothed',newname='diff2'

;        min_diff_level = 30
        min_diff_level = 5

        get_data,'diff1',goo,doo & store_data,'diff1',goo,abs(doo)
        store_data,'significance_line1',goo,replicate(min_diff_level,n_elements(goo))
        get_data,'diff2',goo,doo & store_data,'diff2',goo,abs(doo)
        store_data,'significance_line2',goo,replicate(min_diff_level,n_elements(goo))
        options,'significance_line?','colors',[250,0]
        store_data,'diff1comb',data=['significance_line1','diff1']
        store_data,'diff2comb',data=['significance_line2','diff2']
        ylim,'diff?comb',0,10

        rbsp_detrend,'diff?',60.*2.
        store_data,'diff1_smoothed_comb',data=['significance_line1','diff1_smoothed']
        store_data,'diff2_smoothed_comb',data=['significance_line2','diff2_smoothed']

        ylim,'diff?_smoothed_comb',0,10


;        tplot,[coh_tplotvar,fspc1,fspc1+'_smoothed','diff1comb','diff1_smoothed_comb',$
 ;           fspc2,fspc2+'_smoothed','diff2comb','diff2_smoothed_comb']




        get_data,coh_tplotvar,data=dd,dlim=dlim,lim=lim
        get_data,'diff1_smoothed',data=dif1
        get_data,'diff2_smoothed',data=dif2

        tmpp = rbsp_sample_rate(dd.x,out_med_avg=med)
        speriod = 1/med[1]  ;sample period in seconds
        numperiods = 8. 
        for j=0,n_elements(dd.x)-1 do begin

            ;grab chunk of time in coherence spectrum
            goot = where((dd.x ge dd.x[j]-speriod*numperiods) and (dd.x le dd.x[j]+speriod*numperiods))
            if goot[0] ne -1 then begin 

                goot = dd.x[goot]

                ;Find times in FSPC vars that fall within coherence time chunk
                goo1 = where((dif1.x ge min(goot,/nan)) and (dif1.x le max(goot,/nan)))
                goo2 = where((dif2.x ge min(goot,/nan)) and (dif2.x le max(goot,/nan)))

                if goo1[0] ne -1 and goo2[0] ne -1 then begin 
                    goody1 = where(dif1.y[goo1] ge min_diff_level)
                    goody2 = where(dif2.y[goo2] ge min_diff_level)
                    if total(goody1) eq -1 or total(goody2) eq -1 then flag_signalsize[j] = 1
                endif
            endif
        endfor
    endif




    ;------------------------------------------------
    ;Filter out coherence values below this threshold
    ;NOTE: I'm not flagging these values b/c this flag array 
    ;would be 2d instead of 1d. Just remove these values here. 
    ;------------------------------------------------

    if keyword_set(remove_mincoh) then begin 
        goo = where(d.y le mincoh)
        if goo[0] ne -1 then d.y[goo] = !values.f_nan
    endif


    ;------------------------------------------------
    ;Filter out coherence values when the max phase angle exceeds anglemax
    ;NOTE: I'm not flagging these values b/c this flag array 
    ;would be 2d instead of 1d. Just remove these values here. 
    ;-------------------------------------------------

    if keyword_set(remove_anglemax) then begin 
        get_data,phase_tplotvar,data=p
        boo = where(abs(p.y) ge anglemax)
        if boo[0] ne -1 then d.y[boo] = !values.f_nan
    endif


    ;--------------------------------------------------------
    ;Remove values when one of the two Lshells isn't defined, or when the 
    ;Lshell difference is greater than a certain max value
    ;--------------------------------------------------------

    if keyword_set(remove_lshell_undefined) then begin 
        dif_data,lshell1+'_interpTMP',lshell2+'_interpTMP',newname='ldiff1'
        options,'ldiff1','colors',120
        options,'ldiff1','psym',2
        get_data,'ldiff1',data=ddd
        yoo = where(finite(ddd.y) eq 0.)
        if yoo[0] ne -1 then flag_lshell[yoo] = 1
    endif


    if keyword_set(remove_max_ldiff) then begin 
        dif_data,lshell1+'_interpTMP',lshell2+'_interpTMP',newname='ldiff1'
        options,'ldiff1','colors',120
        options,'ldiff1','psym',2
        get_data,'ldiff1',data=ddd
        yoo = where(abs(ddd.y) ge max_ldiff)
        if yoo[0] ne -1 then flag_lshell[yoo] = 1
    endif


    ;---------------------------------------------------------
    ;Remove values of delta-MLT is greater than a pre-defined max value. 
    ;Careful when calculating delta-MLT. Need to go both ways around the dial and grab 
    ;the smaller of the two delta-MLTs. 
    ;---------------------------------------------------------


    if keyword_set(remove_max_mltdiff) then begin 

        calculate_angle_difference,mlt1+'_interpTMP',mlt2+'_interpTMP' ;,newname=newname

        options,mlt1+'_interpTMP-'+mlt2+'_interpTMP','ytitle','MLTdiff!C[hrs]'
        options,mlt1+'_interpTMP-'+mlt2+'_interpTMP','psym',2

        get_data,mlt1+'_interpTMP'+'-'+mlt2+'_interpTMP',data=ddd
        yoo = where((abs(ddd.y) gt max_mltdiff) or (finite(ddd.y) eq 0.))
        if yoo[0] ne -1 then flag_mlt[yoo] = 1

    endif


    ;--------------------------------------------------------------------------
    ;Use the technique of comparing the averaged value over all the goodperiods 
    ;to the sliding window average. This allows removal of brief periods of high 
    ;coherence
    ;--------------------------------------------------------------------------


    if keyword_set(remove_slidingwindow) then begin 

        ;--find the average values without the sliding window
        average_nosliding = fltarr(n_elements(d.x))
        for j=0,n_elements(d.x)-1 do average_nosliding[j] = total(d.y[j,goodperiods],/nan)/n_elements(goodperiods)
        store_data,'avg_nosliding',d.x,average_nosliding

        ;--find the average values using the sliding window 
        average_sliding = fltarr(n_elements(d.x))
        for j=0,n_elements(d.x)-1 do begin 
            jmin = j-winsize > 0
            jmax = j+winsize < n_elements(d.x)-1
            totalelements = n_elements(d.y[jmin:jmax,goodperiods])
            average_sliding[j] = total(d.y[jmin:jmax,goodperiods],/nan)/totalelements
        endfor
        store_data,'avg_sliding',d.x,average_sliding


        ;--Take ratio of the normal to sliding values. This will help us weed out small peaks in coherence.
        ratio = average_nosliding/average_sliding
        store_data,'ratio',d.x,ratio
        ratioline = replicate(ratiomax,n_elements(ratio))
        store_data,'ratioline',d.x,ratioline
        options,'ratioline','linestyle',2
        store_data,'ratiocomb',data=['ratio','ratioline']

        ;--Filter out values with excessively high ratios
        ;get_data,'coh_'+combos[i]+'_meanfilter',data=dg,dlim=dlim,lim=lim
        uoo = where((ratio gt ratiomax) or (finite(ratio) eq 0.) or (ratio eq 0.))
        if uoo[0] ne -1 then flag_ratio[uoo] = 1

    endif



    flags_all = flag_lshell > flag_mlt > flag_ratio > flag_signalsize

;    store_data,'flag_mincoh',times,flag_mincoh
    store_data,'flag_signalsize',times,flag_signalsize
    store_data,'flag_lshell',times,flag_lshell+0.1
    store_data,'flag_mlt',times,flag_mlt+0.05
    store_data,'flag_ratio',times,flag_ratio-0.05
    store_data,'flag_allflags',times,flags_all

    options,'flag_*','thick',1

    ;combine all flag variables into one tplot variable
    store_data,'flag_comb',data='flag_'+['signalsize','lshell','mlt','ratio']
    options,'flag_comb','ytitle','All flags!Csignalsize(black)!Cratio(blue)!CLshell(orange)!CMLT(red)'



    ylim,'*flag*',-0.2,1.2
    options,'*flag*','psym',0
    options,'*flag*','panel_size',0.4
    options,'flag_comb','panel_size',1
    options,'flag_lshell','color',210
    options,'flag_mlt','color',240
    options,'flag_ratio','color',75
    options,'flag_signalsize','color',0


    ;------------------------------------------------
    ;Now remove all bad data 
    ;------------------------------------------------

    flags_all_remover = abs(flags_all-1)

    get_data,coh_tplotvar,data=dtmp

    for qq=0,n_elements(dtmp.v)-1 do dtmp.y[*,qq] = reform(dtmp.y[*,qq])*flags_all_remover
    boo = where(dtmp.y eq 0.)
    if boo[0] ne -1 then dtmp.y[boo] = !values.f_nan
    store_data,coh_tplotvar,data={x:times,y:dtmp.y,v:dtmp.v},dlim=dlim,lim=lim

    if keyword_set(remove_slidingwindow) then begin
        get_data,'avg_sliding',data=d
        store_data,'avg_sliding',data={x:times,y:d.y*flags_all_remover}
        get_data,'avg_nosliding',data=d
        store_data,'avg_nosliding',data={x:times,y:d.y*flags_all_remover}
    endif




    t0tmp = min(times,/nan)
    t1tmp = max(times,/nan)

    store_data,'combtest',data=['avg_nosliding','avg_sliding']
    options,'combtest','colors',[0,250]
    options,'combtest','panel_size',0.5
    ylim,'combtest',0,0.5

    timespan,t0tmp,t1tmp-t0tmp,/sec
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar,'combtest','*flag*']


    ylim,[lshell1+'_interpTMP',lshell2+'_interpTMP',mlt1+'_interpTMP',mlt2+'_interpTMP'],0,0

    ;Various test plots 
    ;**Test Lshell removal
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar,lshell1+'_interpTMP',lshell2+'_interpTMP','ldiff1','flag_lshell']
    ;**Test MLT removal 
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar,mlt1+'_interpTMP',mlt2+'_interpTMP',mlt1+'_interpTMP-'+mlt2+'_interpTMP','flag_mlt']
    ;**Test ratio removal    
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar,'combtest','ratiocomb','flag_ratio']
    ;**Test mincoherence removal
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar]
    ;**Test small FSPC signalsize removal 
;    tplot,[coh_tplotvar+'_orig',coh_tplotvar]

    store_data,['*interpTMP-MLT*',lshell1+'_interpTMP',lshell2+'_interpTMP',mlt1+'_interpTMP',mlt2+'_interpTMP'],/delete


end

