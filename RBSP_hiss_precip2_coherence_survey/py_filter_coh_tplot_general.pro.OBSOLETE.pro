
;Take the coherence tplot files (e.g. AB.tplot, which include coherence and phase spectra) and run
;them through a mean filter to get rid of salt/pepper noise. Saves a tplot file with the result.
;e.g. AB.tplot results will be saved as AB_meanfilter.tplot

;Called from coh_analysis_driver.py


;---THINGS THAT WORK
;Mean filter - works very well at reducing salt-pepper noise.
;Filling gaps with amplitude-matched incoherent data.
;---THINGS THAT DON'T WORK
;--bpass.pro (Kyle Murphy's suggested code)
;--Fill gaps with NAN VALUES - Leaves HUGE (day-long) gaps in the larger period spectra.
;--Fill gaps with zero or some other value. Ends up with large correlation.
;--Fill gaps with interp_gap - Ends up with large correlation.



pro py_filter_coh_tplot_general


    print,'In IDL (py_filter_coh_tplot.pro)'
    rbsp_efw_init

    args = command_line_args()
    if KEYWORD_SET(args) then begin
        combo = args[0]
        pre = args[1]
        fspc = args[2]  ;OBSOLETE VARIABLE
        datapath = args[3]
        folder = args[4]
        meanfilterwidth = args[5]
        meanfilterheight = args[6]
    endif else begin
;        combo = 'A_OMNI_press_dyn'
        combo = 'P_PeakDet_thb_peem_ptotQ'
        pre = '2'
        fspc = 1  ;OBSOLETE VARIABLE
        datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
        folder = 'coh_vars_barrelmission2'
        meanfilterwidth = 5.
        meanfilterheight = 5.
    endelse


    meanfilterwidth = float(meanfilterwidth)
    meanfilterheight = float(meanfilterheight)

    ;Restore the file with the unfiltered coherence data (e.g. AB.tplot)
    tplot_restore,filenames=datapath + folder + '/' + combo + '.tplot'



    ;Run results through mean_filter to remove salt/pepper noise
    get_data,'coh_'+combo,data=dd,dlim=dlim,lim=lim
    result = mean_filter(dd.y,meanfilterwidth,meanfilterheight,/nan,/geometric)
    store_data,'coh_'+combo+'_meanfilter',dd.x,result,dd.v,dlim=dlim,lim=lim

    get_data,'phase_'+combo,data=dd,dlim=dlim,lim=lim
    result = mean_filter(dd.y,meanfilterwidth,meanfilterheight,/nan,/geometric)
    store_data,'phase_'+combo+'_meanfilter',dd.x,result,dd.v,dlim=dlim,lim=lim
    zlim,'phase_'+combo+'_meanfilter',0,90,0



    ;save tplot variables
    savevars = ['coh_'+combo+'_meanfilter','phase_'+combo+'_meanfilter']
    tplot_save,savevars,filename=datapath + folder + '/' + combo + '_meanfilter'


end
