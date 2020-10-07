;Finds the value of fce at every Lshell-MLT grid point
;Works best if you have a lot of orbits to fill in the gaps.


pro rbsp_survey_fce_vs_lshell_mlt


get_data,'rbspa_lshell',data=lshell
get_data,'rbspa_fce',data=fce
get_data,'rbspa_mlt',data=mlt


;remove occasional negative spikes
goo = where(fce.y le 0.)
if goo[0] ne -1 then fce.y[goo] = !values.f_nan


mlts = indgen(24)
lshells = 7*indgen(24)/23.
fces_max = fltarr(24,24)
fces_min = fltarr(24,24)
fces_med = fltarr(24,24)
fces_mean = fltarr(24,24)

for i=0,22 do begin			;lshell
	for j=0,22 do begin		;mlt
	
		c1 = lshell.y ge lshells[i]
		c2 = lshell.y lt lshells[i+1]
		c3 = mlt.y ge mlts[j]
		c4 = mlt.y lt mlts[j+1]
	
		if c1[0] ne -1 and c2[0] ne -1 and c3[0] ne -1 and c4[0] ne -1 then goo = where(c1 and c2 and c3 and c4)
		;help,goo
		
		if goo[0] ne -1 then fces_max[i,j] = max(fce.y[goo],/nan)
		if goo[0] ne -1 then fces_min[i,j] = min(fce.y[goo],/nan)
		if goo[0] ne -1 then fces_med[i,j] = median(fce.y[goo])
		if goo[0] ne -1 then fces_mean[i,j] = mean(fce.y[goo])

	endfor
endfor


goo = where(fces_max eq 0)
if goo[0] ne -1 then fces_max[goo] = !values.f_nan
goo = where(fces_min eq 0)
if goo[0] ne -1 then fces_min[goo] = !values.f_nan
goo = where(fces_med eq 0)
if goo[0] ne -1 then fces_med[goo] = !values.f_nan
goo = where(fces_mean eq 0)
if goo[0] ne -1 then fces_mean[goo] = !values.f_nan


;Plot fce and 0.1*fce for all MLTs and all Lshells

	tplot_options,'xmargin',[20.,15.]
	tplot_options,'ymargin',[3,6]
	tplot_options,'xticklen',0.08
	tplot_options,'yticklen',0.02
	tplot_options,'xthick',2
	tplot_options,'ythick',2
	tplot_options,'labflag',-1	

!x.margin = [20,15]
!y.margin = [3,6]
!p.charsize = 1.0
plot,lshells,abs(fces_max[*,mlt]/1000.),yrange=[0,20],xrange=[0,7],/nodata,$
	ytitle='freq (kHz)',xtitle='Lshell',title='Median values of fce(black), 0.5fce(blue), 0.35fce(green), 0.1fce(red) for all MLTs!Cfrom rbsp_survey_fce_vs_lshell.pro'
;for i=0,23 do oplot,lshells,abs(0.1*fces_max[*,i]/1000.),psym=4
;for i=0,23 do oplot,lshells,abs(0.1*fces_min[*,i]/1000.),psym=5
for i=0,23 do oplot,lshells,abs(0.1*fces_med[*,i]/1000.),color=250
;for i=0,23 do oplot,lshells,abs(0.1*fces_mean[*,i]/1000.),color=250

;for i=0,23 do oplot,lshells,abs(0.5*fces_max[*,i]/1000.),psym=4
;for i=0,23 do oplot,lshells,abs(0.5*fces_min[*,i]/1000.),psym=5
for i=0,23 do oplot,lshells,abs(0.5*fces_med[*,i]/1000.),color=50
;for i=0,23 do oplot,lshells,abs(0.5*fces_mean[*,i]/1000.),color=250


;for i=0,23 do oplot,lshells,abs(fces_max[*,i]/1000.),psym=4
;for i=0,23 do oplot,lshells,abs(fces_min[*,i]/1000.),psym=5
for i=0,23 do oplot,lshells,abs(fces_med[*,i]/1000.)
;for i=0,23 do oplot,lshells,abs(fces_mean[*,i]/1000.),color=250


for i=0,23 do oplot,lshells,abs(0.35*fces_med[*,i]/1000.),color=120



oplot,[0,8],[6.5,6.5]



stop



;plot,lshell.y,fce.y,yrange=[0,10000]
;oplot,[0,10],[6500,6500]



end

