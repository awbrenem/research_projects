;py_create_coh_tplot_general.pro
;Create the coherence tplot variables b/t any variables and BARREL precipitation
;Generally called with my script coh_analysis_driver.py


;Variable 1 is balloon data and variable 2 (var2) will be loaded with tplot_restore,
;so the desired input data must be saved into a tplot variable.

  ;-------------------------------------------------------------
  ;Example loading ARTEMIS total pressure:
  ;        datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
  ;         folder_singlepayload2 = 'artemis'
  ;         file_singlepayload2 =  'thb_ptotQ_values_campaign2.tplot'
  ;         tplotvar = 'thb_peem_ptotQ'
  ;-------------------------------------------------------------
  ;-------------------------------------------------------------
  ;OMNI DATA comparison
  ;        datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
  ;        file_singlepayload2 =  'OMNI_sw_values_campaign2.tplot'
  ;        folder_singlepayload2 = 'solar_wind_data'
  ;        tplotvar = 'OMNI_press_dyn'
  ;-------------------------------------------------------------
  ;-------------------------------------------------------------
  ;BARREL MAG data comparison
          ;datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
          ;file_singlepayload2 =  'bar_2xs_l2_magnetometer_20140110000000_20140110014715.cdf'
          ;tplotvar = 'MAG_Z_uncalibrated'
          ;folder_singlepayload2 = 'barrel_mag_data'
  ;-------------------------------------------------------------


pro py_create_coh_tplot_general

    tplot_options,'title','py_create_coh_tplot_general.pro'

    print,'In IDL (py_create_coh_tplot_general)'
    rbsp_efw_init


    args = command_line_args()
    if KEYWORD_SET(args) then begin
        payload = strupcase(args[0])
        pre = args[1]
        fspc = args[2]
        datapath = args[3]
        folder_singlepayload = args[4]
        folder_singlepayload2 = args[5]
        folder = args[6]
        file_singlepayload2 = args[7]
        tplotvar = args[8]
        window_minutes = args[9]
        lag_factor = args[10]
        coherence_multiplier = args[11]
    endif else begin
        payload = 'I'
        pre = '2'
        fspc = '1'

        ;ARTEMIS quantities
        folder_singlepayload2 = 'artemis'
        file_singlepayload2 =  'thb_ptotQ_values_campaign2.tplot'
        tplotvar = 'thb_peem_ptotQ'
        datapath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'

        ;Which BARREL data to select?
        folder_singlepayload = 'folder_singlepayload'
        folder = 'coh_vars_barrelmission2'
        window_minutes = 90.
        lag_factor = 8.
        coherence_multiplier = 2.5
    endelse

    if fspc eq '1' then fspcS = 'fspc'
    if fspc eq '0' then fspcS = 'PeakDet'

    tplot_restore,filenames=datapath + folder_singlepayload2 + '/' + file_singlepayload2

    v2 = tplotvar


    ;Remove NaN gaps. Otherwise coherence calculation is messed up
    get_data,v2,data=dd
    goo = where(finite(dd.y) ne 0.)
    if goo[0] ne -1 then newx = dd.x[goo] else newx = dd.x
    if goo[0] ne -1 then newy = dd.y[goo] else newy = dd.y

    store_data,v2,data={x:newx,y:newy}

    fn1 = 'barrel_'+pre+payload+'_'+fspcS+'_fullmission.tplot'
    v1 = fspcS + '_'+pre+payload

    ;Load single payload data with
    ;--a) flares removed (from py_create_barrel_missionwide_ascii.pro)
    ;--b) NaN gaps removed
    ;--c) ** (NOT USING ANYMORE) gaps filled with uncorrelated data
    load_barrel_data_noartifacts,datapath+folder_singlepayload,fn1,fspcS,pre+payload


    get_data,v1,data=ttmp
    times1 = ttmp.x
    get_data,v2,data=ttmp
    times2 = ttmp.x


    ;Find T1 and T2 based on common times in tplot variables v1 and v2
    T1 = times1[0] > times2[0]
    T2 = times1[n_elements(times1)-1] < times2[n_elements(times2)-1]
    timespan,T1,(T2-T1),/seconds


    options,v1,'psym',0


    ;only retain data with periods > 1 min.
    periodmin = 1.



    ;calculate the cross spectra
    window = 60.*window_minutes   ;seconds
    lag = window/lag_factor
    coherence_time = window*coherence_multiplier

    dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
            new_name='Precip'

    if fspc eq '1' then copy_data,'Precip_coherence','coh_'+payload+'_'+v2
    if fspc eq '0' then copy_data,'Precip_coherence','coh_'+payload+'_PeakDet_'+v2
    if fspc eq '1' then get_data,'coh_'+payload+'_'+v2,data=d
    if fspc eq '0' then get_data,'coh_'+payload+'_PeakDet_'+v2,data=d
    periods = 1/d.v/60.
    goodperiods = where(periods gt periodmin)

    ;Set NaN values to a really low coherence value
    goo = where(finite(d.y) eq 0)
    if goo[0] ne -1 then d.y[goo] = 0.1



    ;Store coherence data so that it plots in a nice way
    if fspc eq '1' then newname = 'coh_'+payload+'_'+v2
    if fspc eq '0' then newname = 'coh_'+payload+'_PeakDet_'+v2
    dat = {x:d.x,y:d.y[*,goodperiods],v:1/d.v[goodperiods]/60.}
    store_data,newname,data=dat
    options,newname,'spec',1
    ylim,newname,5,60,1
    options,newname,'ytitle','Coherence('+payload+'_'+v2+')!C[Period (min)]'

    if fspc eq '1' then copy_data,'Precip_phase','phase_'+payload+'_'+v2
    if fspc eq '0' then copy_data,'Precip_phase','phase_'+payload+'_PeakDet_'+v2
    store_data,['Precip_coherence','dynamic_FFT_?','Precip_phase'],/delete
    if fspc eq '1' then get_data,'phase_'+payload+'_'+v2,data=d
    if fspc eq '0' then get_data,'phase_'+payload+'_PeakDet_'+v2,data=d

    if fspc eq '1' then newname = 'phase_'+payload+'_'+v2
    if fspc eq '0' then newname = 'phase_'+payload+'_PeakDet_'+v2
    dat = {x:d.x,y:d.y[*,goodperiods],v:1/d.v[goodperiods]/60.}
    store_data,newname,data=dat
    options,newname,'spec',1
    options,newname,'ytitle','Phase('+payload+'_'+v2+')!C[Period (min)]'
    ylim,newname,5,60,1
    zlim,newname,-180,180,0

    if fspc eq '1' then filename=datapath + folder + '/' + payload + '_'+v2
    if fspc eq '0' then filename=datapath + folder + '/' + payload + '_PeakDet_'+v2


    ;save tplot variables
    if fspc eq '1' then savevars = ['coh_'+payload+'_'+v2,'phase_'+payload+'_'+v2]
    if fspc eq '0' then savevars = ['coh_'+payload+'_PeakDet_'+v2,'phase_'+payload+'_PeakDet_'+v2]
    if fspc eq '1' then tplot_save,savevars,filename=datapath + folder + '/' + payload + '_'+v2
    if fspc eq '0' then tplot_save,savevars,filename=datapath + folder + '/' + payload + '_PeakDet_'+v2


end
