;Plot THEMIS-A PADs from Xiaojia Zheng in order to:
;--predict loss cone flux
;--compare with POES data
;--compare with Thiago Brito's mechanism.



;flux at all 8 pitch angle bins (centered at 11.25, 33.75, 56.25,
;78.75, 101.25, 123.75, 146.25, 168.75 deg with respect to the background B-field)


timespan,'2014-01-11'
omni_hro_load
rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*80.

;THEMIS-E
;energies = [1486.03,2575.64,4462.62,7732.88,13399.3,23217.7,27000.0,28000.0,29000.0,30000.0,31000.0,41000.0,52000.0,65500.0,93000.0,139000.,203500.,293000.,408000.,561500.,719500.]
;THEMIS-A
energies = [1304.46,1717.47,2260.87,2976.85,3917.75,5157.26,6788.92,8936.37,11763.4,15484.9,20383.3,26831.4,27000.0,28000.0,29000.0,30000.0,31000.0,41000.0,52000.0,65500.0,93000.0,139000.,203500.,293000.,408000.,561500.,719500.]
pa_bins = [11.25, 33.75, 56.25,78.75, 101.25, 123.75, 146.25, 168.75]


;load number or energy flux?
type = 'nflux'   ;'eflux'


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

if type eq 'eflux' then files = ['tha_eflux_1-300keV_20140111_190000-20140112_020000_11deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_34deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_56deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_79deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_101deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_124deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_146deg.txt',$
        'tha_eflux_1-300keV_20140111_190000-20140112_020000_169deg.txt']

if type eq 'nflux' then files = ['tha_numberflux_1-700keV_20140111_190000-20140112_020000_11deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_34deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_56deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_79deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_101deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_124deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_146deg.txt',$
        'tha_numberflux_1-700keV_20140111_190000-20140112_020000_169deg.txt']


;if type eq 'nflux' then files = ['the_flux_1-700keV_20140111_190000-20140112_020000_34deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_56deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_79deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_124deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_146deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_169deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_11deg.txt',$
;  'the_flux_1-700keV_20140111_190000-20140112_020000_101deg.txt']


;Load the first file to find out sizes, etc...
openr,lun,path+files[0],/get_lun
jnk = ''
readf,lun,jnk

dat = ''
finaldat = ''
while not eof(lun) do begin $
    readf,lun,dat & $
    finaldat = [finaldat,dat]
endwhile
close,lun & free_lun,lun


nelem = n_elements(finaldat)-1
finaldat = finaldat[1:nelem]
;nelem -= 1


;Data arrays
;THEMIS-A
fluxv = strarr(nelem,27,8)    ;(time,energy,PA)
;THEMIS-E
;fluxv = strarr(nelem,21,8)    ;(time,energy,PA)
times = strarr(nelem)


vals = strsplit(finaldat,' ',/extract)
for i=0,nelem-1 do times[i] = vals[i,0]
;THEMIS-A
for i=0,nelem-1 do fluxv[i,*,0] = vals[i,1:27,0]
;THEMIS-E
;for i=0,nelem-1 do fluxv[i,*,0] = vals[i,1:21,0]



;Now load rest of the PA files
for q=1,n_elements(files)-1 do begin

  openr,lun,path+files[q],/get_lun
  jnk = ''
  readf,lun,jnk

  dat = ''
  finaldat = ''
  while not eof(lun) do begin $
      readf,lun,dat & $
      finaldat = [finaldat,dat]
  endwhile
  close,lun & free_lun,lun


  nelem = n_elements(finaldat)-1
  finaldat = finaldat[1:nelem]
  nelem -= 1

  vals = strsplit(finaldat,' ',/extract)
;THEMIS-A
  for i=0,nelem-1 do fluxv[i,*,q] = vals[i,1:27,0]
;THEMIS-E
;  for i=0,nelem-1 do fluxv[i,*,q] = vals[i,1:21,0]

endfor

fluxv = float(fluxv)

stop


;Store an energy spectrum

;pa_bins
;energies
fluxtmp = fluxv[*,*,0]

store_data,'flux11deg_spec',time_double(times),fluxtmp,energies
options,'flux11deg_spec','spec',1
zlim,'flux11deg_spec',0.01,200,1
ylim,'flux11deg_spec',1000,1d6,1
tplot,'flux11deg_spec'

;tplot_save,'flux11deg_spec',filename='~/Desktop/tha_flux11deg_20140111_Xiaoxia_spec_plot'
;tplot_save,'flux11deg_spec',filename='~/Desktop/the_flux11deg_20140111_Xiaoxia_spec_plot'

;-----------------------------------------------------
;Plot the PADs for various energies

;energies = [1304.46,1717.47,2260.87,2976.85,3917.75,5157.26,6788.92,8936.37,11763.4,15484.9,20383.3,26831.4,27000.0,28000.0,29000.0,30000.0,31000.0,41000.0,52000.0,65500.0,93000.0,139000.,203500.,293000.]
;pa_bins = [11.25, 33.75, 56.25,78.75, 101.25, 123.75, 146.25, 168.75]


;Select time of interest
t0 = time_double('2014-01-11/23:00')
t1 = time_double('2014-01-11/23:30')

goodt = where((time_double(times) ge t0) and (time_double(times) le t1))

energyi = 17.
fluxvtmp = reform(fluxv[goodt,energyi,*])
titlev = 'Energy='+strtrim(energies[energyi]/1000.,2)+'keV from ' + $
        time_string(t0) + ' to ' + time_string(t1)

goo = where(fluxvtmp ge 0.)
minv = min(fluxvtmp[goo])
maxv = max(fluxvtmp[goo])
;yr = [6d6,2d7]
yr = [minv/1.2,maxv*1.2]
yr = [minv/2,maxv*2]


;Plot all the individual PADs b/t t0 and t1

if type eq 'eflux' then plot,pa_bins,fluxvtmp[0,*],xtitle='PA (deg)',ytitle='Energy flux!CeV/s-cm2-sr-eV',title=titlev,/nodata,/ylog,yrange=yr,ystyle=1
if type eq 'nflux' then plot,pa_bins,fluxvtmp[0,*],xtitle='PA (deg)',ytitle='Number flux!C#/s-cm2-sr-eV',title=titlev,/nodata,/ylog,yrange=yr,ystyle=1
for uu=0,n_elements(goodt)-1 do oplot,pa_bins,fluxvtmp[uu,*]

;Oplot average the PADs b/t t0 and t1
fluxvtmp2 = fltarr(8)
for bb=0,7 do fluxvtmp2[bb] = mean(fluxvtmp[*,bb])
oplot,pa_bins,fluxvtmp2,thick=2,color=250


;------------------------------------------------------
;Plot flux vs energy for various PA bins



;Select time of interest
;t0 = time_double('2014-01-11/22:00')
;t1 = time_double('2014-01-11/22:10')
t0 = time_double('2014-01-11/19:55')
t1 = time_double('2014-01-11/22:05')

goodt = where((time_double(times) ge t0) and (time_double(times) le t1))

pai = 0.
fluxvtmp = reform(fluxv[goodt,*,pai])
titlev = 'PA='+strtrim(pa_bins[pai],2)+'deg from ' + $
        time_string(t0) + ' to ' + time_string(t1)

goo = where(fluxvtmp ge 0.)
minv = min(fluxvtmp[goo])
maxv = max(fluxvtmp[goo])
yr = [minv,maxv]
xr = [10,2000]

rbsp_efw_init

;Plot all the individual PADs b/t t0 and t1
if type eq 'eflux' then plot,energies/1000.,fluxvtmp[0,*],xtitle='Energy (keV)',ytitle='Energy Flux!CeV/s-cm2-sr-eV',title=titlev,/nodata,ylog=1,yrange=yr,ystyle=1,xrange=xr,xstyle=1
if type eq 'nflux' then plot,energies/1000.,fluxvtmp[0,*],xtitle='Energy (keV)',ytitle='Number Flux!C#/s-cm2-sr-eV',title=titlev,/nodata,ylog=1,yrange=yr,ystyle=1,xrange=xr,xstyle=1,/xlog
for uu=0,n_elements(goodt)-1 do oplot,energies/1000.,fluxvtmp[uu,*]

;Average the PADs b/t t0 and t1
fluxvtmp2 = fltarr(27)
;for bb=0,26 do fluxvtmp2[bb] = mean(fluxvtmp[*,bb])
for bb=0,20 do fluxvtmp2[bb] = mean(fluxvtmp[*,bb])
oplot,energies/1000.,fluxvtmp2,thick=2,color=250,psym=-2;,xtitle='Energy (keV)',ytitle='Flux',title=titlev;,/ylog,yrange=[minvtmp,maxvtmp],ystyle=1

;oplot Leslie's curves with units adjusted to  #/s-cm2-sr-eV
enplot = indgen(2000.)   ;keV
bmax = 38123.*exp(-1*enplot/38.0)/1000./2./!pi
bmid = 16119.*exp(-1*enplot/46.1)/1000./2./!pi
bmin = 4263.*exp(-1*enplot/60.)/1000./2./!pi

;Time period 22:55-23:15
;e-flux ( e/cm^2-s-keV) = 14928.8 exp(-energy(keV)/43.7990(keV))
;
;Time period  21:45-22:05
;e-flux ( e/cm^2-s-keV) = 9829.39exp(-energy(keV)/50.9650(keV))


oplot,enplot,bmax
oplot,enplot,bmid
oplot,enplot,bmin



;;for Leslie
;for i=0,1000 do print,energies[i]/1000.,fluxvtmp2[i]
;nfluxv = [264.792,220.550,147.331,115.649,78.9630,71.0033,63.6913,58.5134,70.3778,83.9295,99.4359,93.5174,94.8752,104.770,118.408,136.824,161.401,82.1555,49.3775,29.3798,13.4030,7.81482,4.89255,3.59892,3.27,1.93,1.33]
;energies = [1.30446, 1.71747, 2.26087, 2.97685, 3.91775, 5.15726, 6.78892, 8.93637, 11.7634, 15.4849, 20.3833, 26.8314, 27.0000, 28.0000, 29.0000, 30.0000, 31.0000, 41.0000, 52.0000, 65.5000, 93.0000, 139.000, 203.500, 293.000, 408.,562.,720.]

stop
;-----------------------------------------------------

;Plot the flux as a function of time for various PA bins
;energyi = 6.    ;6.8 keV (fluctuations not observed)
;energyi = 7.    ;8.9 keV (fluctuations not observed)
;energyi = 8.    ;11.7 keV (some fluctuations observed)

;energyi = 15.   ;30 keV
;energyi = 17.   ;41 keV
energyi = 20.   ;93 keV (upper limit of fluctuations observed)
;energyi = 21.   ;139 keV
;energyi = 25.   ;561 keV

print,energies[energyi]/1000.,' keV'

;List of energies that see the fluctuations

;1  keV  --NO
;5 keV   --YES, a bit
;12 keV  --YES
;93 keV  --YES
;139 keV --MAYBE
;293 keV --NO


store_data,'fluxv11deg_allenergies',time_double(times),reform(fluxv[*,*,pa_bins]),energies

;~0 deg bin
pabin = 0.
fluxvtmp = reform(fluxv[*,energyi,pabin])
goo = where(fluxvtmp eq 0.)
if goo[0] ne -1 then fluxvtmp[goo] = !values.f_nan
store_data,'fluxv11deg',time_double(times),fluxvtmp
;ylim,'fluxv11deg',1d5,1d6,1
ylim,'fluxv11deg',0,0,0
rbsp_detrend,'fluxv11deg',60.*80.


;~90 deg bin
pabin = 3.
fluxvtmp = reform(fluxv[*,energyi,pabin])
goo = where(fluxvtmp eq 0.)
if goo[0] ne -1 then fluxvtmp[goo] = !values.f_nan
store_data,'fluxv78deg',time_double(times),fluxvtmp
ylim,'fluxv78deg',1d5,1d6,1
ylim,'fluxv78deg',0,0,0
rbsp_detrend,'fluxv78deg',60.*80.


;Shows how isotropic the distributions are.
store_data,'flux0_90_comb',data=['fluxv11deg','fluxv78deg']
store_data,'flux0_90_detrend_comb',data=['fluxv11deg_detrend','fluxv78deg_detrend']
options,'flux0_90_comb','colors',[0,250]
options,'flux0_90_detrend_comb','colors',[0,250]
tplot,['OMNI_HRO_1min_proton_density_detrend','flux0_90_comb','flux0_90_detrend_comb']


stop

;Calculate % fluctuation
get_data,'fluxv11deg',data=v1
get_data,'fluxv11deg_smoothed',data=v2
fluct = -100*(v2.y - v1.y)/v2.y
store_data,'fluct11',v1.x,fluct
ylim,'fluct11',-50,50

get_data,'fluxv78deg',data=v1
get_data,'fluxv78deg_smoothed',data=v2
fluct = -100*(v2.y - v1.y)/v2.y
store_data,'fluct78',v1.x,fluct
ylim,'fluct78',-50,50


store_data,'fluctcomb',data=['fluct11','fluct78']
options,'fluctcomb','colors',[0,250]
ylim,'fluctcomb',-50,50
tplot,['OMNI_HRO_1min_proton_density_detrend','fluctcomb']


;fluctuation % is nearly identical for both 11 deg and 78 deg PA bin.
;for all energies.
;Would this be expected for a process conserving 3rd a.i.?






;-----------------------------------------------
;Extrapolate flux to the loss cone

;Select time of interest
t0 = time_double('2014-01-11/21:55')
t1 = time_double('2014-01-11/22:05')

goodt = where((time_double(times) ge t0) and (time_double(times) le t1))

energyi = 15.
fluxvtmp = reform(fluxv[goodt,energyi,*])
titlev = 'Energy='+strtrim(energies[energyi]/1000.,2)+'keV from ' + $
        time_string(t0) + ' to ' + time_string(t1)

goo = where(fluxvtmp ge 0.)
minv = min(fluxvtmp[goo])
maxv = max(fluxvtmp[goo])
;yr = [6d6,2d7]
yr = [minv/2.,maxv*2.]


;Plot all the individual PADs b/t t0 and t1
if type eq 'eflux' then plot,pa_bins,fluxvtmp[0,*],xtitle='PA (deg)',ytitle='Energy flux!CeV/s-cm2-sr-eV',title=titlev,/nodata,/ylog,yrange=yr,ystyle=1
if type eq 'nflux' then plot,pa_bins,fluxvtmp[0,*],xtitle='PA (deg)',ytitle='Number flux!C#/s-cm2-sr-eV',title=titlev,/nodata,/ylog,yrange=yr,ystyle=1
for uu=0,n_elements(goodt)-1 do oplot,pa_bins,fluxvtmp[uu,*],psym=-4
;Average the PADs b/t t0 and t1
fluxvtmp2 = fltarr(8)
for bb=0,7 do fluxvtmp2[bb] = mean(fluxvtmp[*,bb])
oplot,pa_bins,fluxvtmp2,color=50,thick=2; xtitle='PA (deg)',ytitle='Flux',title=titlev,psym=-4,/ylog,yrange=yr,ystyle=1


pas = indgen(180)

;---sin^n curve doesn't fit (May be b/c there seems to be strong scattering into loss cone - from POES data)
A = max(fluxvtmp2)
;fluxt = A*sin(pas*!dtor)^0.2
;oplot,pas,fluxt,color=250

;---Gaussian fits pretty well
fluxt = 0.9*A*exp(-((pas - 90.)*!dtor)^2/6.)
oplot,pas,fluxt,color=250


;Loss cone size is about 2 deg
;Ratio of flux at 11 deg with flux at 2 deg is about 1.1
;Extremely isotropic...not surprising b/c POES shows strong diffusion
;limit reached.


;----------------------------------------------------
;COMPARISON OF POES AND THA OBSERVATIONS
;----------------------------------------------------

;Total up the THA flux at >30 keV for comparison to POES


;~0 deg bin
pabin = 0.
emin = 30000.
energiesgood = where(energies ge emin)

ttst = time_double('2014-01-11/22:09')
goodt = where(time_double(times) ge ttst)



;In order to compare to POES we need to integrate the THA energies for all bins
;>30 keV.
;bwtmp = (shift(energies,-1)-energies)  ;bandwidth of all energy channels in eV
bwtmp = abs(shift(energies,1)-energies)  ;bandwidth of all energy channels in eV
;Fix the bandwidth for the last bin
bwtmp[n_elements(energies)-1] = bwtmp[n_elements(energies)-2]

;Multiply by bandwidth to get #/s-cm2-sr
fluxvbw = fluxv & fluxvbw[*] = 0.
ntimes = n_elements(fluxvbw[*,0])
;for t=0,ntimes-1 do for i=0,26 do for p=0,7 do fluxvbw[t,i,p] = fluxv[t,i,p]*bwtmp[i]
for t=0,ntimes-1 do for i=0,20 do for p=0,7 do fluxvbw[t,i,p] = fluxv[t,i,p]*bwtmp[i]



;Take subset that corresponds to >30 keV
fluxvbw = fluxvbw[*,energiesgood,*]
fluxv_nobw = fluxv[*,energiesgood,*]

for i=0,50 do print,energies[energiesgood[i]],bwtmp[energiesgood[i]],fluxvbw[goodt[0],i,0],fluxv_nobw[goodt[0],i,0]
;For 11-deg PA bin
;eV           bandwidth    #/s-cm2-sr    #/s-cm2-sr-eV
;30000.0      1000.00      203621.      203.621
;31000.0      1000.00      180682.      180.682
;41000.0      10000.0      668678.      66.8678
;52000.0      11000.0      267133.      24.2848
;65500.0      13500.0      224227.      16.6094
;93000.0      27500.0      197986.      7.19950
;139000.      46000.0      113514.      2.46770
;203500.      64500.0      72759.2      1.12805
;293000.      89500.0      22427.7     0.250589
;408000.      115000.      34931.8     0.303755
;561500.      153500.      15653.5     0.101977
;719500.      153500.      6385.94    0.0416022




plot,energies[energiesgood],fluxv_nobw[goodt[0],*,0],/ylog,yrange=[0.01,1000]


;For each time integrate energies >30 keV
fluxvintegrated = reform(fluxvbw[*,0,*]) & fluxvintegrated[*] = 0.
for t=0,ntimes-1 do for p=0,7 do fluxvintegrated[t,p] = total(fluxvbw[t,*,p])
print,fluxvintegrated[goodt[0],0]
;  2e+06  #/s-cm2-sr  THA >30 integrated # flux for 11 deg PA bin at 22:10 UT (L=8)


;----------------------------------------------
;Determine PSD fractional profile from POES data.

tplot_restore,filename=path+'POES_n18_2014_01_11.tplot'

div_data,'n18_corrected_90_E1_flux','n18_corrected_0_E1_flux',newname='POES_fluxrat'
div_data,'n18_corrected_90_E2_flux','n18_corrected_0_E2_flux',newname='POES_fluxrat2'

store_data,'n18_corrected_0_flux_comb',data='n18_corrected_'+['0_E1_flux','90_E1_flux']
store_data,'n18_corrected_0_flux_comb2',data='n18_corrected_'+['0_E2_flux','90_E2_flux']
options,'n18_corrected_0_flux_comb','colors',[0,250]
options,'n18_corrected_0_flux_comb2','colors',[0,250]
options,['n18_L_IGRF','n18_MLT'],'panel_size',0.3

;store_data,'n18_corrected_0_flux_comb2',data='n18_corrected_'+['0_E2_flux','90_E2_flux']
;options,'n18_corrected_0_flux_comb2','colors',[0,250]



tplot,['n18_corrected_0_flux_comb','n18_corrected_0_flux_comb2','POES_fluxrat','POES_fluxrat2','n18_L_IGRF','n18_MLT'],/add

;7.6d5/5.5d5
;7.6d5/3.6d5


;DIRECT COMPARISON for NOAA-18 (MLT~14)

;>30 keV Flux during strong diffusion (L=11)
;0n18_corrected_0:       2014-01-11/22:09:19  7.631e+05/s-cm2-sr

;>30 keV Flux at L=8
;1n18_corrected_0:       2014-01-11/22:08:01  3.606e+05/s-cm2-sr  (par)
;2n18_corrected_0:       2014-01-11/22:08:01  5.518e+05/s-cm2-sr  (perp)

;>30 keV Flux ratio from L=11 to L=8 ranges from
;2.1 (parallel) to 1.4 (perp)

;>30 keV Flux ratio at L=8 (perp/parallel)
;       1.5277778



;Two ways to compare.
;1) DIRECT COMPARISON: df/dr = (f1 - f2)/dr
;Works b/c # flux (and energy flux if no accel) is invariant along a magnetic field line b/c the decreased
;numbers of e- due to mirroring is offset exactly by the decreased area of
;field lines. Problem is that POES has certain issues (like contamination) and so
;a confident direct comparison may not be completely valid.
;2) FRACTIONAL COMPARISON: df/dr = f1/f2. Should work well if POES has the same
;bias at L=11 and L=8.




;These are convenient numbers b/c I had prevously estimated that the sloshing distance
;from ExB is about 3 RE.

;Compared to the THA >30 keV integrated number flux (=2d6 #/s-cm2-sr) this amount is smaller by
;2.6-5.5 times.
;NOTE: However, need to also account for width of PA bins. For THA bins are 22.5 deg wide and
;for POES the 0 deg (zenith pointing) bin is +/- 15 deg wide.


;NOTE: Dombeck mentions that #flux can be extremely sensitive to the
;exact value of bin's lowest freq. So, I've tested this THA integrated number
;flux for >29, >30, >31, >41 keV. They seem to vary in an appropriate way, so
;I think summing bins >30 keV is OK.



;FRACTIONAL COMPARISON
;df_POES:  POES sees 1.4 (f11/f8_perp) to 2.1 (f11_f8_par)
;times more flux at L=11 than L=8 in the >30 keV channel.

rbsp_detrend,'OMNI_HRO_1min_Pressure',60.*5.
rbsp_detrend,'OMNI_HRO_1min_Pressure_smoothed',60.*80.

;THEMIS-A
;Is this what we actually see?
store_data,'tha_flux_gt30keV_vs_time',time_double(times),fluxvintegrated[*,0]
tplot,'tha_flux_gt30keV_vs_time'
rbsp_detrend,'tha_flux_gt30keV_vs_time',60.*80.
div_data,'tha_flux_gt30keV_vs_time_detrend','tha_flux_gt30keV_vs_time_smoothed',newname='flux_frac'
ylim,'flux_frac',-0.4,0.4
tplot,['OMNI_HRO_1min_Pressure_smoothed_detrend','OMNI_HRO_1min_proton_density_smoothed_detrend','tha_flux_gt30keV_vs_time','tha_flux_gt30keV_vs_time_detrend','tha_flux_gt30keV_vs_time_smoothed','flux_frac']


;THEMIS-E
;;Is this what we actually see?
;store_data,'the_flux_gt30keV_vs_time',time_double(times),fluxvintegrated[*,0]
;tplot,'the_flux_gt30keV_vs_time'
;rbsp_detrend,'the_flux_gt30keV_vs_time',60.*20.
;div_data,'the_flux_gt30keV_vs_time_detrend','the_flux_gt30keV_vs_time_smoothed',newname='flux_frac'
;ylim,'flux_frac',-0.4,0.4
;tplot,['OMNI_HRO_1min_Pressure_smoothed_detrend','OMNI_HRO_1min_proton_density_smoothed_detrend','the_flux_gt30keV_vs_time','the_flux_gt30keV_vs_time_detrend','the_flux_gt30keV_vs_time_smoothed','flux_frac']


fmax = 2.396e+06  ;22:04:39 UT THA flux (#/s-cm2-sr) during peak compression
fmin = 1.035e+06  ;22:38:59 UT THA flux (#/s-cm2-sr) during peak rarefaction
;fmax/fmin =       2.3
;This is very close to the value of 2 estimated from POES!
;This suggests that ExB sloshing is indeed bringing in the appropriate number of
;particles from L=11 to L=8, explaining the THA flux variation.
;Assumption is that the observed PSD gradient is constant over times from ~22-22:40
;and extends over (at most) a couple of MLT, and that there is no e- acceleration
;during this time.
stop

;-----------------------------------------------------
;Estimate amount of flux precipitated from Thiago's mechanism
;-----------------------------------------------------


;Loss cone angle at L=8 and L=11
L = [8.,11.]
alpha = L^(-3/2.)*(4 - 3/L)^(-1/4.)/!dtor
;      1.83510      1.13028


Li = 11.
Lf = 8.
aeqi = 1.13*!dtor    ;initial e- pitch angle
num1 = -1.*sqrt(Lf)*cos(aeqi)^2
den1 = 2.*sqrt(Li)*sin(aeqi)
num2 = Lf*cos(aeqi)^4
den2 = Li*sin(aeqi)^2

saeqf = (num1/den1) + 0.5*sqrt((num2/den2)+4.)
aeqf = asin(saeqf)/!dtor
print,'Initial e- pitch angle is',aeqi/!dtor
;Initial e- pitch angle is      1.13   (same as loss cone angle)
print,'Final e- pitch angle is ',aeqf
;Final e- pitch angle is       1.32

delta_pa = 1.32 - 1.13 ;=0.19 --> how much the pitch angle increases during inward sloshing
delta_lc = 1.84 - 1.13 ;=0.71 --> how much loss cone increases during inward sloshing

;angle range of particles that can't escape the increasing loss cone by L=8.
;= 0.71 - 0.19 = 0.52 deg
;So, any electron in the small slice from 1.13 deg (L=11 loss cone) to 1.65 deg (1.13 + (0.71-0.19)) will be lost
;due to Brito mechanism. This is an angle of 1.65-1.13=0.52 deg. NOTE: his is a rough estimate b/c the amount of PA change is
;fairly angle dependent.

;---------------------------------
;BRITO...FOR COMPARISON WITH BARREL
;Rough estimate since the THA pads are pretty isotropic:
;Imagine a flux “rain” of particles at L=11 that slowly moves to L=8 over ~1 hr.
;This rain at 41 keV is
;store_data,'fluxx',time_double(times[goodt]),fluxv[*,2,0]
print,fluxv_nobw[goodt[0],2,0]   ;THA 22:10 UT, 41 keV, 11 deg PA bin
;66  #/s-cm2-sr-eV




;------------------------------------
;OLD METHOD (WRONG)
;This rain at 41 keV, integrated over 0 to Pi/2 rad, assuming isotropic, has a rate of
;66 #/s-cm2-sr-eV * !pi/2. (rad) = 103 #/s-cm2-sr-eV.
    ;TEST: How does 103 compare to the actual number summed over 0-90 deg?
;    print,total(fluxv_nobw[goodt[0],2,0:3])
    ;      248.138 --> this is the actual number. Compares pretty well to 103, so the
    ;isotropic assumption isn't bad.
;The part of this that will be raining from the loss cone increase will be
;(0.52/90.)*103 ~0.6 #/s-cm2-sr-eV. This should be the rate from Brito mechanism
;as observed by BARREL at 41 keV
;-------------------------------------



;"thin slice" solid angle  (SAA = 2*!pi * int(sin(theta)dtheta)
; = -1*2*!pi*(cos(angle1) - cos(angle2))
;where thin slice lies b/t angle1 and angle2
dfBrito = 66.
ang = 1.8   ;loss cone angle at L=8
;dangleBrito = 0.52   ;angle opening per hour
dangleBrito = 0.52/3600.  ;angle opening per second
SAABrito = -1*2*!pi*(cos(ang*!dtor) - cos((ang-dangleBrito)*!dtor))


;Now I can solve for the #/s-cm2-eV of electrons lost (from THEMIS-A)
nmBrito = dfBrito * SAABrito
;4.9434930e-05  #/s-cm2-eV  (lost each 1-sec bounce period)








;--------------------------------------------------------
;So, how does this compare to BARREL at 41 keV?
;--------------------------------------------------------

;***
;New values from Leslie on Dec, 2019
;***
;Time period 22:55-23:15
;e-flux ( e/cm^2-s-keV) = 14928.8 exp(-energy(keV)/43.7990(keV))
;Time period  21:45-22:05
;e-flux ( e/cm^2-s-keV) = 9829.39exp(-energy(keV)/50.9650(keV))


Const = [14929.,9830.]   ;(e/cm^2-s-keV)
efold = [43.8,51.0]  ;keV
fbarrel = Const * exp(-41./efold)
;BARREL flux ranges from (#/s-cm2-keV)
;5854.6286       4399.6162

;Integrate >30 keV flux
PRINT, QROMB('barrel_gaussian', 30., 300.)
;328949.   ( e/cm^2-s)
;Divide this by 2Pi Steredians to compare with POES
;52354  e-/cm2-s-sr








;OLDER VALUES
;The values in the equation would be Const = 21785.6 (e/cm^2-s-keV) and Eo = 43.5 keV.
;Const = 22 ;#/s-cm2-eV
Const = [4200.,16100.,38100.]/1000.
efold = [60.,46.,38.]

;Integrated flux is

f_int = Const*efold*(1 - exp(-E/efold))


fbarrel = Const * exp(-41./efold)
;BARREL flux ranges from (#/s-cm2-eV)
;2.1207104       6.6029396       12.952214


;Rough integration for >30 keV  (30 - 100 keV)
;4200 * 70 = 294000. #/s-cm2


;--------------------------------------------------------




;----------------------------------
;BRITO AT >30 KEV
;....for POES comparison....
;This rain for >30 keV integrated, further integrated over 0-90 deg, has a rate of
print,fluxvintegrated[goodt[0],0]
;2d6 #/s-cm2-sr
nmBrito_gt30keV = 2d6 * SAABrito
;1.4980281548560015
;This is consistent with previous result. Namely,
;THA flux >30 keV is ~30000x flux at 41 keV.
;nmBrito_gt30keV/nmBrito ~ 30000



;2d6 #/s-cm2-sr * !pi/2 (rad) = 3.2d6 #/s-cm2-sr.

;The part of this that will be raining from the loss cone increase will be
;(0.52/90)*3.2d6 ~18500 #/s-cm2-sr. This should be the rate from Brito mechanism
;as observed by POES.
;What does POES see?
;f1_POES = 4d5/s-cm2-sr at L=8 and
;f2_POES = 8d5/s-cm2-sr at L=11
;So, POES sees 22-44 times more precip than can be explained by the Brito mechanism.








;************************************
;COMPARE TO DAA CALCULATED FROM QIANLI....
;************************************

;For >10 keV Daa~10^-4 s^-1.


;Start with THEMIS-A differential flux in the 0-22 deg PA bin, 41 keV
;print,fluxv_nobw[goodt[0],2,0]   ;22:10 UT, 41 keV, 11 deg PA bin
df = 66.  ;#/s-cm2-sr-eV  @ 22:10 UT
;print,fluxv_nobw[goodt[16],2,0]   ;23:00 UT, 41 keV, 11 deg PA bin
;df = 48.66
;df = 49. ;#/s-cm2-sr-eV  @ 23:00 UT


;Now find the "thin slice" solid angle term.
;To get this I need to know how far an electron will random walk in a single
;bounce period.

;bounce-averaged diffusion coeff for 41 keV at the loss cone (Qianli Ma)
;DaaA = 1d-4 ;1/s
DaaA = 2d-4 ;1/s   (at ~22 UT, THA at L=8)
;DaaA = 1d-3 ;1/s   (at ~23 UT, THA at L=9)
L=8.
;L=9.
;Bo = 60.  ;nT


;******************************
;NO, DON'T NEED TO ACCOUNT FOR THIS!!!!
;******************************
;But, we have to account for the enhanced flux caused by
;conservation of flux in narrowing flux tube
;Find ratio of B2/B1 = A1/A2. (Note that 70 km used here may be a bit
;low for 50 keV electrons. Probably 100 km is a better value.)

;dip = dipole(L)
;;;dip1 = dipole(L1)
;
;radius = dip.r - 6370.
;;;radius1 = dip1.r - 6370.

;boo = where(radius le 70.)
;boo = boo[0]
;Bo_70km = dip.b[boo]          ;Bo_70km0 = 55300 nT
;
;Bratio = Bo_70km/Bo    ;926 @ 23 UT
;                       ;921 @ 21 UT
;*******************************
;*******************************


ang = 1.8   ;loss cone angle at L=8
;ang = 1.5   ;loss cone angle at L=9

;Only use the fraction of this 0-22.5 deg bin that's actually near the loss cone.
df = df/(22.5/ang)



Ekev = 41.

;Bounce period
Tb = 5.62d-2 * L * (1. - 0.43*sin(ang*!dtor))/sqrt(EkeV/1000.)
;Manually set bounce period to 1sec for convenience
;Tb = 1.

;Random walk distance in single bounce <Daa> = dangle^2/2tb  (Kennel69 eqn3)
dangleA = sqrt(DaaA*2*Tb)/!dtor
;Change so that this is the random walk distance per second
dangleA /= Tb

;At 23 UT this is about the size of the loss cone, which is good b/c strong diffusion
;limit is met.



;"thin slice" solid angle  (SAA = 2*!pi * int(sin(theta)dtheta)
; = -1*2*!pi*(cos(angle1) - cos(angle2))
;where thin slice lies b/t angle1 and angle2

;SAA test for theta=180 deg on a unit sphere
;print,-1*2*!pi*(cos(180*!dtor) - cos(0.))
;=      12.5664   (or 4*pi)
SAA = -1*2*!pi*(cos(ang*!dtor) - cos((ang-dangleA)*!dtor))
;=0.00307 rad
;Compare to a filled loss cone
SAAf = -1*2*!pi*(cos(ang*!dtor) - cos((ang-ang)*!dtor))
;=0.0031 rad


;Now I can solve for the #/s-cm2-eV of electrons lost (from THEMIS-A)
nmA = df * SAA

;Of these electrons in the "thin slice" half will random walk to the DLC and the other
;half to higher pitch angles. So,
nmA = nmA/2.
;0.06 #/s-cm2-eV  (FOR 22 UT)
;0.05 #/s-cm2-eV  (FOR 23 UT)




;;******
;;NOT SURE IF WE NEED TO DO FIELD LINE FOCUSING OR NOT
;;What should be observed by BARREL is the MagEIS flux
;;enhanced by Bratio due to field line
;;focusing effect
;
;nb2A = nmA * Bratio
;;169.77872569302323  ;#/s-cm2-eV


;What does BARREL see?
;nb = ????

print,nb2A/nb

;adjust for non-isotropic flux (John
;Sample indicates that this is likely
;a factor of 3)
;print,nb2/nb/3.
print,nb2A/nb/3.








end
