;Plot precipitation rates vs MLT sector to see if the reason for the post-noon
;coherence is because the precipitation increases. 


pro plot_precip_rates_by_mlt_sector

rbsp_efw_init
tplot_options,'title','plot_precip_rates_by_mlt_sector.pro'

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/coh_vars_barrelmission2/'
fn = 'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'
tplot_restore,filenames=path+fn

;all_coherence_plots_combined_meanfilter.tplot
    

timespan,'2014-01-01',45,/days

bal = ['W','I','L','X','T','A','B','O','P','E']

for i=0,n_elements(bal)-1 do load_barrel_lc,'2'+bal[i],type='ephm'

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/' + 'folder_singlepayload/'




;Restore single payload FSPC files
for i=0,n_elements(bal)-1 do begin $
fn = 'barrel_2'+bal[i]+'_fspc_fullmission.tplot' & $
tplot_restore,filenames=path + fn


;Remove select times when I know the
;coherence is caused by SW event not related to post-noon entry. 
;Times to remove (coherence caused by AE/GOES spikes)
;jan 4: 10-14 
;jan 5: 6-17 
;jan 10: 14-18 
;get_data,'fspc_2'+bal[i],t,d & $
;goo = where((t ge time_double('2014-01-04/10:00')) and (t le time_double('2014-01-04/14:00'))) & $ 
;if goo[0] ne -1 then d[goo] = 0. & $
;store_data,'fspc_2'+bal[i],t,d & $
;goo = where((t ge time_double('2014-01-05/06:00')) and (t le time_double('2014-01-05/17:00'))) & $ 
;if goo[0] ne -1 then d[goo] = 0. & $
;store_data,'fspc_2'+bal[i],t,d & $
;goo = where((t ge time_double('2014-01-10/14:00')) and (t le time_double('2014-01-10/18:00'))) & $ 
;if goo[0] ne -1 then d[goo] = 0. & $
;store_data,'fspc_2'+bal[i],t,d




rmin = indgen(6)*4.
rmax = rmin + 4.
titles = strtrim(rmin,2)+'-'+strtrim(rmax,2)

xrange = [time_double('2014-01-01'),time_double('2014-02-12')]


!p.multi = [0,2,3]
!p.charsize = 2.2
for j=0,11 do begin $ 
    for i=0,n_elements(bal)-1 do begin & $
    rbsp_detrend,'fspc_2'+bal[i],5.*60. & $
    get_data,'MLT_Kp2_2'+bal[i],t,mlt  & $
    get_data,'L_Kp2_2'+bal[i],t,l  & $
    get_data,'fspc_2'+bal[i]+'_smoothed',t,d & $
    goo = where((mlt ge rmin[j]) and (mlt le rmax[j])) & $
    toffset = t[goo[0]] & $
    if i eq 0 then plot,t[goo],d[goo],title=titles[j],yrange=[0,100],xrange=xrange,ylog=0,ystyle=1,xstyle=1 else oplot,t[goo],d[goo]
 
    if i eq 0 then plot,t[goo],d[goo],title=titles[j],yrange=[30,100],xrange=xrange,ylog=1,ystyle=1,xstyle=1 else oplot,t[goo],d[goo]


    goo = where((mlt ge rmin[j]) and (mlt le rmax[j]) and (l ge 1.) and (l le 15.)) & $


goo = where((mlt ge 10.) and (mlt le 12.))
oplot,d[goo],color=50
goo = where((mlt ge 8.) and (mlt le 10.))
oplot,d[goo],color=100
goo = where((mlt ge 6.) and (mlt le 8.))
oplot,d[goo],color=130

;-----------------------------









