;Plot the raytracing results produced from
;crib_raytrace_scenario1_costream_n=1.pro
;crib_raytrace_scenario3_landau_n=0.pro
;crib_raytrace_scenario2_counterstream_n=1.pro

;Rays are simulated over a wide range of L, but lines are only plotted
;when there are ray values at L=5, the location of FIREBIRD FU-4 near 19:44 UT
;on Jan 20, 2016 during the chorus/uB event.
;When rays are highlighted (bold lines) that means that energies from 250-850 keV
;are scattered, and furthermore that they arrive at FIREBIRD with a total delta-time
;defined by maxtdiff

;See also plot_raytrace_results_costream.pro


path='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/raytrace_files/'
;fn = 'counterstream_1800Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1700Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1600Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1500Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1400Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1300Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1200Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1100Hz_L=3.4-7_nrays=80.idl'
;fn = 'counterstream_1000Hz_L=3.4-7_nrays=80.idl'


fq = ['1000','1100','1200','1300','1400','1500','1600','1700','1800']
fn = 'counterstream_'+fq+'Hz_L=3.4-7_nrays=80'
fn2 = fn + '.idl'


;popen,'~/Desktop/' + 'counterstream_1000-1800Hz_L=3.4-7_nrays=80.idl'


for yy=0,n_elements(fq)-1 do begin


restore,path+fn2[yy]

nrays = n_elements(allLvals)

;Filter based on max allowable time difference b/t arrival of 250 keV and 850 keV
tdiff = fltarr(nrays)
ediff = fltarr(nrays)
maxtdiff = 100.


;--------------------------------------------------------
;Interpolate values to have much better energy resolution
;--------------------------------------------------------

;new x-axis has 10x the resolution of old one
newxvals = float(max(mlatrange)-min(mlatrange))*indgen(10.*90)/(10.*90.-1) + min(mlatrange)

;create interpolated arrays
energiesLi = fltarr(n_elements(newxvals),nrays)
totaltimeLi = fltarr(n_elements(newxvals),nrays)
lval0_finLi = fltarr(n_elements(newxvals),nrays)
thk_finLi = fltarr(n_elements(newxvals),nrays)
thk0_finLi = fltarr(n_elements(newxvals),nrays)

;Same as above but only where the resonance energies falls b/t 250-850 keV
energiesLi2 = energiesLi
totaltimeLi2 = energiesLi
lval0_finLi2 = energiesLi
thk_finLi2 =  energiesLi
thk0_finLi2 = energiesLi


;Remove zero values
goo = where(lval0_finL eq 0.)
if goo[0] ne -1 then lval0_finL[goo] = !values.f_nan
goo = where(energiesL eq 0.)
if goo[0] ne -1 then energiesL[goo] = !values.f_nan
goo = where(totaltimeL eq 0.)
if goo[0] ne -1 then totaltimeL[goo] = !values.f_nan
goo = where(thk_finL eq 0.)
if goo[0] ne -1 then thk_finL[goo] = !values.f_nan
goo = where(thk0_finL eq 0.)
if goo[0] ne -1 then thk0_finL[goo] = !values.f_nan





for bbq=0,nrays-1 do begin

	energiesLi[*,bbq] = interp(energiesL[*,bbq],mlatrange,newxvals)
	totaltimeLi[*,bbq] = interp(totaltimeL[*,bbq],mlatrange,newxvals)
	lval0_finLi[*,bbq] = interp(lval0_finL[*,bbq],mlatrange,newxvals)
	thk_finLi[*,bbq] = interp(thk_finL[*,bbq],mlatrange,newxvals)
	thk0_finLi[*,bbq] = interp(thk0_finL[*,bbq],mlatrange,newxvals)

	goo = where(energiesLi[*,bbq] eq 0.)
	if goo[0] ne -1 then energiesLi[goo,i] = !values.f_nan
	goo = where(totaltimeLi[*,bbq] eq 0.)
	if goo[0] ne -1 then totaltimeLi[goo,i] = !values.f_nan
	goo = where(lval0_finLi[*,bbq] eq 0.)
	if goo[0] ne -1 then lval0_finLi[goo,i] = !values.f_nan
	goo = where(thk_finLi[*,bbq] eq 0.)
	if goo[0] ne -1 then thk_finLi[goo,i] = !values.f_nan
	goo = where(thk0_finLi[*,bbq] eq 0.)
	if goo[0] ne -1 then thk0_finLi[goo,i] = !values.f_nan



	;!p.multi = [0,0,2]
	;plot,newxvals,energiesLi[*,bbq],psym=-4;,xrange=[20,50]
	;plot,mlatrange,energiesL[*,bbq],psym=-4;,xrange=[20,50]

	;plot,newxvals,totaltimeLi[*,bbq],psym=-4;,xrange=[20,50]
	;plot,mlatrange,totaltimeL[*,bbq],psym=-4;,xrange=[20,50]

	;plot,newxvals,lval0_finLi[*,bbq],psym=-4;,xrange=[20,50]
	;plot,mlatrange,lval0_finL[*,bbq],psym=-4;,xrange=[20,50]

	;plot,newxvals,thk_finLi[*,bbq],psym=-4;,xrange=[20,50]
	;plot,mlatrange,thk_finL[*,bbq],psym=-4;,xrange=[20,50]

	;plot,newxvals,thk0_finLi[*,bbq],psym=-4;,xrange=[20,50]
	;plot,mlatrange,thk0_finL[*,bbq],psym=-4;,xrange=[20,50]


	;Subset of values with the correct resonant energy
	energiesLi2[*,bbq] = energiesLi[*,bbq]
	totaltimeLi2[*,bbq] = totaltimeLi[*,bbq]
	lval0_finLi2[*,bbq] = lval0_finLi[*,bbq]
	thk_finLi2[*,bbq] = thk_finLi[*,bbq]
	thk0_finLi2[*,bbq] = thk0_finLi[*,bbq]

	;;The L2 variables contain only the parts of the ray path that COUNTER-STREAMING
	;;the correct energies (250-850 keV) and correct delta-time (<=50 msec)

	;Remove energies outside of range
	bade = where((energiesLi[*,bbq] lt 250.) or (energiesLi[*,bbq] gt 850.))
	if bade[0] ne -1 then begin
		energiesLi2[bade,bbq] = !values.f_nan
		totaltimeLi2[bade,bbq] = !values.f_nan
		lval0_finLi2[bade,bbq] = !values.f_nan
		thk_finLi2[bade,bbq] = !values.f_nan
		thk0_finLi2[bade,bbq] = !values.f_nan
	endif



	;Remove spurious 0 values. These probably show up in the interpolation
	goo = where(totaltimeLi2[*,bbq] eq 0.)
	if goo[0] ne -1 then totaltimeLi2[goo] = !values.f_nan
	;goo = where(totaltimeLi eq 0.)
	;if goo[0] ne -1 then totaltimeLi2[goo] = !values.f_nan


	;tdiff = max(totaltimeL2[*,bbq],/nan) - min(totaltimeL2[*,bbq],/nan)
	;L0diff = max(lval0_finL2[*,bbq],/nan) - min(lval0_finL2[*,bbq],/nan)


	;Remove highlighted ray values if they produce a larger dt than maxtdiff
	tdiff[bbq] = max(totaltimeLi2[*,bbq],/nan) - min(totaltimeLi2[*,bbq],/nan)
	if tdiff[bbq] ge maxtdiff then begin
		energiesLi2[*,bbq] = !values.f_nan
		totaltimeLi2[*,bbq] = !values.f_nan
		lval0_finLi2[*,bbq] = !values.f_nan
		thk_finLi2[*,bbq] = !values.f_nan
		thk0_finLi2[*,bbq] = !values.f_nan
	endif
	;Remove highlighted ray values if they don't span the entire energy range
	;Require that the energies span 250 - 850 keV, or about deltaE = 600. I'll
	;set this to 580 due to finite energy step size
	ediff[bbq] = max(energiesLi2[*,bbq],/nan) - min(energiesLi2[*,bbq],/nan)
	if ediff[bbq] lt 580. then begin
		energiesLi2[*,bbq] = !values.f_nan
		totaltimeLi2[*,bbq] = !values.f_nan
		lval0_finLi2[*,bbq] = !values.f_nan
		thk_finLi2[*,bbq] = !values.f_nan
		thk0_finLi2[*,bbq] = !values.f_nan
	endif

;	if total(energiesLi2[*,bbq],/nan) ne 0 then stop

endfor  ;bbq (each ray)




colors = bytscl(indgen(nrays)-1)
colors[nrays-1] = 254
;for q=0,nrays-1 do print,'L='+strtrim(allLvals[q],2)+' is color ' + strtrim(float(colors[q]),2)

popen,'~/Desktop/' + fn[yy]

!p.multi = [0,2,4]
loadct,39
!p.charsize = 1.5
xmin = -50.
xmax = 0.
lmin = 3
lmax = 7
pdtmin=0   ;precip delta-time range
pdtmax = 100


;plot energy vs time
plot,totaltimeLi[*,0]-min(totaltimeLi2[*,0],/nan),energiesLi[*,0],yrange=[0,1000],xrange=[0,100],$
xtitle='relative arrival time (msec)',ytitle='costream energy (keV)',$
title='ray energy vs time for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,totaltimeLi[*,i]-min(totaltimeLi2[*,i],/nan),energiesLi[*,i],color=colors[i];,psym=-4
for i=0,nrays-1 do oplot,totaltimeLi[*,i]-min(totaltimeLi2[*,i],/nan),energiesLi2[*,i],color=colors[i],thick=7
oplot,[0,90],[250,250],linestyle=2
oplot,[0,90],[850,850],linestyle=2


;Color scale as defined by L-value
plot,newxvals,lval0_finLi[*,0],yrange=[lmin,lmax],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='Color scale defined by initial Lshell of ray',$
title='Color scale defined by initial Lshell of ray',/nodata
for i=0,nrays-1 do oplot,[xmin,xmax],[allLvals[i],allLvals[i]],color=colors[i]



plot,newxvals,energiesLi[*,0],yrange=[0,1000],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='costream energy (keV)',$
title='ray energy vs mlat for L='+strtrim(lval_extract,2)+'!C'+fn[yy],/nodata
for i=0,nrays-1 do oplot,newxvals,energiesLi[*,i],color=colors[i]
for i=0,nrays-1 do oplot,newxvals,energiesLi2[*,i],color=colors[i],thick=7
oplot,[0,90],[250,250],linestyle=2
oplot,[0,90],[850,850],linestyle=2

;boomin = min(energiesLi2[*,i],mintmp,/nan)
;boomax = max(energiesLi2[*,i],maxtmp,/nan)
;oplot,[newxvals[mintmp],newxvals[mintmp]],[0,boomin],linestyle=2
;oplot,[newxvals[maxtmp],newxvals[maxtmp]],[0,boomax],linestyle=2
;mlatstr = 'mlat = '+strtrim(mlatrange[mintmp],2) + '-' + strtrim(mlatrange[maxtmp],2)+' deg'
;xyouts,0.2,0.8,mlatstr,/normal

plot,newxvals,lval0_finLi[*,0],yrange=[lmin,lmax],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='Initial Lshell of ray',$
title='ray L0 vs mlat for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,newxvals,lval0_finLi[*,i],color=colors[i]
for i=0,nrays-1 do oplot,newxvals,lval0_finLi2[*,i],color=colors[i],thick=7
;boomin = min(lval0_finLi2[*,i],mintmp,/nan)
;boomax = max(lval0_finLi2[*,i],maxtmp,/nan)
;oplot,[newxvals[mintmp],newxvals[mintmp]],[0,boomin],linestyle=2
;oplot,[newxvals[maxtmp],newxvals[maxtmp]],[0,boomax],linestyle=2
;lstr = string(min(lval0_finLi2[*,i],/nan),format='(f4.1)')+'-'+$
;			 string(max(lval0_finLi2[*,i],/nan),format='(f4.1)')
;xyouts,0.2,0.42,'L0 range='+lstr,/normal

goo = where(totaltimeLi ne 0.)
if goo[0] ne -1 then ymin = min(totaltimeLi[goo],/nan) else ymin = 0
if goo[0] ne -1 then ymax = max(totaltimeLi[goo],/nan) else ymax = 1000.

plot,newxvals,totaltimeLi[*,0],yrange=[ymin,ymax],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='Precip time at FB (msec)',$
title='Precip time after chorus onset!Cvs mlat for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,newxvals,totaltimeLi[*,i],color=colors[i]
for i=0,nrays-1 do oplot,newxvals,totaltimeLi2[*,i],color=colors[i],thick=7
;boomin = min(totaltimeLi2[*,i],mintmp,/nan)
;boomax = max(totaltimeLi2[*,i],maxtmp,/nan)
;oplot,[newxvals[mintmp],newxvals[mintmp]],[0,boomin],linestyle=2
;oplot,[newxvals[maxtmp],newxvals[maxtmp]],[0,boomax],linestyle=2
;tstr = string(tdiff,format='(f4.0)')+' msec'
;xyouts,0.7,0.8,'Delta time = '+tstr,/normal


plot,newxvals,totaltimeLi[*,0]-min(totaltimeLi2[*,0],/nan),yrange=[pdtmin,pdtmax],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='Precip delta time!Cb/t 250 and 850 keV!C at FB (msec)',$
title='Precip delta time!Cvs mlat for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,newxvals,totaltimeLi[*,i]-min(totaltimeLi2[*,i],/nan),color=colors[i]
for i=0,nrays-1 do oplot,newxvals,totaltimeLi2[*,i]-min(totaltimeLi2[*,i],/nan),color=colors[i],thick=7



plot,newxvals,thk0_finLi[*,0],yrange=[0,70],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='Inital theta_kb of ray',$
title='ray initial theta_kb vs mlat for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,newxvals,thk0_finLi[*,i],color=colors[i]
for i=0,nrays-1 do oplot,newxvals,thk0_finLi2[*,i],color=colors[i],thick=7
;boomin = min(thk0_finLi2[*,i],mintmp,/nan)
;boomax = max(thk0_finLi2[*,i],maxtmp,/nan)
;oplot,[newxvals[mintmp],newxvals[mintmp]],[0,boomin],linestyle=2
;oplot,[newxvals[maxtmp],newxvals[maxtmp]],[0,boomax],linestyle=2
;t0str = string(min(thk0_finLi2[*,i],/nan),format='(f4.0)')+'-'+$
;			 string(max(thk0_finLi2[*,i],/nan),format='(f4.0)')
;xyouts,0.2,0.22,'theta_kb0 range='+t0str+' deg',/normal



plot,newxvals,thk_finLi[*,0],yrange=[0,90],xrange=[xmin,xmax],$
xtitle='mlat',ytitle='theta_kb of ray',$
title='ray theta_kb vs mlat for L='+strtrim(lval_extract,2),/nodata
for i=0,nrays-1 do oplot,newxvals,thk_finLi[*,i],color=colors[i]
for i=0,nrays-1 do oplot,newxvals,thk_finLi2[*,i],color=colors[i],thick=7
;boomin = min(thk_finLi2[*,i],mintmp,/nan)
;boomax = max(thk_finLi2[*,i],maxtmp,/nan)
;oplot,[newxvals[mintmp],newxvals[mintmp]],[0,boomin],linestyle=2
;oplot,[newxvals[maxtmp],newxvals[maxtmp]],[0,boomax],linestyle=2


pclose

endfor ;for each file

;pclose

end
