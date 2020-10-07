
;plot_mageis_electron_populations at various energies and 
;compare to the total coherence plot. 

;Goal is to see how total e- flux available effects the coherence the 
;balloons see.



pre = '2'

rbsp_efw_init
yellow_to_orange

tplot_options,'title','plot_mageis_electron_populations.pro'

run = 'coh_vars_barrelmission2'
single = 'folder_singlepayload'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path1 = path + run
path2 = path + single
path3 = path + 'barrel_ephemeris'



;Create common time base 
t0 = time_double('2014-01-01/00:00')
t1 = time_double('2014-02-15/00:00')

timespan,t0,(t1-t0),/seconds

ndays = (t1-t0)/86400

eflux = fltarr(1.,21)
times = 0d

;pitch angles (deg)
;print,d.v1
pa = 5.  ;90 deg


for i=0,ndays-1 do begin $
    timespan,t0 + 86400*i,/days & $
    rbsp_load_ect_l3,'a','mageis' & $
    get_data,'rbspa_ect_mageis_L3_FEDU',data=d  & $
    eflux = [eflux,d.y[*,0:20,pa]]  & $  ;e- flux at assoc energy/pa
    times = [times,d.x]


store_data,'eflux',times,eflux
ylim,'eflux',1d0,1d5,1

split_vec,'eflux',suffix=[strtrim(floor(d.v2[0:20]),2)]

ylim,'eflux*',1d1,5d5,1



copy_data,'eflux','eflux_lin'
ylim,'eflux_lin',0,5d4,0

;Grab the combined coherence plot 
tplot_restore,filenames=path1+'/'+'all_coherence_plots_combined_meanfilter.tplot'


;Plot final results
tplot,['eflux','eflux_lin','coh_allcombos_meanfilter']


tplot,['eflux33',$
        'eflux80',$
        'eflux143',$
        'eflux235',$
        'eflux597',$
        'eflux1079',$
        'coh_allcombos_meanfilter']

end