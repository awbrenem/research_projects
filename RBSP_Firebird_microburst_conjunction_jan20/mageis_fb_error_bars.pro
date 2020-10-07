;MagEIS error bars on plot for the VAP-FIREBIRD conjunction paper
;Written by AWB on Aug 29, 2017

;*********************************************
;NOTE on how %error is calculated with MagEIS
;Error Due to Counting Statistics: When the count rates are low there is of
;course a significant statistical uncertainty in the MagEIS measurements.
;There is a variable included in the L2&L3 files (FESA_ERROR/FEDU_ERROR for
;electrons; FPSA_ERROR/FPDU_ERROR for protons) that can be used to quantify
;this error. Note that this variable is a replacement for the SQRT_COUNTS
;variable that appeared in rel02 but has been removed from rel03.
;The only difference between the rel03 FXXX_ERROR variables and the rel02
;SQRT_COUNTS variables is the equation used to compute the percent error.
;The rel02 variable computes the percent error as:

;% error = 100 * [1/sqrt(C)]

;where C is the counts accumulated over the integration time. The rel03
;variable uses a slightly different formula
;(see Claudepierre et al., JGR [2015] doi:TBD):

;% error = 100 * [sqrt(1+C)/C].

;Thus, the one count level in the rel02 variable corresponds to 100% error,
;while the one count level in the rel03 variable corresponds to 141% error.
;These percent error variables are computed from the uncorrected data and,
;for the electron data, they should not be confused with the percent error
;variables for the background corrected data (FESA_CORR_ERROR/FEDU_CORR_ERROR),
;which also include error terms due to background contamination
;(see Claudepierre et al., JGR [2015] doi:TBD).

;*********************************************


rbsp_efw_init




;load L3 MagEIS data. L2 data don't have resolved pitch angles
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/MagEIS/'
fn = 'rbspa_rel03_ect-mageis-L3_20160120_v7.5.1.cdf'
cdf2tplot,path+fn


;load background-corrected data and %error
get_data,'FEDU_CORR',data=d
get_data,'FEDU_CORR_ERROR',data=d2
pa = d.v1[0:5] ;pitch angles up to 90 deg

energies = reform(d.v2[0,*]) ;energies



;Extract data from specific range of times
UT = time_double('2016-01-20/19:43:59')
nsp = 7. ;number of spin periods to sample over.
         ;The conjunction lasts 80 sec, over which there are ~7 spin periods
ytmp = reform(tsample('FEDU_CORR',[UT-(11.*nsp/2.),UT+(11.*nsp/2.)],times=t))
y2 = reform(tsample('FEDU_CORR_ERROR',[UT-(11.*nsp/2.),UT+(11.*nsp/2.)],times=t))  ;%error from MagEIS L3

ntimes = n_elements(y2[*,0,0])

;Determine counts
counts = (100./y2)^2


;;;;change to fractional error
errorME = fltarr(25,11)
countsME = fltarr(25,11)

y = fltarr(25,11)
;errorMEtmp = y2/100.

;Sum the count levels for all the times
for i=0,24 do for j=0,10 do countsME[i,j] = total(counts[*,i,j],/nan)

;Average the flux values for all the times
for i=0,24 do begin
  for j=0,10 do begin
    poo = where(finite(ytmp[*,i,j]) ne 0)
    if poo[0] ne -1 then y[i,j] = total(ytmp[*,i,j],/nan)/n_elements(poo)
  endfor
endfor

;errorME = 100./sqrt(countsME)
errorME = 1/sqrt(countsME)


;delta-y values are fract_err * measured_values
errbarsME = errorME*y

colors = reverse(indgen(n_elements(pa))*25.)


;Linear scale plot
;plot,energies,y[*,0],/nodata,yrange=[0,2000],xrange=[200,1000],xstyle=1,ystyle=1
;for i=0,10 do oplot,energies,y[*,i],psym=-4,color=colors[i]
;for i=0,10 do oplot,energies,yh[*,i],psym=-4,linestyle=2,color=colors[i]


;Log scale plot


;***TEST PLOT 1
;!p.charsize = 1.5
;!p.multi = [0,0,2]
;plot,energies,y[*,0],/nodata,yrange=[1d-1,1d5],/ylog,xrange=[200,1000],xstyle=1,ystyle=1,ytitle='e- flux',xtitle='energy(keV)',$
;title='MagEIS e- flux for all pitch angles for 2016-01-20/19:43:59'
;Only plot values if they have a corresponding error estimation


;***TEST PLOT 2
;patmp = 0.
;for t=0,ntimes-1 do oplot,energies[*],reform(ytmp[t,*,patmp]),psym=-4,color=colors[patmp]
;stop

;***TEST PLOT 3
;plot,energies,y[*,0],/nodata,yrange=[1d-1,1d5],/ylog,xrange=[200,1000],xstyle=1,ystyle=1,ytitle='e- flux',xtitle='energy(keV)',$
;title='MagEIS e- flux for all pitch angles for 2016-01-20/19:43:59'
;for paa=0,n_elements(pa)-1 do begin
;  for t=0,ntimes-1 do oplot,energies[*],ytmp[t,*,paa],psym=-4,color=colors[paa]
;endfor



plot,energies,y[*,0],/nodata,yrange=[1d-1,1d5],/ylog,xrange=[200,1000],xstyle=1,ystyle=1,ytitle='e- flux',xtitle='energy(keV)',$
title='MagEIS e- flux for all pitch angles for 2016-01-20/19:43:59'


for paa=0,n_elements(pa)-1 do begin

  diffs = y - errbarsME
  boo = where(diffs le 0)
  if boo[0] ne -1 then diffs[boo] = 0.1

  tmp = errbarsME[*,paa]
  goo = where((tmp ne 0) and (finite(tmp) ne 0))
  if goo[0] ne -1 then begin
    oplot,energies[goo],y[goo,paa],psym=-4,color=colors[paa],thick=3
    oplot,energies[goo],y[goo,paa]+errbarsME[goo,paa],linestyle=2,color=colors[paa],thick=2
    oplot,energies[goo],diffs[goo,paa],linestyle=2,color=colors[paa],thick=2
  endif
endfor

;add in FIREBIRD error bars and values


stop
;Load best calibrated FIREBIRD data:
tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/FB_calibrated_counts_flux.tplot'

energyFB = [251.5,333.5,452,620.5,852.8]  ;FB energy channels
energyFBlow = [220,283,384,520,721]
energyFBhigh = [283,384,520,721,985]

;t0 = [;'2016-01-20/19:43:32.878',$
     ;'2016-01-20/19:43:33.700',$
     ;'2016-01-20/19:43:34.575',$
     ;'2016-01-20/19:43:35.250',$
     ;'2016-01-20/19:43:40.725',$
     ;'2016-01-20/19:43:41.008',$
     ;'2016-01-20/19:43:41.964',$
     ;'2016-01-20/19:43:43.830',$
     ;'2016-01-20/19:43:44.120',$
     ;'2016-01-20/19:43:45.400',$
;     '2016-01-20/19:43:49.890',$
;     '2016-01-20/19:43:50.490',$
;;     '2016-01-20/19:43:55.310',$
;;     '2016-01-20/19:43:55.870',$
;     '2016-01-20/19:43:56.620',$
;     '2016-01-20/19:43:56.960',$
;     '2016-01-20/19:43:57.840',$
;     '2016-01-20/19:44:01.290',$
;     '2016-01-20/19:44:02.000',$
;     '2016-01-20/19:44:12.920',$
;     '2016-01-20/19:44:18.480',$
;     '2016-01-20/19:44:18.898',$
;     '2016-01-20/19:44:19.091',$
;     '2016-01-20/19:44:20.895',$
;     '2016-01-20/19:44:32.940']




;Find flux (above background) and counts for all the prominant uB in the last Figure
;These arrays are for each energy

t = ['2016-01-20/19:43:32.860',$
'2016-01-20/19:43:33.700',$
'2016-01-20/19:43:34.620',$
'2016-01-20/19:43:35.230',$
'2016-01-20/19:43:40.690',$
'2016-01-20/19:43:40.980',$
'2016-01-20/19:43:41.960',$
'2016-01-20/19:43:43.810',$
'2016-01-20/19:43:44.070',$
'2016-01-20/19:43:45.340',$
'2016-01-20/19:43:49.890',$
'2016-01-20/19:43:50.500',$
'2016-01-20/19:43:56.570',$
'2016-01-20/19:43:56.970',$
'2016-01-20/19:43:57.820',$
'2016-01-20/19:44:01.320',$
'2016-01-20/19:44:01.960',$
'2016-01-20/19:44:01.300',$
'2016-01-20/19:44:01.890',$
'2016-01-20/19:44:12.920',$
'2016-01-20/19:44:19.000',$
'2016-01-20/19:44:20.890',$
'2016-01-20/19:44:32.990']

flux_c1 = [53.983739,  70.569105,  48.455283,  30.243900,  79.674797,  73.821138,  59.186991,  107.64228,  111.86992,  34.796746,72.207790,77.402595,106.49350,97.402595,77.402595,90.909088,69.350647,91.707317,  71.219512,  95.284553,  118.69919,  93.658537, 111.54472]
flux_c2 = [13.143631,  23.035230,  12.601625,  8.6720858,  29.539295,  21.680216,  19.241192,  44.173442,  46.612467,  7.9945790,28.051947,33.766233,61.645020,46.406925,30.129869,42.597401,30.649350,41.758235,  28.571423,  53.626366,  60.659332,  53.626366,  61.978014]
flux_c3 = [2.6373617,  4.0384605,  2.0604387,  1.8131859,  6.5109878,  3.3791199,  3.2142847,  12.197801,  12.774724,  1.4835156,8.9285712,8.9826837,20.670995,12.337662,8.1168829,14.015151,8.2792206,14.340657,  8.7362616,  19.120876,  26.043953,  22.747250,  25.549447]
flux_c4 = [0.32967021, 0.53846140, 0.34065922, 0.31868119, 0.58241744, 0.48351635, 0.42857130,  1.8461536,  1.9340657, 0.31868119,1.4285714,1.6017316,4.7619046,2.2619047,1.5367965,3.0735930,1.8290043,3.0769225,  1.8021973,  4.9230762,  6.8571420,  7.2087903,  6.4175816]
flux_c5 = [0,0,0,0,0,0,0,0,0.25,0,0.23457334,0.070021902, 0.59868715, 0.37111601, 0.36061273, 0.44463900, 0.36761492,0.50549437, 0.36263724, 0.94505478,  1.5384613,  1.4285712, 0.85714270]
;flux_c5 = [!values.f_nan,!values.f_nan,!values.f_nan,!values.f_nan,!values.f_nan,!values.f_nan,!values.f_nan,!values.f_nan,0.25,!values.f_nan,0.23457334,0.070021902, 0.59868715, 0.37111601, 0.36061273, 0.44463900, 0.36761492,0.50549437, 0.36263724, 0.94505478,  1.5384613,  1.4285712, 0.85714270]

bg_c1 = [14.505489,  14.505489,  13.846148,  13.846148,  13.846148,  17.802193,  20.439556,  19.780215,  16.483511,  10.549445,13.766233,16.623376,21.818181,22.597402,28.311688,44.155843,44.155843,44.552844,  44.878047,  62.439024,  65.691056,  65.040650,  33.170730]
bg_c2 = [2.8455273,  2.8455273,  2.8455273,  2.8455273,  2.1680205,  3.6585355,  4.8780477,  3.9295382,  4.0650395,  3.1165300,3.8095238,5.1948051,7.2727271,7.9653678,9.6969695,16.450216,16.796536,18.021973,  18.021973,  29.450543,  35.604389,  32.527466,  12.307687]
bg_c3 = [0.48780452, 0.44715411, 0.44715411, 0.40650370, 0.56910534, 0.60975574, 0.81300778,  1.1788615,  1.0569102, 0.52845493,1.0281385,1.1904762,2.1645021,2.4350649,2.4891774,4.4372293,4.7077921,4.2857125,  4.4505476,  10.219778,  12.032965,  12.032965,  4.2857125]
bg_c4 = [0.065933960,0.043955939,0.065933960, 0.10989000, 0.10989000, 0.10989000, 0.12087901, 0.12087901, 0.12087901, 0.12087901,0.10822511,0.086580089, 0.40043289, 0.33549783, 0.33549783, 0.79004327, 0.93073591,0.92307645, 0.83516437,  2.6373620,  2.9890104,  3.0329664,  1.0109885]
bg_c5 = [0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.024507676,0.024507676,0.024507676,0.017505487,0.045514242,0.098030657, 0.11553613,0.14285703, 0.14285703, 0.52747239, 0.60439546, 0.54945041, 0.14285703]

counts_c1 = [208.67208,  277.77777,  192.41192,  121.95121,  310.29810,  294.03794,  237.12737,  418.69919,  437.66938,  135.50135,284.63203,304.11255,418.83116,383.11687,308.44155,359.30735,274.89177,361.78862,  279.13279,  371.27371,  463.41464,  365.85366,  439.02439]
counts_c2 = [79.674792,  145.52845,  77.235768,  55.284547,  182.11382,  133.33333,  119.51219,  274.79675,  288.61789,  51.219506,175.75757,209.52380,380.08657,287.44588,187.01298,263.20346,187.87878,265.93403,  186.81315,  323.07688,  369.23072,  336.26369,  382.41754]
counts_c3 = [23.076915,  36.923068,  18.461531,  15.164828,  54.725265,  30.989003,  30.329662,  104.17581,  108.79120,  13.186806,74.458873,75.757574,173.16017,103.46320,66.666665,118.18181,71.428570,120.87910,  70.054927,  156.59338,  217.03294,  188.18679,  212.91206]
counts_c4 = [4.1208776,  7.0054927,  3.9835149,  3.0219765,  6.8681301,  5.7692291,  4.9450533,  22.664832,  23.901096,  4.2582402,18.051948,19.999999,59.090907,27.922077,18.571428,38.181817,22.077922,39.010981,  23.626367,  60.989002,  82.417572,  87.912077,  76.923066]
counts_c5 = [2.0219777,  2.0219777,  2.0219777,  2.0219777,  3.0109886,  1.9999997,  2.0219777,  2.0879117,  2,  2.0219777,0.24857771, 0.11903722, 0.61969371, 0.35711164, 0.36061273, 0.47264775, 0.35361054,7.6923059,  5.9065917,  15.521976,  24.587909,  22.939558,  14.010987]


flux_c1 = flux_c1 - bg_c1
flux_c2 = flux_c2 - bg_c2
flux_c3 = flux_c3 - bg_c3
flux_c4 = flux_c4 - bg_c4
flux_c5 = flux_c5 - bg_c5


nuB = n_elements(flux_c1)
;determine average values
flux_c1_avg = total(flux_c1)/nuB
flux_c2_avg = total(flux_c2)/nuB
flux_c3_avg = total(flux_c3)/nuB
flux_c4_avg = total(flux_c4)/nuB
flux_c5_avg = total(flux_c5)/nuB

counts_c1_avg = total(counts_c1)/nub
counts_c2_avg = total(counts_c2)/nub
counts_c3_avg = total(counts_c3)/nub
counts_c4_avg = total(counts_c4)/nub
counts_c5_avg = total(counts_c5)/nub



fluxFB = [flux_c1_avg,flux_c2_avg,flux_c3_avg,flux_c4_avg,flux_c5_avg]
countsFB = [counts_c1_avg,counts_c2_avg,counts_c3_avg,counts_c4_avg,counts_c5_avg]

fluxFB_max = [max(flux_c1),max(flux_c2),max(flux_c3),max(flux_c4),max(flux_c5)]
fluxFB_min = [min(flux_c1),min(flux_c2),min(flux_c3),min(flux_c4),min(flux_c5)]

;Define fractional error in same way MagEIS defines it. err = sqrt(1+counts)/counts
;This is very similar to defining it as err = 1/sqrt(counts)
errorFB = sqrt(1+countsFB)/countsFB
errbarsFB = errorFB*countsFB

dE = [63,101,136,201,264]  ;energy bin size for FIREBIRD (keV)
;convert these counts back to +/- flux error
errbarsFB = errbarsFB*16.67/dE  ;change error bars back to flux units



oplot,energyFB,fluxFB,thick=2,psym=-4,color=250

diffFB = fluxFB - errbarsFB
goo = where(diffFB le 0.)
if goo[0] ne -1 then diffFB[goo] = 0.08
oplot,energyFB,fluxFB,thick=2,psym=-4,color=250
oplot,energyFB,fluxFB+errbarsFB,linestyle=2,color=250,thick=2
oplot,energyFB,diffFB,psym=-4,linestyle=2,color=250,thick=2

stop


for i=0,nuB-1 do oplot,energyFB,[flux_c1[i],flux_c2[i],flux_c3[i],flux_c4[i],flux_c5[i]]


;oplot,energyFB,fluxFB_min
;oplot,energyFB,fluxFB_max


;Find power law of each line.

;John Sample's curve fit to FIREBIRD
;Jo = 1250.
Jo = 850.
Eo = 105.
xv = indgen(1000.)
J = Jo*exp(-1*xv/Eo)
oplot,xv,J,thick=2

Jo = 467.
Eo = 113.
xv = indgen(1000.)
J = Jo*exp(-1*xv/Eo)
oplot,xv,J,thick=2


timebar,['2016-01-20/19:43:56.513','2016-01-20/19:43:56.663']
stop
stop
stop
stop






yh = y+errbarsME
yl = y-errbarsME
goo = where(yl le 0.)
if goo[0] ne -1 then yl[goo] = 0.1

yhfb = fluxFB + errbarsFB
ylfb = fluxFB - errbarsFB


;Polyfill the errors
for paa=0,n_elements(pa)-1 do begin
  for ee=0,n_elements(energies)-2 do begin


    ;polyfill from line to max values
    if finite(energies[ee]) ne 0. and finite(energies[ee+1]) ne 0. and $
    finite(yl[ee,paa]) ne 0. and finite(yl[ee+1,paa]) ne 0. and $
    finite(yh[ee,paa]) ne 0. and finite(yh[ee+1,paa]) ne 0. and $
    energies[ee] ne 0. and energies[ee+1] ne 0. and $
    yl[ee,paa] ne 0. and yl[ee+1,paa] ne 0. and $
    yh[ee,paa] ne 0. and yh[ee+1,paa] ne 0. then $
    polyfill,[energies[ee],energies[ee+1],energies[ee+1],energies[ee]],[yl[ee,paa],yl[ee+1,paa],yh[ee+1,paa],yh[ee,paa]],color=colors[paa],/noclip
  endfor
endfor

for ee=0,n_elements(energyFB)-2 do $
polyfill,[energyFB[ee],energyFB[ee+1],energyFB[ee+1],energyFB[ee]],[ylFB[ee],ylFB[ee+1],yhFB[ee+1],yhFB[ee]],color=250,/noclip





;Plot only the errors
plot,energies,errbarsME,/nodata,yrange=[1d-1,1d5],/ylog,xrange=[200,1000],xstyle=1,ystyle=1,ytitle='Flux uncertainty',xtitle='energy(keV)'
for paa=0,n_elements(pa)-1 do oplot,energies,errbarsME[*,paa],psym=-4,color=colors[paa],thick=3
oplot,energyFB,errbarsFB,psym=-4,thick=2,color=250


stop





stop
end
