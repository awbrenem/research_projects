;MagEIS A
;Used to create Fig3 in Breneman et al., 2017


theta_angles = [90.0,73.6,57.3,40.9,24.5,8.2]

UT = '19:43:59'

energy = [31.5,53.8,79.8,108.3,143.5,183.4,226.1,231.8,342.1,464.4,593,741.6,901.8]
flux = [[1E+06,9E+05,8E+05,6E+05,6E+05,4E+05],$
        [8E+05,7E+05,6E+05,5E+05,4E+05,3E+05],$
        [4E+05,3E+05,3E+05,2E+05,1E+05,8E+04],$
        [1E+05,1E+05,6E+04,4E+04,3E+04,2E+04],$
        [3E+04,3E+04,2E+04,1E+04,1E+04,7E+03],$
        [2E+04,2E+04,1E+04,9E+03,6E+03,4E+03],$
        [1E+04,1E+04,8E+03,5E+03,3E+03,2E+03],$
        [1E+04,9E+03,7E+03,4E+03,3E+03,1E+03],$
        [4E+03,3E+03,2E+03,1E+03,6E+02,2E+02],$
        [1E+03,1E+03,8E+02,3E+02,8E+01,4E+01],$
        [7E+02,5E+02,3E+02,7E+01,5E+01,1E+01],$
        [3E+02,2E+02,1E+02,4E+01,5E+00,!values.f_nan],$
        [9E+01,7E+01,6E+01,9E+00,5E+00,!values.f_nan]]



;FU4 	 1/20/16	FU4-S
UTFB = '19:43:57'
energyFB = [251.5,333.5,452,620.5,852.8]
initial_gf_correction = 2.  ;simple geometric factor correction (no energy dependence)

fluxFB = initial_gf_correction*[57,34,11,2.4,0.31]

psyms = [1,2,4,5,6,7]

plot,energy,flux[0,*],/nodata,yrange=[1d-1,1d5],xrange=[200,1000],/ylog
for i=0,5 do oplot,energy,flux[i,*],psym=1*psyms[i],color=30.*i,symsize=1.5
oplot,energyFB,fluxFB,psym=-5,color=250,symsize=1.5


;Extrapolate MagEIS energies to the loss cone using sin^n

goo = where(energy gt 800.)
print,energy[goo[0]]

vals = indgen(90)*!dtor
a = flux[0,goo[0]]
;funct = a*sin(vals)^4.5
expon = indgen(10)*0.6 + 1
;funct = a*sin(vals)


plot,theta_angles,flux[*,goo[0]],yrange=[0.001,5000],/ylog,psym=-4,$
  thick=4,/nodata,title='Energy='+strtrim(energy[goo[0]],2)+' keV',ytitle='flux',xtitle='angle(deg)'
oplot,[3,3],[0.0001,1d10]
;overplot sin^n curves
for i=0,n_elements(expon)-1 do oplot,vals/!dtor,a*sin(vals)^expon[i],color=250

oplot,theta_angles,flux[*,goo[0]],thick=4,psym=-4



;Interpolate spectra to high energy resolution to calculate the ratio of
;MagEIS/FB

evals = indgen(1000)
fluxFB_interp = interpol(fluxFB,energyFB,evals)
fluxME_interp = interpol(flux[5,*],energy,evals)

!p.multi = [0,0,2]

plot,evals,fluxME_interp,/nodata,yrange=[1d-1,1d5],xrange=[200,1000],/ylog
for i=0,5 do oplot,evals,fluxME_interp,psym=1*psyms[i],color=30.*i,symsize=1.5
oplot,evals,fluxFB_interp,psym=-5,color=250,symsize=1.5

plot,energy,flux[0,*],/nodata,yrange=[1d-1,1d5],xrange=[200,1000],/ylog
for i=0,5 do oplot,energy,flux[i,*],psym=1*psyms[i],color=30.*i,symsize=1.5
oplot,energyFB,fluxFB,psym=-5,color=250,symsize=1.5

rat = fluxME_interp/fluxFB_interp
plot,evals,rat,yrange=[0,10],xrange=[200,1000];,/ylog
;for i=0,5 do oplot,evals,fluxME_interp,psym=1*psyms[i],color=30.*i,symsize=1.5
;oplot,evals,fluxFB_interp,psym=-5,color=250,symsize=1.5
