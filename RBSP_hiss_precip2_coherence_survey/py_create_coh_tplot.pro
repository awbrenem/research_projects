;Create the coherence tplot variables (like AB.tplot)
;NO filtering is done, just creation of the basic coherence tplot variables. 
;
;The two output variables are 
;--coh_AB
;--phase_AB



pro py_create_coh_tplot


    print,'In IDL (py_create_coh_tplot.pro)'
    rbsp_efw_init


    args = command_line_args()
    if KEYWORD_SET(args) then begin
        combo = args[0]
        pre = args[1]
        fspc = args[2]
        datapath = args[3]
        folder_singlepayload = args[4]
        folder = args[5]
        window_minutes = args[6]
        lag_factor = args[7]
        coherence_multiplier = args[8]
    endif else begin
;        combo = 'HQ'
        combo = 'IK'
        pre = '2'
        fspc = 1
        datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
        folder_singlepayload = 'folder_singlepayload'
        folder = 'coh_vars_barrelmission_tst'
        window_minutes = 40.
        lag_factor = 4.
        coherence_multiplier = 2.5
    endelse

    if fspc then fspcS = 'fspc' else fspcS = 'PeakDet'


    p1 = strmid(combo,0,1)
    p2 = strmid(combo,1,1)

    fn1 = 'barrel_'+pre+p1+'_'+fspcS+'_fullmission.tplot'
    fn2 = 'barrel_'+pre+p2+'_'+fspcS+'_fullmission.tplot'

    v1 = fspcS + '_'+pre+p1
    v2 = fspcS + '_'+pre+p2



    ;Load single payload data with
    ;--a) flares removed (from py_create_barrel_missionwide_ascii.pro)
    ;--b) NaN gaps removed
    ;--c) ** (NOT USING ANYMORE) gaps filled with uncorrelated data
    load_barrel_data_noartifacts,datapath+folder_singlepayload,fn1,fspcS,pre+p1
    get_data,fspcS+'_'+pre+p1,data=ttmp
    times1 = ttmp.x
    load_barrel_data_noartifacts,datapath+folder_singlepayload,fn2,fspcS,pre+p2
    get_data,fspcS+'_'+pre+p2,data=ttmp
    times2 = ttmp.x


    ;Find T1 and T2 based on common times in tplot variables v1 and v2
    T1 = times1[0] > times2[0]
    T2 = times1[n_elements(times1)-1] < times2[n_elements(times2)-1]
    timespan,T1,(T2-T1),/seconds



    ;only retain data with periods > 1 min. 
    periodmin = 1.



    ;calculate the cross spectra
    window = 60.*window_minutes   ;seconds
    lag = window/lag_factor
    coherence_time = window*coherence_multiplier

    dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
            new_name='Precip'

    copy_data,'Precip_coherence','coh_'+p1+p2
    get_data,'coh_'+p1+p2,data=d
    periods = 1/d.v/60.
    goodperiods = where(periods gt periodmin)


    ;Set NaN values to a really low coherence value
    goo = where(finite(d.y) eq 0)
    if goo[0] ne -1 then d.y[goo] = 0.1



    ;Store coherence data so that it plots in a nice way
    store_data,'coh_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'coh_'+p1+p2,'spec',1
    ylim,['coh_'+p1+p2,'phase_'+p1+p2],5,60,1
    zlim,'coh_'+p1+p2,0.2,0.9,0
    options,'coh_'+p1+p2,'ytitle','Coherence('+p1+p2+')!C[Period (min)]'

    copy_data,'Precip_phase','phase_'+p1+p2
    store_data,['Precip_coherence','dynamic_FFT_?','Precip_phase'],/delete
    get_data,'phase_'+p1+p2,data=d
    store_data,'phase_'+p1+p2,d.x,d.y[*,goodperiods],1/d.v[goodperiods]/60.
    options,'phase_'+p1+p2,'spec',1
    options,'phase_'+p1+p2,'ytitle','Phase('+p1+p2+')!C[Period (min)]'
    ylim,'phase_'+p1+p2,5,60,1
    zlim,'phase_'+p1+p2,-180,180,0



    ;save tplot variables
    savevars = ['coh_'+p1+p2,'phase_'+p1+p2]
    tplot_save,savevars,filename=datapath + folder + '/' + p1 + p2


end