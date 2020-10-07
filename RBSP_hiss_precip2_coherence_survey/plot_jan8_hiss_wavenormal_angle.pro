;;Loads EMFISIS wave normal spectral values from SVD analysis. 
;;An example file is:
;; pn = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/EMFISIS/'
;; fnt = 'rbsp-a_wna-survey_emfisis-L4_20140108_v1.5.3.cdf'

;;....description of quantities
;; rbspa_b3  ;;PSD of Bparallel
;; rbspa_bsum  ;;Sum of three magnetic PSD
;; rbspa_bsumperp ;;Sum of two perp magnetic PSD
;; rbspa_cohb1_2 ;;coherence b/t Bperp1 and Bperp2
;; rbspa_cohb1_3 ;;coherence b/t Bperp1 and Bpar
;; rbspa_cohb2_3 ;;coherence b/t Bperp2 and Bpar
;; rbspa_e3  ;;PSD of Eparallel
;; rbspa_eigen  ;;deg of polarization of magnetic field from eigenvalues
;; rbspa_ellsvd  ;;ellipticity of magnetic field polarization
;; rbspa_esum  ;;Sum of three electric PSD
;; rbspa_esumperp ;;Sum of three perp electric PSD
;; rbspa_phpoy1_2_3  ;;Azimuthal angle of Poynting vector
;; rbspa_phsvd  ;;Azimuthal angle of wave vector
;; rbspa_plansvd ;;Planarity of magnetic field polarization
;; rbspa_plansvde ;;EM planarity
;; rbspa_polsvd  ;;Degree of magnetic field polarization in polarization plane
;; rbspa_poy1_2_3  ;;PSD of Poynting flux
;; rbspa_thpoy1_2_3 ;;Polar angle of Poynting vector
;; rbspa_thsvd  ;;Polar angle of wave vector





;;--------------------------------------------------
;;Load THEMIS A, D and E data showing the hiss
;;--------------------------------------------------

timespan,'2014-01-08'

;thm_load_efi,probe=['a','e'],datatype='vaf'
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/the_l2_efi_20140108_v01.cdf'
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l2_efi_20140108_v01.cdf'


thm_load_fft,probe=['a','e','d']
thm_load_fbk,probe=['a','e','d']
rbsp_load_efw_spec,probe='a',type='calibrated'
rbsp_load_efw_spec,probe='b',type='calibrated'

tplot,'the_fff_32_scm2'


get_data,'tha_fb2',data=fb

options,['*tha_fb*','*the_fb*'],'spec',1
tplot,'the_fb_edc12'
get_data,'the_fb_edc12',data=fb
print,fb.v

;      2689.00      572.000      144.200      36.2000      9.05000      2.26000
store_data,'the_e12dc_hiss',data={x:fb.x,y:reform(fb.y[*,2])}
tplot,'the_e12dc_hiss'





rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
rbsp_split_fbk,'a'

store_data,'*av*',/delete
rbsp_detrend,'*fbk*',60.*0.2




  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1	




emfisis_load_svd_spectrum_results,'rbsp-a_wna-survey_emfisis-L4_20140108_v1.5.3.cdf',$
                                  '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/EMFISIS/',$
                                  'rbspa_',min_bsum_val=1d-6



;;Calculate RMS amplitudes of the hiss and chorus
get_data,'rbspa_bsum',data=b
b.y[*,0:22] = 0.
b.y[*,41:64] = 0.
btotes = fltarr(n_elements(b.x))
bandw = b.v - shift(b.v,1)
bandw[0] = bandw[1]
power = b.y^2
for i=0L,n_elements(btotes)-1 do btotes[i] = sqrt(total(power[i,*] * bandw,/nan))
store_data,'rbspa_rms',data={x:b.x,y:btotes}
rbsp_detrend,'rbspa_rms',60.*0.6
rbsp_detrend,'rbspa_rms_smoothed',60.*10.



get_data,'the_fff_32_scm2',data=b
b.y[*,0:5] = 0.
b.y[*,20:31] = 0.
btotes = fltarr(n_elements(b.x))
bandw = b.v - shift(b.v,1)
bandw[0] = bandw[1]
power = b.y^2
for i=0L,n_elements(btotes)-1 do btotes[i] = sqrt(total(power[i,*] * bandw,/nan))
store_data,'the_rms',data={x:b.x,y:(btotes)}
rbsp_detrend,'the_rms',60.*0.6
rbsp_detrend,'the_rms_smoothed',60.*10.



rbsp_detrend,['rbspa_fbk1_7pk_4_smoothed','rbspa_fbk2_7pk_3_smoothed','rbspa_fbk2_7pk_4_smoothed','rbspa_fbk2_7pk_5_smoothed'],60.*8.



ylim,'rbspa_*',100,1000,1
ylim,'the_fff_32_scm2',100,1000,1
zlim,'the_fff_32_scm2',1d-8,1d-5,1
zlim,'rbspa_'+['bsum','b3','bsumperp'],1d-7,1d-5,1

;;Most of the power is in the perp components
tplot,'rbspa_'+['bsum','b3','bsumperp']

;;Most of the power is in Eperp
zlim,'rbspa_'+['esum','e3','esumperp'],1d-7,1d-3,1
tplot,'rbspa_'+['esum','e3','esumperp']

zlim,'rbspa_cohb1_2',0.8,1
zlim,'rbspa_ellsvd',0.6,1
zlim,'rbspa_eigen',0.6,1
zlim,'rbspa_phpoy1_2_3',-50,50
zlim,'rbspa_polsvd',0.6,1
ylim,['rbspa_total_smoothed_detrend','rbspa_rms_smoothed_detrend'],0,0,0
ylim,['rbspa_total_smoothed','rbspa_rms_smoothed'],0,0,0
ylim,['rbspa_fbk1_7pk_4_smoothed_detrend','rbspa_fbk2_7pk_3_smoothed_detrend','rbspa_fbk2_7pk_4_smoothed_detrend','rbspa_fbk2_7pk_5_smoothed_detrend'],0,0,0

tplot,['the_fff_32_scm2','the_rms_smoothed_detrend','rbspa_total_smoothed_detrend','rbspa_rms_smoothed_detrend','rbspa_bsum','rbspa_cohb1_2','rbspa_eigen','rbspa_ellsvd','rbspa_phpoy1_2_3','rbspa_phsvd','rbspa_plansvde','rbspa_polsvd']
tplot,['the_fff_32_scm2','the_rms_smoothed_detrend','rbspa_total_smoothed','rbspa_rms_smoothed_detrend','rbspa_bsum','rbspa_fbk1_7pk_4_smoothed_detrend','rbspa_fbk2_7pk_3_smoothed_detrend','rbspa_fbk2_7pk_4_smoothed_detrend','rbspa_fbk2_7pk_5_smoothed_detrend']






;;Plot linear scale version
ylim,['the_fff_32_scm2','rbspa_bsum','rbspa_cohb1_2','rbspa_eigen','rbspa_ellsvd','rbspa_phpoy1_2_3','rbspa_phsvd','rbspa_plansvde','rbspa_polsvd','rbspa_thsvd'],100,1000,0
zlim,'rbspa_phpoy1_2_3',-40,20,0

tplot,['the_fff_32_scm2','the_rms_smoothed_detrend','rbspa_total_smoothed_detrend','rbspa_rms_smoothed_detrend','rbspa_bsum','rbspa_cohb1_2','rbspa_eigen','rbspa_ellsvd','rbspa_phpoy1_2_3','rbspa_phsvd','rbspa_plansvde','rbspa_polsvd','rbspa_thsvd']


;;....description of quantities
;; rbspa_b3  ;;PSD of Bparallel
;; rbspa_bsum  ;;Sum of three magnetic PSD
;; rbspa_bsumperp ;;Sum of two perp magnetic PSD
;; rbspa_cohb1_2 ;;coherence b/t Bperp1 and Bperp2
;; rbspa_cohb1_3 ;;coherence b/t Bperp1 and Bpar
;; rbspa_cohb2_3 ;;coherence b/t Bperp2 and Bpar
;; rbspa_e3  ;;PSD of Eparallel
;; rbspa_eigen  ;;deg of polarization of magnetic field from eigenvalues
;; rbspa_ellsvd  ;;ellipticity of magnetic field polarization
;; rbspa_esum  ;;Sum of three electric PSD
;; rbspa_esumperp ;;Sum of three perp electric PSD
;; rbspa_phpoy1_2_3  ;;Azimuthal angle of Poynting vector
;; rbspa_phsvd  ;;Azimuthal angle of wave vector
;; rbspa_plansvd ;;Planarity of magnetic field polarization
;; rbspa_plansvde ;;EM planarity
;; rbspa_polsvd  ;;Degree of magnetic field polarization in polarization plane
;; rbspa_poy1_2_3  ;;PSD of Poynting flux
;; rbspa_thpoy1_2_3 ;;Polar angle of Poynting vector
;; rbspa_thsvd  ;;Polar angle of wave vector



ylim,'rbspb_efw_64_spec4',100,1000,1


;;Identify similar modulations in chorus and hiss
u0 = time_double('2014-01-08/21:30')
u1 = time_double('2014-01-08/22:40')
tplot,['the_fff_32_scm2','rbspa_efw_64_spec4','rbspa_bsum','rbspb_efw_64_spec4']
tlimit,u0,u1

u0 = time_double('2014-01-08/22:00')
u1 = time_double('2014-01-08/23:00')
tplot,['the_fff_32_scm2','rbspa_efw_64_spec4','rbspa_bsum','rbspb_efw_64_spec4']
tlimit,u0,u1



;;--------------------------------------------------
;;Extract slices of the power spectra and compare freq spectrum
;;--------------------------------------------------

!p.charsize = 2.5
tplot,['the_fff_32_scm2','rbspa_efw_64_spec4','rbspa_bsum']
get_data,'the_fff_32_scm2',data=dat1
;get_data,'rbspa_bsum',data=dat2
get_data,'rbspa_efw_64_spec4',data=dat2

;;Exact frequencies for themis: From Cully 2009, "The lower
;;freq of each bin is equal to the sum of the bandwidths below it,
;;starting from zero".
;;Themis Bandwidths from Table 2 (32-point spectra, 1024-point FFT)
bandwT = fltarr(32)
bandwT[0:15] = 16.
bandwT[16:19] = 64.
bandwT[20:23] = 128.
bandwT[24:27] = 256
bandwT[28:31] = 512

;;Now define actual THEMIS freqs based on Cully09
freqsT_low = fltarr(32)
for i=1,31 do freqsT_low[i] = total(bandwT[0:i-1])
freqsT_center = freqsT_low + bandwT/2.
freqsT_high = freqsT_low + bandwT



;;Exact spectral freqs on RBSP
fspec64_binsL=[indgen(16)*8, indgen(8)*16+128, $
			indgen(8)*32+256, indgen(8)*64+512,$
			indgen(8)*128+1024, indgen(8)*256+2048, $
			indgen(8)*512+4096]
fspec64_binsH=[(indgen(16)+1)*8, (indgen(8)+1)*16+128, $
			(indgen(8)+1)*32+256, (indgen(8)+1)*64+512,$
			(indgen(8)+1)*128+1024, (indgen(8)+1)*256+2048, $
			(indgen(8)+1)*512+4096]

fspec64_binsC = (fspec64_binsL + fspec64_binsH)/2





tshift = 60.*0.

;; ;---good timerange (don't delete!!!)
;; u0 = time_double('2014-01-08/21:40')
;; u1 = time_double('2014-01-08/22:00')

u0 = time_double('2014-01-08/21:30')
u1 = time_double('2014-01-08/22:40')
;; u0 = time_double('2014-01-08/22:09')
;; u1 = time_double('2014-01-08/22:14')
;; u0 = time_double('2014-01-08/22:10')
;; u1 = time_double('2014-01-08/22:40')
goo1 = where((dat1.x ge u0) and (dat1.x le u1))                         
goo2 = where((dat2.x ge u0+tshift) and (dat2.x le u1+tshift))    


title = time_string(u0) + ' to ' + strmid(time_string(u1),11,5)

vals1 = dat1.y[goo1,*]
vals2 = dat2.y[goo2,*]

med1 = fltarr(n_elements(dat1.v))
med2 = fltarr(n_elements(dat2.v))
for i=0,n_elements(dat1.v)-1 do med1[i] = median(reform(vals1[*,i]))
for i=0,n_elements(dat2.v)-1 do med2[i] = median(reform(vals2[*,i]))

!p.multi = [0,2,3]
;;themis E
plot,freqsT_center,reform(dat1.y[goo1[0],*]),xrange=[0,600],$
     /ylog,yrange=[1d-8,1d-4],/nodata,title=title
for i=0,n_elements(goo1)-1 do oplot,freqsT_center,reform(dat1.y[goo1[i],*]),psym=-4
oplot,freqsT_center,med1,thick=2,color=120,psym=-4
;;themis E
plot,freqsT_center,reform(dat1.y[goo1[0],*]),xrange=[100,1000],$
     /xlog,/ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo1)-1 do oplot,freqsT_center,reform(dat1.y[goo1[i],*]),psym=-4
oplot,freqsT_center,med1,thick=2,color=120,psym=-4

;;RBSP-A
plot,fspec64_binsC,reform(dat2.y[goo2[0],*]),xrange=[0,600],$
     /ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo2)-1 do oplot,fspec64_binsC,reform(dat2.y[goo2[i],*]),color=250,psym=-4
oplot,fspec64_binsC,med2,thick=2,color=120,psym=-4

;;RBSP-A
plot,fspec64_binsC,reform(dat2.y[goo2[0],*]),xrange=[100,1000],$
     /xlog,/ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo2)-1 do oplot,fspec64_binsC,reform(dat2.y[goo2[i],*]),color=250,psym=-4
oplot,fspec64_binsC,med2,thick=2,color=120,psym=-4

;;Both THE and RBSP-A median values
plot,freqsT_center,med1,xrange=[50,600],$
     /ylog,yrange=[1d-8,2d-6],thick=2,psym=-4,ystyle=1,/nodata,xstyle=1

oplot,freqsT_center,med1,thick=2,linestyle=1
oplot,freqsT_low,med1,thick=2,linestyle=4
oplot,freqsT_high,med1,thick=2,linestyle=4

oplot,fspec64_binsC,med2,thick=2,color=250,linestyle=1
oplot,fspec64_binsL,med2,thick=2,color=250,linestyle=4
oplot,fspec64_binsH,med2,thick=2,color=250,linestyle=4


plot,freqsT_center,med1,xrange=[100,1000],$
     /xlog,/ylog,yrange=[1d-8,2d-6],thick=2,psym=-4,ystyle=1,xstyle=1,/nodata

oplot,freqsT_center,med1,thick=2,linestyle=1
oplot,freqsT_low,med1,thick=2,linestyle=4
oplot,freqsT_high,med1,thick=2,linestyle=4

oplot,fspec64_binsC,med2,thick=2,color=250,linestyle=1
oplot,fspec64_binsL,med2,thick=2,color=250,linestyle=4
oplot,fspec64_binsH,med2,thick=2,color=250,linestyle=4




stop



;;--------------------------------------------------
;;plot y-slices of the chorus and hiss to compare
;;--------------------------------------------------


get_data,'rbspa_efw_64_spec4',data=dat1,dlim=dlim1,lim=lim1
get_data,'rbspb_efw_64_spec4',data=dat3,dlim=dlim3,lim=lim3
fhissa = dat1.v
fhissb = dat3.v

tinterpol_mxn,'the_fff_32_scm2','rbspa_efw_64_spec4'
tinterpol_mxn,'rbspb_efw_64_spec4','rbspa_efw_64_spec4'
;tinterpol_mxn,'rbspa_efw_64_spec4','the_fff_32_scm2'
get_data,'the_fff_32_scm2_interp',data=dat2,dlim=dlim2,lim=lim2
get_data,'rbspa_efw_64_spec4',data=dat1,dlim=dlim1,lim=lim1
get_data,'rbspb_efw_64_spec4_interp',data=dat3,dlim=dlim3,lim=lim3

t0 = time_double('2014-01-08/21:30')
t1 = time_double('2014-01-08/24:00')

yv = tsample('the_fff_32_scm2_interp',[t0,t1],times=tms)
store_data,'the_fff_32_scm2_tc',data={x:tms,y:yv,v:dat2.v,dlim:dlim2,lim:lim2}
yv = tsample('rbspa_efw_64_spec4',[t0,t1],times=tms)
store_data,'rbspa_efw_64_spec4_tc',data={x:tms,y:yv,v:fhissa,dlim:dlim2,lim:lim2}
yv = tsample('rbspb_efw_64_spec4_interp',[t0,t1],times=tms)
store_data,'rbspb_efw_64_spec4_tc',data={x:tms,y:yv,v:fhissb,dlim:dlim3,lim:lim3}

options,['rbspa_efw_64_spec4_tc','rbspb_efw_64_spec4_tc','the_fff_32_scm2_tc'],'spec',1
ylim,['rbspa_efw_64_spec4_tc','rbspb_efw_64_spec4_tc','the_fff_32_scm2_tc'],100,1000,1
zlim,['rbspa_efw_64_spec4_tc','rbspb_efw_64_spec4_tc','the_fff_32_scm2_tc'],1d-7,1d-4,1
zlim,['rbspa_efw_64_spec4','rbspb_efw_64_spec4_tc','the_fff_32_scm2'],1d-7,1d-4,1
tplot,['rbspa_efw_64_spec4_tc','the_fff_32_scm2_tc','rbspb_efw_64_spec4_tc']
tplot,['rbspa_efw_64_spec4','the_fff_32_scm2','rbspb_efw_64_spec4_tc']


get_data,'the_fff_32_scm2_tc',data=dat2
get_data,'rbspa_efw_64_spec4_tc',data=dat1,dlim=dlim1,lim=lim1
get_data,'rbspb_efw_64_spec4_tc',data=dat3,dlim=dlim3,lim=lim3
rbsp_detrend,'rbspa_efw_64_spec4_tc',60.*0.2
rbsp_detrend,'rbspb_efw_64_spec4_tc',60.*0.2
get_data,'rbspa_efw_64_spec4_tc_smoothed',data=goo
store_data,'rbspa_efw_64_spec4_tc_smoothed',data={x:goo.x,y:goo.y,v:dat1.v,dlim:dlim1,lim:lim1}
get_data,'rbspa_efw_64_spec4_tc_smoothed',data=dat1
get_data,'rbspb_efw_64_spec4_tc_smoothed',data=goo
store_data,'rbspb_efw_64_spec4_tc_smoothed',data={x:goo.x,y:goo.y,v:dat3.v,dlim:dlim3,lim:lim3}
get_data,'rbspb_efw_64_spec4_tc_smoothed',data=dat1

;freqval = 120.  ;Hz
;freqval = 130.  ;Hz
;freqval = 140.  ;Hz
;freqval = 190.
freqval = 200.
;freqval = 210.  ;Hz
;freqval = 220.  ;Hz
;freqval = 240.  ;Hz
f1 = where(dat1.v ge freqval)
f2 = where(dat2.v ge freqval)
f3 = where(dat3.v ge freqval)

!p.multi = [0,0,1]
plot,dat2.x-dat2.x[0],dat2.y[*,f2[0]],xtitle=$
     'seconds after 2014-01-08/21:30',title=$
     'freqhiss='+strtrim(floor(dat1.v[f1[0]]),2)+' Hz'+$
     '  freqchorus='+strtrim(floor(dat2.v[f2[0]]),2)+' Hz',xrange=[0,2000]
oplot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],color=250
oplot,dat3.x-dat3.x[0],dat3.y[*,f3[0]],color=50


!p.multi = [0,0,1]
plot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],xtitle=$
     'seconds after 2014-01-08/21:30',title=$
     'freqhiss='+strtrim(floor(dat1.v[f1[0]]),2)+' Hz'+$
     '  freqchorus='+strtrim(floor(dat2.v[f2[0]]),2)+' Hz',xrange=[0,1500],/nodata
oplot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],color=250
oplot,dat2.x-dat2.x[0],dat2.y[*,f2[0]]
oplot,dat3.x-dat3.x[0],dat3.y[*,f3[0]],color=50



!p.multi = [0,0,1]
plot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],xtitle=$
     'seconds after 2014-01-08/21:30',title=$
     'freqhissa='+strtrim(floor(dat1.v[f1[0]]),2)+' Hz'+$
     '  freqhissb='+strtrim(floor(dat3.v[f3[0]]),2)+' Hz',xrange=[0,1500],/nodata
oplot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],color=250
;oplot,dat2.x-dat2.x[0],dat2.y[*,f2[0]]
oplot,dat3.x-dat3.x[0],dat3.y[*,f3[0]],color=50


!p.multi = [0,0,1]
plot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],xtitle=$
     'seconds after 2014-01-08/21:30',title=$
     'freqhissa='+strtrim(floor(dat1.v[f1[0]]),2)+' Hz'+$
     '  freqhissb='+strtrim(floor(dat3.v[f3[0]]),2)+' Hz',yrange=[1d-8,1d-6],/ylog,xrange=[0,1500],/nodata
oplot,dat1.x-dat1.x[0],dat1.y[*,f1[0]],color=250
;oplot,dat2.x-dat2.x[0],dat2.y[*,f2[0]]
oplot,dat3.x-dat3.x[0],dat3.y[*,f3[0]],color=50





store_data,'dat1',data={x:dat1.x,y:reform(dat1.y[*,f1[0]])}
store_data,'dat2',data={x:dat2.x,y:reform(dat2.y[*,f2[0]])}
store_data,'dat3',data={x:dat3.x,y:reform(dat3.y[*,f3[0]])}
ylim,['dat1','dat2','dat3'],1d-9,1d-5,1
tplot,['dat1','dat2','dat3','rbspa_efw_64_spec4_tc','the_fff_32_scm2_tc','rbspb_efw_64_spec4_tc']
ylim,['dat1','dat2','dat3'],0,5d-6,0
tplot,['dat1','dat2','dat3']


;;compare RBSP-A and RBSP-B
ylim,['dat1','dat3'],1d-9,1d-5,1
tplot,['dat1','dat3','rbspa_efw_64_spec4_tc','rbspb_efw_64_spec4_tc']
ylim,['dat1','dat3'],0,5d-6,0
tplot,['dat1','dat3']


.compile /Users/aaronbreneman/Desktop/code/Aaron/IDL/analysis/plot_wavestuff.pro

store_data,'datcomb',data={x:dat1.x,y:[[reform(dat2.y[*,f2[0]])],[reform(dat1.y[*,f1[0]])],[reform(dat3.y[*,f3[0]])]]}


extra_psd = {yrange:[-120,-60],xrange:[0.1,30]/1000.,xlog:1}
plot_wavestuff,'datcomb',/psd,/nodelete,extra_psd=extra_psd,/postscript




;; !p.charsize = 2.5
;; tplot,['the_fff_32_scm2','rbspa_efw_64_spec4','rbspb_efw_64_spec4']
;; get_data,'the_fff_32_scm2',data=dat1
;; get_data,'rbspa_efw_64_spec4',data=dat2
;; get_data,'rbspb_efw_64_spec4',data=dat3


;; u0 = time_double('2014-01-08/22:20')
;; u1 = time_double('2014-01-08/22:50')
;; ;; u0 = time_double('2014-01-08/22:10')
;; ;; u1 = time_double('2014-01-08/22:25')
;; ;; u0 = time_double('2014-01-08/22:10')
;; ;; u1 = time_double('2014-01-08/22:40')
;; goo1 = where((dat1.x ge u0) and (dat1.x le u1))                         
;; goo2 = where((dat2.x ge u0+tshift) and (dat2.x le u1+tshift))    
;; goo3 = where((dat3.x ge u0+tshift) and (dat3.x le u1+tshift))    


;; title = time_string(u0) + ' to ' + strmid(time_string(u1),11,5)

;; vals1 = dat1.y[goo1,*]
;; vals2 = dat2.y[goo2,*]
;; vals3 = dat3.y[goo3,*]

;; med1 = fltarr(n_elements(dat1.v))
;; med2 = fltarr(n_elements(dat2.v))
;; med3 = fltarr(n_elements(dat3.v))
;; for i=0,n_elements(dat1.v)-1 do med1[i] = median(reform(vals1[*,i]))
;; for i=0,n_elements(dat2.v)-1 do med2[i] = median(reform(vals2[*,i]))
;; for i=0,n_elements(dat3.v)-1 do med3[i] = median(reform(vals3[*,i]))


;; ;;Both THE and RBSP-A median values

;; !p.multi = [0,1,0]
;; plot,freqsT_center,med1,xrange=[50,600],$
;;      /ylog,yrange=[1d-10,2d-6],thick=2,psym=-4,ystyle=1,/nodata,xstyle=1

;; oplot,freqsT_center,med1,thick=2,linestyle=1
;; oplot,freqsT_low,med1,thick=2,linestyle=4
;; oplot,freqsT_high,med1,thick=2,linestyle=4

;; oplot,fspec64_binsC,med2,thick=2,color=250,linestyle=1
;; oplot,fspec64_binsL,med2,thick=2,color=250,linestyle=4
;; oplot,fspec64_binsH,med2,thick=2,color=250,linestyle=4

;; oplot,fspec64_binsC,med3,thick=2,color=50,linestyle=1
;; oplot,fspec64_binsL,med3,thick=2,color=50,linestyle=4
;; oplot,fspec64_binsH,med3,thick=2,color=50,linestyle=4


;; plot,freqsT_center,med1,xrange=[100,1000],$
;;      /xlog,/ylog,yrange=[1d-8,2d-6],thick=2,psym=-4,ystyle=1,xstyle=1,/nodata

;; oplot,freqsT_center,med1,thick=2,linestyle=1
;; oplot,freqsT_low,med1,thick=2,linestyle=4
;; oplot,freqsT_high,med1,thick=2,linestyle=4

;; oplot,fspec64_binsC,med2,thick=2,color=250,linestyle=1
;; oplot,fspec64_binsL,med2,thick=2,color=250,linestyle=4
;; oplot,fspec64_binsH,med2,thick=2,color=250,linestyle=4









;;--------------------------------------------------
;;Calculate lag b/t the RMS chorus and hiss values. See if this
;;corresponds to a reasonable ULF wave velocity


t0 = time_double('2014-01-08/21:30')
t1 = time_double('2014-01-08/22:35')
t0 = time_double('2014-01-08/22:00')
t1 = time_double('2014-01-08/22:20')

time_clip,'the_rms_smoothed_detrend',t0,t1
time_clip,'rbspa_total_smoothed_detrend',t0,t1

tinterpol_mxn,'the_rms_smoothed_detrend_tclip','rbspa_total_smoothed_detrend_tclip'


get_data,'the_rms_smoothed_detrend_tclip_interp',data=d1
get_data,'rbspa_total_smoothed_detrend_tclip',data=d2

v1 = d1.y
v2 = d2.y
dt = d1.x[1]-d1.x[0]

npts = 1.
lag = indgen(n_elements(v1)/npts)
lag = lag - max(lag)/2.


result = c_correlate(v1,v2,lag)


lagv = npts*dt*lag/60.

plot,lagv,result,xrange=[-20,20]



end
