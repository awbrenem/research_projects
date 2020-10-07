;; Aaron:
;; Just for the heck of it, I fit the MagEIS spectra around 20 UT and came up with the following double-maxwellian fit 

;; J ~ 4.7E5 x exp(-E/25.8) + 7.7E3 x exp(-E/197) with E in keV and J in electrons/(cm2 s sr keV) 

;; Integrating from 50 keV to 1 MeV and dividing by 4π gives 

;; I~2.6E5 electrons/(cm2 s). 

;; Is that the sort of number you are using? 



;Result = QROMB( Func, A, B [, /DOUBLE] [, EPS=value] [, JMAX=value] [, K=value] )


.compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/idl/jan6_mageis_fit.pro
r = qromb('jan6_mageis_fit',50,58)/4./!pi    ;e-/cm2/s/sr




