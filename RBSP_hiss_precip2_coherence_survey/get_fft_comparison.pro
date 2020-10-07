
pro get_fft_comparison,var1,var2


  rbsp_efw_init

;*****TESTING*******
;    timespan,'2014-01-04/20:00',2,/hours
    t0 = time_double('2014-01-04/18:00')
    t1 = time_double('2014-01-05/00:00')
    var1 = 'omni_press_dyn'
    pmin = 10.
    pmax = 30.


;Get rid of NaN values in the peak detector data. This messes up the downsampling
  get_data,var1,data=dd
  goo = where(dd.y lt 0.)
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan
  xv = dd.x
  yv = dd.y
  interp_gap,xv,yv
  store_data,var1+'_nonan',data={x:xv,y:yv}
  options,var1+'_nonan','colors',250



    vtmp = tsample(var1+'_nonan',[t0,t1],times=t)
    store_data,var1+'_nonan_tmp',t,vtmp


	power_x = fft_power_calc(t,vtmp)

    freqs = power_x.freq*1000.
    power = power_x.power_x


    ;magic freqs (mHz) [from Villante et al., 2016]
    fmagicL = [0.7,1.3,3.3,4.4,5.9]
    fmagicH = [0.7,1.5,3.6,4.6,6.2]
    colormag = [0,50,100,150,200]
    plot,freqs,power;,/xlog,xrange=[0.1,10]
    for i=0,n_elements(fmagic)-1 do oplot,[fmagicL[i],fmagicL[i]],[-120,120],color=colormag[i]
    for i=0,n_elements(fmagic)-1 do oplot,[fmagicH[i],fmagicH[i]],[-120,120],color=colormag[i]







  rbsp_spec,var1,npts=256/2.,n_ave=1


  get_data,var1,data=po
  wavelet_to_tplot,po.x,po.y


  get_data,'press_omni_SPEC',data=dd
  store_data,'press_omni_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
  options,'press_omni_SPEC','spec',1
  options,'press_omni_SPEC','ytitle','SW Pressure!Cfluctuations!C[mHz]'


  ylim,'press_omni_SPEC',0.1,3,0
  zlim,'press_omni_SPEC',1,1d3,1
  ylim,'press_omni',0.1,30,1

  copy_data,'wavelet_power_spec','wavelet_omni'
  store_data,'wavelet_power_spec',/delete
  get_data,'wavelet_omni',data=wo
  store_data,'wavelet_omni',data={x:wo.x,y:wo.y,v:1000.*wo.v,spec:1}



  ylim,'wavelet_omni',0.2,3,1
  zlim,'wavelet_omni',1d-5,1d5
  tplot,['press_omni_SPEC','press_omni','wavelet_omni']



;; ;;Integrate pressure fluctuations from 0.1-3 mHz
;;   get_data,'press_omni_SPEC',data=pspec

;;   goodfreq = where((pspec.v ge 0.1) and (pspec.v le 3))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes_omni-0.1-3',data={x:pspec.x,y:sqrt(ptotes)}

;;   goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes_omni-3-10',data={x:pspec.x,y:sqrt(ptotes)}


;;Integrate pressure fluctuations from 0.1-3 mHz
  get_data,'wavelet_omni',data=pspec

  goodfreq = where((pspec.v ge 0.2) and (pspec.v le 3))
  ptotes = fltarr(n_elements(pspec.x))
  for jj=0L,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq]^2,/nan)
  store_data,'ptotesW_omni-0.2-3',data={x:pspec.x,y:ptotes}



  ;; goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
  ;; ptotes = fltarr(n_elements(pspec.x))
  ;; for jj=0L,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
  ;; store_data,'ptotesW_omni-3-10',data={x:pspec.x,y:sqrt(ptotes)}


;;****************
;;Calculate RMS pressure fluctuations
get_data,'press_omni_SPEC',data=po

bandw = reform(po.v) - shift(reform(po.v),1)
bandw[0] = 0.
bandw[24:n_elements(po.v)-1] = 0.
pt = fltarr(n_elements(po.x))

pall = po.y^2
for j=0L,n_elements(po.x)-1 do pt[j] = sqrt(total(pall[j,*]*bandw))  ;RMS method (Malaspina

store_data,'press_omni_rms',data={x:po.x,y:pt}

tplot,['press_omni_SPEC','press_omni_rms']

;;********************






end
