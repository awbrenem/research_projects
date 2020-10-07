;; Plots the peak vs average value (max of each every 60s)

pro rbsp_survey_fbk_pk_vs_avg_plot,info,ps=ps


	rbspx = 'rbsp' + info.probe

        if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'

	get_data,rbspx + '_fbk_pk',data=pk
	get_data,rbspx + '_fbk_av',data=avg


	bad1 = where(finite(pk.y) eq 0.)
	bad2 = where(finite(avg.y) eq 0.)
	zero1 = where(pk.y eq 0.)
	zero2 = where(avg.y eq 0.)

	;; Get rid of bad values
	if bad1[0] ne -1 then avg.y[bad1] = !values.f_nan
	if bad2[0] ne -1 then pk.y[bad1] = !values.f_nan
	if zero1[0] ne -1 then pk.y[zero1] = !values.f_nan
	if zero1[0] ne -1 then avg.y[zero1] = !values.f_nan
	if zero2[0] ne -1 then pk.y[zero2] = !values.f_nan
	if zero2[0] ne -1 then avg.y[zero2] = !values.f_nan

	xr = [0.4,30]
	yr = [1d0,300]

	xt = 'Avg over 1/8s (' + units + ') each ' + $
             strtrim(floor(info.dt),2)
	yt = 'Pk (' + units + ') each ' + strtrim(floor(info.dt),2)
	title = 'Peak vs Avg (max val of each every 60s) for!C'+$
                info.d0 + ' to ' + info.d1


	!p.multi = [0,0,1]
;	plot,avg.y,pk.y,/ylog,/xlog,xrange=xr,yrange=yr,psym=4,xtitle=xt,ytitle=yt,ystyle=1,xstyle=1,position=aspect(1./1.)	
	plot,avg.y,pk.y,xrange=[0,40],yrange=[0,250],psym=4,$
             xtitle=xt,ytitle=yt,ystyle=1,xstyle=1,position=aspect(1./1.),$
             title=title


	if keyword_set(ps) then begin
		!p.charsize = 0.8
		popen,'~/Desktop/peak_vs_avg_each'+strtrim(floor(info.dt),2)
		plot,avg.y,pk.y,xrange=[0,40],yrange=[0,250],psym=4,$
                     xtitle=xt,ytitle=yt,ystyle=1,xstyle=1,$
                     position=aspect(1./1.),title=title
		pclose
		!p.charsize = 1.3	
	endif


;*********** CHECK THIS *********************
;Prediction: I'm getting a pk/avg ~ 10  for the 1/8 s cadence values
;I'm guessing that this ratio will be 8*4 = 32 times bigger for the 4s cadence values
;*********** CHECK THIS *********************


end
