;Possible wave-modulated hiss in the plasmasphere that lasts for 2 hrs.
;Occurs during apogee on the outer skirts of the PS, though there's no sign that B
;gets out of the PS at this pass;
;Probably a wave modulating the density (7 min period wave)

get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2

store_data,'e12',data={x:v1.x,y:10.*(v1.y - v2.y)}

sum12 = (v1.y + v2.y)/2.



density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)

store_data,'density_actual',data={x:v1.x,y:density}
rbsp_detrend,'density_actual',60.*10.

get_data,'density_actual_detrend',data=dd

dfluc = dd.y/density
store_data,'density_fluc',data={x:dd.x,y:100.*dfluc}


;ALL BALLOON DATA IS IDENTICAL ON THIS DAY
Jan12 B

ylim,[70,76,72],3000,5000
ylim,148,0,40
ylim,147,0,20
ylim,152,-1.5,-1
tplot,[70,76,72,152,154,155,150,149,148,147,82]


ylim,'density_proxy',-2,-1
timespan,'2014-01-12/19:30',3,/hours
tplot_options,'title','from jan12_b_ps_density_striations_hiss.pro'
tplot,['e12','density_proxy_200V','density_proxy','density_actual','density_fluc','rbspb_fbk2_7pk_3','rbspb_fbk2_7pk_3_smoothed','lshell','mlt_centereddipole']


timespan,'2014-01-12'
ylim,'density_proxy',-10,0
tplot,['density_proxy_200V','density_proxy','density_actual','density_fluc','rbspb_fbk2_7pk_3','rbspb_fbk2_7pk_3_smoothed','lshell','mlt_centereddipole','rbspb_efw_b1_fmt_B1_available']
timebar,['2014-01-12/19:30','2014-01-12/22:30']
