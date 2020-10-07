;Plot 1 for paper


smootime = 2.
dettime = 80.


tplot_options,'title','from plot1.pro'
rbsp_efw_init

timespan,'2014-01-11',2,/days
omni_hro_load
rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*dettime
rbsp_detrend,'OMNI_HRO_1min_Pressure',60.*smootime
rbsp_detrend,'OMNI_HRO_1min_Pressure_smoothed',60.*dettime

load_barrel_lc,'2X',type='rcnt'
rbsp_detrend,'PeakDet_2X',60.*smootime
rbsp_detrend,'PeakDet_2X_smoothed',60.*dettime

load_barrel_lc,'2X',type='fspc'
load_barrel_lc,'2X',type='sspc'



;Characterize the dynamic pressure structures 
tplot,'OMNI_HRO_1min_' + ['flow_speed',$
'proton_density','Pressure',$
'Vx','Vy','Vz']

get_data,'OMNI_HRO_1min_BX_GSE',data=bx
get_data,'OMNI_HRO_1min_BY_GSE',data=by
get_data,'OMNI_HRO_1min_BZ_GSE',data=bz
bmag = sqrt(bx.y^2 + by.y^2 + bz.y^2)
store_data,'OMNI_HRO_1min_bmag',bx.x,bmag

tplot,'OMNI_HRO_1min_' + ['Pressure',$
'bmag','BX_GSE','BY_GSE','BZ_GSE']


;;-----------------------------
;COMPARE SMOOTHING METHODS (REVIEWER COMMENT) 
;THESE ALL GIVE BASICALLY IDENTICAL RESULTS 

;get_data,'PeakDet_2X',data=dd
;width = 60.*smootime/3.99
;result = smooth(dd.y,ceil(width),/nan)
;store_data,'PeakDet_2X_smoothedIDL',dd.x,result
;
;get_data,'PeakDet_2X_smoothedIDL',data=dd
;width = 60.*dettime/3.99
;result = smooth(dd.y,ceil(width),/nan)
;dettmp = dd.y - result
;store_data,'PeakDet_2X_detrendIDL',dd.x,dettmp
;
;get_data,'PeakDet_2X_smoothedIDL',data=dd
;result = gauss_smooth(dd.y,20000,/nan,width=width)
;dettmp = dd.y - result
;store_data,'PeakDet_2X_detrendGaussIDL',dd.x,dettmp
;
;get_data,'PeakDet_2X_smoothedIDL',data=dd
;result = gaussfit(dd.x,dd.y,nterms=3)
;dettmp = dd.y - result
;store_data,'PeakDet_2X_detrendGauss2IDL',dd.x,dettmp
;;Result = GAUSSFIT( X, Y [, A] [, CHISQ=variable] [, ESTIMATES=array] [, MEASURE_ERRORS=vector] [, NTERMS=integer{3 to 6}] [, SIGMA=variable] [, YERROR=variable])


;;Shows that IDL's boxcar is identical to my result
;;Gaussian smooth seems limited to the few min fluctuations. May be a limit of the size of the dataset?
;tplot,['PeakDet_2X_smoothedIDL','PeakDet_2X_smoothed','PeakDet_2X_detrendIDL','PeakDet_2X_smoothed_detrend','PeakDet_2X_detrendGaussIDL','PeakDet_2X_detrendGauss2IDL']
;------------------------------------------








;Integrate SSPC flux for >30 keV
get_data,'SSPC_2X',data=d
sspctmp = d.y[*,12:255]
sspctots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do sspctots[i] = total(sspctmp[i,*])
store_data,'sspc_gt30',d.x,sspctots


;---------------------------------------------------------------------------------------
;Calculate ExB drift motion of plasma
;---------------------------------------------------------------------------------------

ptmp = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

tplot_restore,filename=ptmp+'exb_20140111_tha.tplot'
copy_data,'Vx!CExB-drift!Ckm/s','tha_Vx!CExB-drift!Ckm/s'
copy_data,'Bfield_for_ExB','Bfield_for_ExB'
copy_data,'Efield_for_ExB','Efield_for_ExB'

options,'tha_Vx!CExB-drift!Ckm/s','ytitle','ExB-drift(xMGSE)!CTHa!C[km/s]'
tplot,['tha_Vx!CExB-drift!Ckm/s','Bfield_for_ExB','Efield_for_ExB']

rbsp_detrend,'tha_Vx!CExB-drift!Ckm/s',60.*dettime


t0z = time_double('2014-01-11/20:00')
t1z = time_double('2014-01-12/02:00')
yv = tsample('tha_Vx!CExB-drift!Ckm/s_detrend',[t0z,t1z],times=tms)
;dt = 10.88
dt = tms[1]-tms[0]
vals = total(-1*yv*dt,/cumulative)/6370.
store_data,'tha_sloshing_distance',tms,vals
options,'tha_sloshing_distance','ytitle','-1*radial sloshing distance!CTHa[RE]'



;-------------
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
fn = 'tha_l2_fgm_bmag_20140111_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = ''
times = ''
bmag = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bmag = [bmag,dat[1]]
endwhile
close,lun & free_lun,lun
nelem = n_elements(times)
times = times[1:nelem-1]
bmag = bmag[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bmag11',t2,float(bmag)

fn = 'tha_l2_fgm_bmag_20140112_v01.ascii'
openr,lun,path+fn,/get_lun
jnk = ''
times = ''
bmag = ''
for i=0,4 do readf,lun,jnk
while not eof(lun) do begin $
  readf,lun,jnk & $
  dat = strsplit(jnk,',',/extract) & $
  times = [times,dat[0]] & $
  bmag = [bmag,dat[1]]
endwhile
close,lun & free_lun,lun
nelem = n_elements(times)
times = times[1:nelem-1]
bmag = bmag[1:nelem-1]
t2 = time_double(times)
store_data,'tha_bmag12',t2,float(bmag)

get_data,'tha_bmag11',data=d11
get_data,'tha_bmag12',data=d12
store_data,'tha_bmag',[d11.x,d12.x],[d11.y,d12.y]

rbsp_detrend,'tha_bmag',60.*smootime
rbsp_detrend,'tha_bmag_smoothed',60.*dettime




energies = [1304.46,1717.47,2260.87,2976.85,3917.75,5157.26,6788.92,8936.37,11763.4,15484.9,20383.3,26831.4,27000.0,28000.0,29000.0,30000.0,31000.0,41000.0,52000.0,65500.0,93000.0,139000.,203500.,293000.,408000.,561500.,719500.]
pa_bins = [11.25, 33.75, 56.25,78.75, 101.25, 123.75, 146.25, 168.75]


;load number of energy flux?
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
nelem -= 1


;Data arrays
fluxv = strarr(nelem,27,8)    ;(time,energy,PA)
times = strarr(nelem)


vals = strsplit(finaldat,' ',/extract)
for i=0,nelem-1 do times[i] = vals[i,0]
for i=0,nelem-1 do fluxv[i,*,0] = vals[i,1:27,0]



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
  for i=0,nelem-1 do fluxv[i,*,q] = vals[i,1:27,0]

endfor

fluxv = float(fluxv)



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



;-----------------------------------------------------

;Plot the flux as a function of time for various PA bins
;energyi = 15.   ;30 keV
energyi = 17.   ;41 keV

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
rbsp_detrend,'fluxv11deg',60.*dettime


;~90 deg bin
pabin = 3.
fluxvtmp = reform(fluxv[*,energyi,pabin])
goo = where(fluxvtmp eq 0.)
if goo[0] ne -1 then fluxvtmp[goo] = !values.f_nan
store_data,'fluxv78deg',time_double(times),fluxvtmp
ylim,'fluxv78deg',1d5,1d6,1
ylim,'fluxv78deg',0,0,0
rbsp_detrend,'fluxv78deg',60.*dettime


;Shows how isotropic the distributions are.
store_data,'flux0_90_comb',data=['fluxv11deg','fluxv78deg']
store_data,'flux0_90_detrend_comb',data=['fluxv11deg_detrend','fluxv78deg_detrend']
options,'flux0_90_comb','colors',[0,250]
options,'flux0_90_detrend_comb','colors',[0,250]
tplot,['OMNI_HRO_1min_proton_density_detrend','flux0_90_comb','flux0_90_detrend_comb']


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
for t=0,ntimes-1 do for i=0,26 do for p=0,7 do fluxvbw[t,i,p] = fluxv[t,i,p]*bwtmp[i]



;Take subset that corresponds to >30 keV
fluxvbw = fluxvbw[*,energiesgood,*]
fluxv_nobw = fluxv[*,energiesgood,*]




;plot,energies[energiesgood],fluxv_nobw[goodt[0],*,0],/ylog,yrange=[0.01,1000]

;For each time integrate energies >30 keV
fluxvintegrated = reform(fluxvbw[*,0,*]) & fluxvintegrated[*] = 0.
for t=0,ntimes-1 do for p=0,7 do fluxvintegrated[t,p] = total(fluxvbw[t,*,p])
;print,fluxvintegrated[goodt[0],0]
;  2e+06  #/s-cm2-sr  THA >30 integrated # flux for 11 deg PA bin at 22:10 UT (L=8)


;store_data,'fluxv11deg_allenergies',time_double(times),reform(fluxv[*,*,pa_bins]),energies

store_data,'tha_flux',times[goodt],fluxvintegrated[*,0]

;----------------------------------------------
;Determine PSD fractional profile from POES data.

tplot_restore,filename=path+'POES_n18_2014_01_11.tplot'

;div_data,'n18_corrected_90_E1_flux','n18_corrected_0_E1_flux',newname='POES_fluxrat'
;div_data,'n18_corrected_90_E2_flux','n18_corrected_0_E2_flux',newname='POES_fluxrat2'
div_data,'n18_corrected_0_E1_flux','n18_corrected_90_E1_flux',newname='POES_fluxrat'
div_data,'n18_corrected_0_E2_flux','n18_corrected_90_E2_flux',newname='POES_fluxrat2'

;options,'POES_fluxrat','ytitle','NOAA-18 >30keV!Cflux ratio!C90deg/0deg'
;options,'POES_fluxrat2','ytitle','NOAA-18 >100keV!Cflux ratio!C90deg/0deg'
options,'POES_fluxrat','ytitle','NOAA-18 >30keV!Cflux ratio!C0deg/90deg'
options,'POES_fluxrat2','ytitle','NOAA-18 >100keV!Cflux ratio!C0deg/90deg'

get_data,'POES_fluxrat',data=dd
oneline = replicate(1.,n_elements(dd.x))
store_data,'oneline',dd.x,oneline
options,'oneline','linestyle',3

store_data,'POES_fluxrat_comb',data=['POES_fluxrat','oneline']
store_data,'POES_fluxrat2_comb',data=['POES_fluxrat2','oneline']

;store_data,'POES_fluxrat_comb',data=['POES_fluxrat','POES_fluxrat2']
;ylim,'POES_fluxrat_comb',0,10
;options,'POES_fluxrat_comb','colors',

store_data,'n18_corrected_0_flux_comb',data='n18_corrected_'+['0_E1_flux','90_E1_flux']
store_data,'n18_corrected_0_flux_comb2',data='n18_corrected_'+['0_E2_flux','90_E2_flux']
options,'n18_corrected_0_flux_comb','colors',[0,250]
options,'n18_corrected_0_flux_comb2','colors',[0,250]
options,['n18_L_IGRF','n18_MLT'],'panel_size',0.3

store_data,'comb_ultimate',data='n18_corrected_'+['0_E1_flux','90_E1_flux','0_E2_flux','90_E2_flux']
options,'n18_corrected_0_E1_flux','linestyle',0
options,'n18_corrected_90_E1_flux','linestyle',0
options,'n18_corrected_0_E2_flux','linestyle',5
options,'n18_corrected_90_E2_flux','linestyle',5
options,'comb_ultimate','colors',[0,250,0,250]
ylim,'comb_ultimate',1d2,1d6,1
options,'comb_ultimate','ytitle','NOAA-18 flux!Csolid=>30keV!Cdashed=>100keV!CBlack=parallel!Cred=perp'

;store_data,'n18_corrected_0_flux_comb2',data='n18_corrected_'+['0_E2_flux','90_E2_flux']
;options,'n18_corrected_0_flux_comb2','colors',[0,250]

;Ratio of 30 keV to 100 keV flux in loss cone
div_data,'n18_corrected_0_E1_flux','n18_corrected_0_E2_flux',newname='n18_corrected_0_flux_rat'
options,'n18_corrected_0_flux_rat','ytitle','Flux ratio!Cfield-aligned!C>30keV/>100keV'

ylim,'POES_fluxrat2_comb',0,1.5
ylim,'POES_fluxrat_comb',0,1.5
ylim,'n18_corrected_0_flux_rat',10,10000,1
ylim,'n18_corrected_0_flux_comb',1d2,1d6,1
ylim,'n18_corrected_0_flux_comb2',1d2,1d5,1


tplot,['comb_ultimate','n18_corrected_0_flux_rat','POES_fluxrat_comb','POES_fluxrat2_comb','n18_L_IGRF','n18_MLT']

;L-values at each min increment :       6.31000      7.92000      10.1400      13.2200      17.3200      21.9900
;MLT values at each min increment:        13.970000       13.660000       13.310000       12.840000       12.220000       11.440000







thm_load_fbk,probe='a'

split_vec,'tha_fb_scm1'
get_data,'tha_fb_scm1_0',data=d & store_data,'tha_fb_scm1_0pT',d.x,1000.*d.y & options,'tha_fb_scm1_0pT','ytitle','THA FBK [pT]!Cscm1 2689Hz'
get_data,'tha_fb_scm1_1',data=d & store_data,'tha_fb_scm1_1pT',d.x,1000.*d.y & options,'tha_fb_scm1_1pT','ytitle','THA FBK [pT]!Cscm1 670Hz'
get_data,'tha_fb_scm1_2',data=d & store_data,'tha_fb_scm1_2pT',d.x,1000.*d.y & options,'tha_fb_scm1_2pT','ytitle','THA FBK [pT]!Cscm1 160Hz'
get_data,'tha_fb_scm1_3',data=d & store_data,'tha_fb_scm1_3pT',d.x,1000.*d.y & options,'tha_fb_scm1_3pT','ytitle','THA FBK [pT]!Cscm1 40Hz'
get_data,'tha_fb_scm1_4',data=d & store_data,'tha_fb_scm1_4pT',d.x,1000.*d.y & options,'tha_fb_scm1_4pT','ytitle','THA FBK [pT]!Cscm1 9Hz'
get_data,'tha_fb_scm1_5',data=d & store_data,'tha_fb_scm1_5pT',d.x,1000.*d.y & options,'tha_fb_scm1_5pT','ytitle','THA FBK [pT]!Cscm1 2Hz'

;****TEMPORARY PLOT FOR PAPER
ylim,['tha_fb_scm1_3pT','tha_fb_scm1_2pT','tha_fb_scm1_1pT'],0,50
rbsp_detrend,['tha_fb_scm1_3pT','tha_fb_scm1_2pT','tha_fb_scm1_1pT'],60.*smootime
ylim,['tha_fb_scm1_3pT','tha_fb_scm1_2pT','tha_fb_scm1_1pT']+'_smoothed',0,50
tplot,['tha_fb_scm1_3pT','tha_fb_scm1_2pT','tha_fb_scm1_1pT']+'_smoothed'
tplot,['tha_fb_scm1_3pT','tha_fb_scm1_2pT','tha_fb_scm1_1pT']

split_vec,'tha_fb_edc12'
get_data,'tha_fb_edc12_0',data=d & store_data,'tha_fb_edc12_0mV_m',d.x,d.y & options,'tha_fb_edc12_0mV_m','ytitle','THA FBK [mV/m]!Cedc12 2689Hz'
get_data,'tha_fb_edc12_1',data=d & store_data,'tha_fb_edc12_1mV_m',d.x,d.y & options,'tha_fb_edc12_1mV_m','ytitle','THA FBK [mV/m]!Cedc12 670Hz'
get_data,'tha_fb_edc12_2',data=d & store_data,'tha_fb_edc12_2mV_m',d.x,d.y & options,'tha_fb_edc12_2mV_m','ytitle','THA FBK [mV/m]!Cedc12 160Hz'
get_data,'tha_fb_edc12_3',data=d & store_data,'tha_fb_edc12_3mV_m',d.x,d.y & options,'tha_fb_edc12_3mV_m','ytitle','THA FBK [mV/m]!Cedc12 40Hz'
get_data,'tha_fb_edc12_4',data=d & store_data,'tha_fb_edc12_4mV_m',d.x,d.y & options,'tha_fb_edc12_4mV_m','ytitle','THA FBK [mV/m]!Cedc12 9Hz'
get_data,'tha_fb_edc12_5',data=d & store_data,'tha_fb_edc12_5mV_m',d.x,d.y & options,'tha_fb_edc12_5mV_m','ytitle','THA FBK [mV/m]!Cedc12 2Hz'

rbsp_detrend,'tha_fb_scm1_?pT',60.*smootime
rbsp_detrend,'tha_fb_scm1_?pT_smoothed',60.*dettime

ylim,'tha_fb_scm1_?pT_smoothed_detrend',0,20
ylim,'tha_fb_scm1_?mV_m_smoothed_detrend',0,10







;Is this what we actually see?
store_data,'tha_flux_gt30keV_vs_time',time_double(times),fluxvintegrated[*,0]
tplot,'tha_flux_gt30keV_vs_time'
;rbsp_detrend,'tha_flux_gt30keV_vs_time',60.*5.
rbsp_detrend,'tha_flux_gt30keV_vs_time',60.*smootime
rbsp_detrend,'tha_flux_gt30keV_vs_time_smoothed',60.*dettime
div_data,'tha_flux_gt30keV_vs_time_smoothed_detrend','tha_flux_gt30keV_vs_time_smoothed',newname='flux_frac'


split_vec,'fluxv11deg_allenergies'
;rbsp_detrend,'fluxv11deg_allenergies_15',60.*smootime
;rbsp_detrend,'fluxv11deg_allenergies_15_smoothed',60.*dettime

rbsp_detrend,['tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT'],60.*smootime

;store_data,'tha_fb_scm_comb',data=['tha_fb_scm1_1pT_smoothed','tha_fb_scm1_2pT_smoothed','tha_fb_scm1_3pT_smoothed']
store_data,'tha_fb_scm_comb',data=['tha_fb_scm1_1pT','tha_fb_scm1_2pT','tha_fb_scm1_3pT']
options,'tha_fb_scm_comb','colors',[250,50,0]
ylim,'tha_fb_scm_comb',0,50
tplot,'tha_fb_scm_comb'



timespan,'2014-01-11/20:00',4.,/hours
ylim,'tha_bmag_smoothed_detrend',-8,5
ylim,'tha_flux_gt30keV_vs_time_smoothed_detrend',-6.d5,6.d5
ylim,'tha_sloshing_distance',-1.2,1.2
ylim,'flux_frac',-0.6,0.4
ylim,'tha_fb_scm1_3pT_smoothed_detrend',-15,15
ylim,'tha_fb_scm1_3pT_smoothed',5,40

tplot,['OMNI_HRO_1min_Pressure_smoothed_detrend',$
       'tha_bmag_smoothed_detrend',$
;       'flux_frac',$
       'tha_sloshing_distance',$
       'tha_flux_gt30keV_vs_time_smoothed_detrend',$
       'fluxv11deg_allenergies_15_smoothed_detrend',$
       ;'tha_fb_scm1_3pT_smoothed_detrend',$
       'tha_fb_scm1_3pT_smoothed',$
       'PeakDet_2X_smoothed_detrend']


       stop



;tplot,['OMNI_HRO_1min_Pressure_smoothed_detrend','PeakDet_2X_smoothed_detrend','tha_bmag_smoothed_detrend','flux_frac','tha_sloshing_distance','tha_flux_gt30keV_vs_time_detrend']
options,'fluxv11deg_allenergies','spec',1
get_data,'fluxv11deg_allenergies',data=d,dlim=dlim,lim=lim
vals = d.y[*,15,0]


;**********TRY TO ALIGN OMNI WITH BO WITH HIGH RES PLOT

rbsp_detrend,['OMNI_HRO_1min_Pressure','tha_bmag'],60.*dettime
tplot,['OMNI_HRO_1min_Pressure','tha_bmag']+'_detrend'



;;**************************Plot version w/o detrending
;
;tplot,['OMNI_HRO_1min_Pressure_smoothed',$
;       'PeakDet_2X_smoothed',$
;       'tha_bmag_smoothed',$
;       'flux_frac',$
;       'tha_sloshing_distance',$
;       'tha_flux_gt30keV_vs_time_smoothed',$
;       'fluxv11deg_allenergies_15_smoothed',$
;       'tha_fb_scm_comb']











path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
;THEMIS-A hires spectra (GMOM electrons, ESA + SST)
fn = 'tha_l2s_gmom_20140101000035_20140214235956.cdf'
cdf2tplot,path+fn

;Integrate hi-res THEMIS-A spectral e- flux (>20 keV)
get_data,'tha_pterf_en_eflux',data=d
fluxtmp = d.y[*,29:45]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'tha_fluxhires_int_gt20keV',d.x,fluxtots

;>30 keV integrated
get_data,'tha_pterf_en_eflux',data=d
fluxtmp = d.y[*,34:45]
fluxtots = fltarr(n_elements(d.x))
for i=0,n_elements(d.x)-1 do fluxtots[i] = total(fluxtmp[i,*])
store_data,'tha_fluxhires_int_gt30keV',d.x,fluxtots





;----------------------------------------------------------------
;Determine fractional changes relative to smooth background level
;----------------------------------------------------------------
;% = 100*[1 - (x - dx)/x]

rbsp_detrend,'tha_fluxhires_int_gt30keV',60.*smootime
rbsp_detrend,'tha_fluxhires_int_gt30keV_smoothed',60.*dettime
tplot,['tha_fluxhires_int_gt30keV_smoothed','tha_fluxhires_int_gt30keV_smoothed_detrend','tha_fluxhires_int_gt30keV_smoothed_smoothed']
store_data,'tha_fluxcomb',data=['tha_fluxhires_int_gt30keV_smoothed','tha_fluxhires_int_gt30keV_smoothed_smoothed']
tplot,'tha_fluxcomb'
dif_data,'tha_fluxhires_int_gt30keV_smoothed','tha_fluxhires_int_gt30keV_smoothed_detrend',newname='tmpp'
div_data,'tmpp','tha_fluxhires_int_gt30keV_smoothed',newname='tst'
get_data,'tst',data=d
d.y = 100.*(1 - d.y)
store_data,'tha_fluxhires_int_gt30keV_smoothed_percentchange',data=d
ylim,'tha_fluxhires_int_gt30keV_smoothed_percentchange',-100,100
tplot,['tha_fluxcomb','tha_fluxhires_int_gt30keV_smoothed_percentchange']


rbsp_detrend,'sspc_gt30',60.*smootime
rbsp_detrend,'sspc_gt30_smoothed',60.*dettime
tplot,['sspc_gt30_smoothed','sspc_gt30_smoothed_detrend','sspc_gt30_smoothed_smoothed']
store_data,'tha_precipcomb',data=['sspc_gt30_smoothed','sspc_gt30_smoothed_smoothed']
tplot,'tha_precipcomb'
dif_data,'sspc_gt30_smoothed','sspc_gt30_smoothed_detrend',newname='tmpp'
div_data,'tmpp','sspc_gt30_smoothed',newname='tst'
get_data,'tst',data=d
d.y = 100.*(1 - d.y)
store_data,'sspc_gt30_smoothed_percentchange',data=d
ylim,'sspc_gt30_smoothed_percentchange',-200,50
tplot,['tha_precipcomb','sspc_gt30_smoothed_percentchange']


rbsp_detrend,'tha_fb_scm1_3pT',60.*smootime
rbsp_detrend,'tha_fb_scm1_3pT_smoothed',60.*dettime
tplot,['tha_fb_scm1_3pT_smoothed','tha_fb_scm1_3pT_smoothed_detrend','tha_fb_scm1_3pT_smoothed_smoothed']
store_data,'tha_hisscomb',data=['tha_fb_scm1_3pT_smoothed','tha_fb_scm1_3pT_smoothed_smoothed']
tplot,'tha_hisscomb'
dif_data,'tha_fb_scm1_3pT_smoothed','tha_fb_scm1_3pT_smoothed_detrend',newname='tmpp'
div_data,'tmpp','tha_fb_scm1_3pT_smoothed',newname='tst'
get_data,'tst',data=d
d.y = 100.*(1 - d.y)
store_data,'tha_fb_scm1_3pT_smoothed_percentchange',data=d
ylim,'tha_fb_scm1_3pT_smoothed_percentchange',-150,150
tplot,['tha_hisscomb','tha_fb_scm1_3pT_smoothed_percentchange']


;Combine %change plots
store_data,'perchange',data=['tha_fluxhires_int_gt30keV_smoothed_percentchange','tha_fb_scm1_3pT_smoothed_percentchange','sspc_gt30_smoothed_percentchange']
options,'perchange','colors',[0,50,250]
ylim,'perchange',-100,100


;Change to keV
store_data,'fluxv11deg_allenergies2',d.x,d.y[*,*,0],d.v/1000.,dlim=dlim,lim=lim
;store_data,'tha_flux_gt30keV_vs_time'
ylim,'fluxv11deg_allenergies2',1,300,1
zlim,'fluxv11deg_allenergies2',1,1000,1
ylim,'SSPC_2X',1,300,1
tplot,['SSPC_2X','fluxv11deg_allenergies2','tha_flux_gt30keV_vs_time_smoothed_detrend','tha_fluxhires_int_gt30keV_detrend','tha_sloshing_distance']

tplot,['tha_fluxhires_int_gt30keV_percentchange','tha_fb_scm1_3pT_percentchange','sspc_gt30_percentchange','tha_sloshing_distance']

;.compile /Users/aaronbreneman/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/projects/themis/examples/advanced/thm_crib_scpot2dens.pro
;.run /Users/aaronbreneman/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/projects/themis/examples/advanced/thm_crib_scpot2dens.pro

stop
end
