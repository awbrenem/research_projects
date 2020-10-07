;Plot the delay of the max correlation coeff as a function of time
;for the Jan 6th RBSP-A hiss/density/precip event


tplot_options,'title','from jan3_a_delay_plotter.pro'

conjunction = '20140106'
date = '2014-01-06'
payloads = ['2K']
probe = 'a'

;2K is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2K lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,'2K',date,type='rcnt'
rbsp_load_barrel_lc,'2K',date


rbsp_efw_position_velocity_crib,/noplot


rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	

rbsp_load_efw_fbk,probe=probe,type='calibrated',/pt
rbsp_split_fbk,probe



;zoomed in
t0 = time_double('2014-01-06/20:45')
t1 = time_double('2014-01-06/21:10')
tlimit,t0,t1


;ylim,['rbspa_fbk2_7comb_5','rbspa_fbk2_7comb_4','rbspa_fbk2_7comb_3'],0,30
;ylim,'density_proxy',0,0
;ylim,'PeakDet_2K',4d3,1.2d4
;options,'*comb*','panel_size',1


;get_data,'density_proxy',data=sum12
;density = 7583.26*exp(sum12.y/0.38)+94.62*exp(sum12.y/2.3)
;store_data,'density_actual',data={x:sum12.x,y:density}
;options,'density_actual','ytitle','density!Ccm^-3'

;det_time = 60.*20.
;det_time_st = strtrim(floor(det_time/60.),2) + ' min'
;rbsp_detrend,'density_actual',det_time
;rbsp_detrend,['LC1_2K'],60.*5.
;rbsp_detrend,['LC2_2K','LC3_2K','LC4_2K'],60.*0.1
;options,'density_actual_detrend','ytitle','density detrend!C'+det_time_st+'!C'+'[cm-3]'

;;calculate density fluctuation %
;get_data,'density_actual',data=da
;get_data,'density_actual_detrend',data=dad
;den_fluc = 100*dad.y/da.y
;store_data,'density_flucper',data={x:da.x,y:den_fluc}
;options,'density_flucper','ytitle','dn/n!C(density fluc)!C%'


;Smooth values
rbsp_detrend,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3','PeakDet_2K'],60.*0.05


tinterpol_mxn,'rbspa_fbk2_7pk_3_smoothed','PeakDet_2K_smoothed',newname='rbspa_fbk2_7pk_3_smoothed2'
tinterpol_mxn,'rbspa_fbk2_7pk_4_smoothed','PeakDet_2K_smoothed',newname='rbspa_fbk2_7pk_4_smoothed2'


dat = tsample('rbspa_fbk2_7pk_3_smoothed2',[t0,t1],times=t)
store_data,'rbspa_fbk2_7pk_3_smoothed2',data={x:t,y:dat}
dat = tsample('rbspa_fbk2_7pk_4_smoothed2',[t0,t1],times=t)
store_data,'rbspa_fbk2_7pk_4_smoothed2',data={x:t,y:dat}
dat = tsample('PeakDet_2K_smoothed',[t0,t1],times=t)
store_data,'PeakDet_2K_smoothed2',data={x:t,y:dat}

tplot,['rbspa_fbk2_7pk_4_smoothed2','rbspa_fbk2_7pk_3_smoothed2','PeakDet_2K_smoothed2']


get_data,'PeakDet_2K_smoothed2',data=pk
get_data,'rbspa_fbk2_7pk_4_smoothed2',data=fbk
get_data,'rbspa_fbk2_7pk_3_smoothed2',data=fbk2


;get rid of spurious data point
goo = where(pk.y le 0.)
if goo[0] ne -1 then pk.y[goo] = 0.
goo = where(fbk.y le 0.)
if goo[0] ne -1 then fbk.y[goo] = 0.
goo = where(fbk2.y le 0.)
if goo[0] ne -1 then fbk2.y[goo] = 0.



;Normalize the values to be correlated
store_data,'pk2K',data={x:pk.x,y:pk.y/max(pk.y,/nan)}
store_data,'fbk',data={x:fbk.x,y:fbk.y/max(fbk.y,/nan)}
store_data,'fbk2',data={x:fbk2.x,y:fbk2.y/max(fbk2.y,/nan)}

;rbsp_detrend,['fbk','pk2K'],60.*10.


;Overall plot
tplot,['pk2K','fbk','fbk2','rbspa_state_lshell']
timebar,'2014-01-06/' + ['20:29','20:42','20:55','21:04','21:38'],varname='pk2K',thick=2,color=50
timebar,'2014-01-06/' + ['20:26','20:38','20:53','21:07','21:40'],varname='fbk',thick=2,color=50
timebar,'2014-01-06/' + ['20:26','20:38','20:53','21:07','21:40'],varname='fbk2',thick=2,color=50
timebar,'2014-01-06/' + ['20:26','20:53','21:38'],varname='rbspa_state_lshell',thick=2,color=50
timebar,[4],/databar,varname='rbspa_state_lshell',thick=2,color=50
timebar,[5.2],/databar,varname='rbspa_state_lshell',thick=2,color=50
timebar,[4.85],/databar,varname='rbspa_state_lshell',thick=2,color=50


;ylim,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_4_smoothed'],0,25
;tplot,['PeakDet_2K_smoothed2','rbspa_fbk2_7pk_4_smoothed','rbspa_state_lshell']
;timebar,'2014-01-06/' + ['20:38','20:53','21:07','21:40'],varname='rbspa_fbk2_7pk_4_smoothed'
;timebar,'2014-01-06/' + ['20:42','20:55','21:04','21:38'],varname='PeakDet_2K_smoothed2'




get_data,'pk2K',data=pk
get_data,'fbk',data=fbk
get_data,'fbk2',data=fbk2



lag = [reverse(-1*dindgen(500-2)),dindgen(500-2)]

r = c_correlate(pk.y,fbk.y,lag)
r2 = c_correlate(pk.y,fbk2.y,lag2)


dt = pk.x[1] - pk.x[0]

plot,lag,r
plot,lag2,r2


goo = max(r,locc)
max_shift = dt*lag[locc]
goo = max(r2,locc2)
max_shift = dt*lag2[locc2]


;Let's shift the data by this amount
pkshift = pk.y + max_shift
pkshift2 = pk.y + max_shift2

store_data,'pk2K_shift',data={x:pk.x+pkshift,y:pk.y}

tplot,['fbk','fbk2','pk2K','pk2K_shift']

store_data,'comb',data=['fbk','pk2K','pk2K_shift']
options,'comb','colors',[0,50,250]
tplot,'comb'






