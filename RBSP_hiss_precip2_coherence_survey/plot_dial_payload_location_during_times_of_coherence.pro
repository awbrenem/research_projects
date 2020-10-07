;Make dial plots of all payloads during times when there is significant coherence. 

pro plot_dial_payload_location_during_times_of_coherence


run = 'coh_vars_barrelmission2'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path1 = path + run

;Restore the tplot file with the combined coherence spectra.
tplot_restore,filenames=path1 + '/' + 'all_coherence_plots_combined_meanfilter.tplot'

tplot,'coh_allcombos_meanfilter'
get_data,'coh_allcombos_meanfilter',data=d

;Total up coherence 
totals = fltarr(n_elements(d.x))
for i=0d,n_elements(d.x)-1 do totals[i] = total(d.y[i,*],/nan)
store_data,'totals',d.x,totals
goo = where(totals ne 0.)

times2 = d.x[goo]
totals2 = totals[goo]
store_data,'totals2',times2,totals2

;Put on a 10 min cadence
t0 = time_double('2014-01-01')
t1 = time_double('2014-01-15')
dt = 60.*60.   ;min
ntimes = (t1 - t0)/dt

newtimes = t0 + dindgen(ntimes)*dt

tinterpol_mxn,'totals2',newtimes,newname='totals2_interp'

get_data,'totals2_interp',data=dd
goo = where(dd.y ge 1.)
times3 = newtimes[goo]
totals3 = dd.y[goo]
store_data,'totals3',times3,totals3

tplot,['totals','totals2','totals3'] & $
;timebar,times3[i],color=250 & $

;Run one time to load all the data
plot_dial_payload_location_specific_time,'2014-01-01/00:00'

;Now run for every subsequent time without loading the data
for i=0,n_elements(times3)-1 do plot_dial_payload_location_specific_time,times3[i],/noload,/ps




;    tplot,'totals2'
;    timebar,times2[i],color=250
;    plot_dial_payload_location_specific_time,times2[i],/noload


;plot_dial_payload_location_specific_time,'2013-01-28/16:00'




end