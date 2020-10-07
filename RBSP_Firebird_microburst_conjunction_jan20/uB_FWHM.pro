;Find FWHM values for the uB

pro ub_FWHM

tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/FB_calibrated_counts_flux.tplot'


rbsp_efw_init
timespan,'2016-01-20'
tplot,['flux1']

;From FIGURE 1 of paper:
t0z = '2016-01-20/19:43:30'
t1z = '2016-01-20/19:44:40'
tlimit,t0z,t1z


;Following method of Crew thesis, fit each uB with a
;Gaussian and calculate FWHM


dT_total = time_double(t1z) - time_double(t0z)



t0 = ['2016-01-20/19:43:32.878',$
     '2016-01-20/19:43:33.700',$
     '2016-01-20/19:43:34.575',$
     '2016-01-20/19:43:35.250',$
     '2016-01-20/19:43:40.725',$
     '2016-01-20/19:43:41.008',$
     '2016-01-20/19:43:41.964',$
     '2016-01-20/19:43:43.830',$
     '2016-01-20/19:43:44.120',$
     '2016-01-20/19:43:45.400',$
     '2016-01-20/19:43:49.890',$
     '2016-01-20/19:43:50.490',$
'2016-01-20/19:43:55.310',$
'2016-01-20/19:43:55.870',$
     '2016-01-20/19:43:56.620',$
     '2016-01-20/19:43:56.960',$
     '2016-01-20/19:43:57.840',$
     '2016-01-20/19:44:01.290',$
     '2016-01-20/19:44:02.000',$
     '2016-01-20/19:44:12.920',$
     '2016-01-20/19:44:18.480',$
     '2016-01-20/19:44:18.898',$
     '2016-01-20/19:44:19.091',$
     '2016-01-20/19:44:20.895',$
     '2016-01-20/19:44:32.940']
t0d = time_double(t0)
timebar,t0d

;peak value (no detrending)
A = [42.022471,55.730335,38.651684,24.324325,63.146066,58.651684,$
42.2441,85.617975,89.438200,27.3,57.078650,61.348313,$
48,48,84.494380,77.528088,61.123594,72.359549,54.00000,74.831459,$
78.1,82.47,84,73.,88.764043]
A *= 1.27



bg = [10,7,7,9,7,7,$
      20,8.3,7,10,10,10,$
      22,22,20,20,20,35,$
      35,43,60,65,70,65,30]
dt2 = [0.02,0.02,0.02,0.011,0.01,0.015,$
      0.12,0.015,0.025,0.007,0.01,0.012,$
      0.03,0.054,0.03,0.020,0.01,0.02,$
      0.02,0.02,0.02,0.022,0.010,0.01,0.02]

;bg = replicate(7,n_elements(A))  ;background flux
;dt2 = replicate(0.02,n_elements(A))  ;Gaussian width

A2 = A - bg        ;amplitude above background
A_hm = A2/2. + bg  ;amplitude of half max


;time of uB determined from the FWHM measurement
deltaT_fwhm = fltarr(n_elements(dt2))
avg_intensity = fltarr(n_elements(dt2))  ;the average intensity of the microburst


;i=13
;stop


for i=0,n_elements(dt2)-1 do begin
  t = 0.001*dindgen(1000) + (t0d[i]-0.001*500)  ;& $
  uB = A2[i]*exp(-1*(t-t0d[i])^2/dt2[i]) + bg[i] ;uB profile (above background)
  store_data,'gauss',t,ub  ;& $
  goo = where(uB ge A_hm[i]) ; & $
  ;extract width from the FWHM measurement
  deltaT_fwhm[i] = t[goo[n_elements(goo)-1]] - t[goo[0]]
  t2 = t[goo]  ;& $

  ub2 = ub[goo] ; & $
  store_data,'gauss2',t2,ub2  ;& $
  options,'gauss2','thick',2  ;& $
  store_data,'comb',data=['flux1','gauss','gauss2']  ;& $
  options,'comb','colors',[0,50,250]  ;& $
  options,'comb','thick',2  ;& $
  tplot,['comb']

  ;calculate average flux of each uB
  total_y = total(ub[goo])
  npts = n_elements(goo)
  avg_intensity[i] = total_y/npts

  print,'total_y = ',total_y
  print,'npts = ',npts
  print,'avg intensity = ',avg_intensity[i]
  print,'****************'

  stop
endfor


;Average duration of a single microburst (duty_cycle)
dt_fwhm = mean(deltaT_fwhm)
print,dt_fwhm
;Average flux above background
avg_int = mean(avg_intensity)
print,avg_int
;number of uB/sec
ub_sec = n_elements(A)/dT_total
print,ub_sec
;Effective uB amplitude
ffb_eff = avg_int * dt_fwhm * ub_sec
print,ffb_eff

stop
end
