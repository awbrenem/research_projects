;Fit curve to FIREBIRD energy spectra to find integral number/energy flux.
;Basic fit form is f = Aexp( E/E0)
;See Arlo Johnson's (Arlo_FB_flux.pdf) presentation about fitting large numbers of FB events.

;Below I'm fitting the "X" event from Breneman17, Fig3, and the event in Fig4
;from Crew16



;From Breneman17 Fig3
ev = [251,333,452,621,852] ;energy levels in keV
nf = [82,53,18,4.5,0.4]    ;electron differential "number flux"  (# of electrons)/(cm^2-s-sr-keV)
plot,ev,nf,/ylog,yrange=[1,500]



;Energies
evals = indgen(2000)



;-------------------------------------------------------------------------------
;Fit function of form f(E) = fo*exp(-E/Eo)
;This seems to be what most people are using for microbursts
;NOTE: this doesn't quite fit my microburst, which seems to be a bit harder
;than normal.

evals = indgen(2000)

ev = [251,333,452,621,852] ;energy levels in keV
nf = [82,53,18,4.5,0.4]    ;electron differential "number flux"  (# of electrons)/(cm^2-s-sr-keV)

fo = 700.
Eo = 120.
f_e = fo*exp(-evals/Eo)

!p.multi = [0,0,1]
plot,ev,nf,yrange=[0,100],xrange=[0,1000]
oplot,evals,f_e,color=250


goo = where(evals ge 250.)
print,INT_TABULATED(evals[goo],f_e[goo])
;10459 e-/cm2-s-sr

goo = where(evals ge 1000.)
print,INT_TABULATED(evals[goo],f_e[goo])
;20 e-/cm2-s-sr

;------------------------------------------

;Alex Crew's 2016 Fig 4 uB
ev = [251,333,452,621,852] ;energy levels in keV
nf = [9,3,0.6,0.1,0.02]    ;electron differential "number flux"  (# of electrons)/(cm^2-s-sr-keV)
;plot,ev,nf,/ylog,yrange=[1d-3,1d2],xrange=[0,1000]

evals = indgen(2000)

fo = 120.
Eo = 97.
f_e = fo*exp(-evals/Eo)

!p.multi = [0,0,1]
;plot,ev,nf,/ylog,yrange=[1d-3,1d2],xrange=[0,1000]
;oplot,evals,f_e,color=250

plot,ev,nf,yrange=[0,20],xrange=[0,1000]
oplot,evals,f_e,color=250


goo = where(evals ge 1000.)
print,INT_TABULATED(evals[goo],f_e[goo])
;0.4 e-/cm2-s-sr


;------------------------------------------
;Fit to Seppala18, which includes a SAMPEX comparison to FIREBIRD (Crew16 event in Fig4, I think).
;He claims the units are (# of electrons)/(cm^2-s-sr-keV), but I think the denominator
;must be per MeV.

ev = [251,333,452,621,852] ;energy levels in keV
nf = [1d4,3d3,9d2,1d2,2d1]    ;electron differential "number flux"  (# of electrons)/(cm^2-s-sr-keV)


evals = indgen(2000)


fo = 120000.
Eo = 97.
f_e = fo*exp(-evals/Eo)

!p.multi = [0,0,1]
plot,ev,nf,/ylog,yrange=[1d-5,1d6],xrange=[1d2,1d4],/xlog,psym=4
oplot,evals,f_e,color=250



goo = where(evals ge 1000.)
print,INT_TABULATED(evals[goo],f_e[goo])
