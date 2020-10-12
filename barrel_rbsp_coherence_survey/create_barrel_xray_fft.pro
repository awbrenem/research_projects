;;FFT all the BARREL FSPC data and save to tplot variables. 
;;This only needs to be run once
;;
;;Also plot the coherence b/t each individual payload and the solar
;;wind pressure fluctuations

pro create_barrel_xray_fft

  rbsp_efw_init

;;--------------------------------------------------

;;Entire BARREL mission 2
  timespan,'2013-12-25',53,/days


  omni_hro_load
  copy_data,'OMNI_HRO_1min_Pressure','press_omni'


;Get rid of NaN values in the peak detector data. This messes up the downsampling
  get_data,'press_omni',data=dd
  goo = where(dd.y lt 0.)
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan
  xv = dd.x
  yv = dd.y
  interp_gap,xv,yv
  store_data,'press_omni',data={x:xv,y:yv}
  options,'press_omni','colors',250


  rbsp_spec,'press_omni',npts=256/2.,n_ave=1


  get_data,'press_omni',data=po
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





;;--------------------------------------------------
;;Calculate higher cadence pressure from Wind data (NOTE THAT THIS CAN
;;DIFFER STRONGLY FROM OMNI DATA, PRESUMABLY DUE TO SW EVOLUTION)
;;--------------------------------------------------


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/wind/barrel_mission2/'
fn = 'wi_ems_3dp_20131225000000_20140214235958.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
cdf2tplot,files=path+fn
fn = 'wi_k0s_swe_20131225000105_20140214235829.cdf'
cdf2tplot,files=path+fn
fn = 'wi_pms_3dp_20131225000002_20140215000000.cdf'
cdf2tplot,files=path+fn



paath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/wind/'
cdf2tplot,paath+'wi_ems_3dp_20131225000000_20140220235958.cdf'
cdf2tplot,paath+'wi_pms_3dp_20131225000002_20140221000000.cdf'
cdf2tplot,paath+'wi_k0s_swe_20131225000105_20140220235837.cdf'


;; copy_data,'E_DENS','wi_dens_hires'
copy_data,'P_DENS','wi_dens_hires'
copy_data,'V_GSE','wi_swe_V_GSE'
split_vec,'wi_swe_V_GSE'


;; remove NaN values
get_data,'wi_dens_hires',data=dd
goo = where(dd.y lt 0.)   
if goo[0] ne -1 then dd.y[goo] = !values.f_nan  
xv = dd.x   
yv = dd.y   
interp_gap,xv,yv   
store_data,'wi_dens_hires',data={x:xv,y:yv}   


;;blanket timeshift
dt = 0.
get_data,'wi_dens_hires',data=dd
store_data,'wi_dens_hires_shift',data={x:dd.x+dt*60.,y:dd.y}

get_data,'wi_swe_V_GSE_x',data=dd
store_data,'wi_swe_V_GSE_x_shift',data={x:dd.x+dt*60.,y:dd.y}


;; rbsp_detrend,'wi_dens_hires',60.*0.4



;; ;;--------------------------------------------------
;; ;;Calculate dynamic pressure as n*v^2
;; ;;--------------------------------------------------
;; ;;From OMNIWeb
;; ;;Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;; ;;Vp in km/s, subscript "p" for "proton")


;; get_data,'wi_swe_V_GSE_x_shift',data=vv
;; get_data,'wi_dens_hires_shift',data=dd
;; ;change velocity to m/s
;; vsw = vv.y
;; ;change number density to 1/m^3
;; dens = dd.y


;; vsw_mean = mean(vsw)
;; dens_mean = mean(dens)


;; ;;Pressure in nPa (rho*v^2)
;; press_proxy = 2d-6 * dens * vsw^2
;; store_data,'press_wind',data={x:vv.x,y:press_proxy}
;; ;;calculate pressure using averaged Vsw value
;; press_proxy = 2d-6 * dens * vsw_mean^2 
;; store_data,'press_proxy_constant_vsw',data={x:vv.x,y:press_proxy}
;; ;;calculate pressure using averaged density value
;; press_proxy = 2d-6 * dens_mean * vsw^2 
;; store_data,'press_proxy_constant_dens',data={x:vv.x,y:press_proxy}

;; store_data,'pressure_compare',$
;;            data=['press_wind','press_proxy_constant_dens','press_proxy_constant_vsw']


;; store_data,'pressure_compare_dec',$
;;            data=['press_proxy_dec','press_proxy_constant_dens_dec','press_proxy_constant_vsw_dec']

;; options,'pressure_compare','colors',[0,50,250]
;; options,'pressure_compare_dec','colors',[0,50,250]

;; ;; remove NaN values
;; get_data,'press_wind',data=dd
;; goo = where(dd.y lt 0.)   
;; if goo[0] ne -1 then dd.y[goo] = !values.f_nan  
;; xv = dd.x   
;; yv = dd.y   
;; interp_gap,xv,yv   
;; store_data,'press_wind',data={x:xv,y:yv}   


;; ;;--------------------------------------------------


  ;; rbsp_spec,'press_wind',npts=256/2.,n_ave=1

  ;; get_data,'press_wind_SPEC',data=dd
  ;; store_data,'press_wind_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
  ;; options,'press_wind_SPEC','spec',1
  ;; options,'press_wind_SPEC','ytitle','SW Pressure!Cfluctuations!C[mHz]'


  ;; ylim,'press_wind_SPEC',0.2,3,0
  ;; zlim,'press_wind_SPEC',1,1d3,1
  ;; ylim,'press_wind',0.2,30,1

  ;; tplot,['press_wind_SPEC','press_wind']



;; ;;Integrate pressure fluctuations from 0.1-3 mHz
;;   get_data,'press_wind_SPEC',data=pspec

;;   goodfreq = where((pspec.v ge 0.1) and (pspec.v le 3))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes_wind-0.1-3',data={x:pspec.x,y:sqrt(ptotes)}

;;   goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes_wind-3-10',data={x:pspec.x,y:sqrt(ptotes)}



  ;; tplot,['press_omni_SPEC','press_wind_SPEC','press_omni','press_wind',$
  ;;        'wavelet_omni','press_omni_rms']


;;--------------------------------------------------
;;Now load single balloon payloads
;;--------------------------------------------------


  plds = ['i','t','w','k','l','x','a','b','e','o','p']

  i = 3.
  pre = '2'
  p1 = plds[i]
  fspcS = 'fspc'

  fileroot = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/distance_from_pp_files/'
  tplot_restore,filenames=fileroot+'2'+strupcase(p1)+'.tplot' ;need .tplot
  ylim,'dist_pp_2?_bin*',-1.2,1.2



  path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide/'
  path2 = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/single_payload_fft/'
  fn1 = 'barrel_'+pre+p1+'_'+fspcS+'_fullmission.txt'



  v1 = fspcS + '_'+pre+p1


  load_barrel_data_noartifacts,path,fn1,fspcS,pre+p1,times=times1

  ;; load_barrel_plasmapause_distance,pre+p1






;Get rid of NaN values in the peak detector data. This messes up the downsampling
  get_data,'fspc_2'+p1,data=dd
  goo = where(dd.y lt 0.)
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan
  xv = dd.x
  yv = dd.y
  interp_gap,xv,yv
  store_data,'fspc_2'+p1,data={x:xv,y:yv}
  options,'fspc_2'+p1,'colors',250


  rbsp_spec,'fspc_2'+p1,npts=256*8,n_ave=1

  get_data,'fspc_2'+p1+'_SPEC',data=dd
  store_data,'fspc_2'+p1+'_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
  options,'fspc_2'+p1+'_SPEC','spec',1
  options,'fspc_2'+p1+'_SPEC','ytitle','Xray!Cfluctuations!C[mHz]'



  ylim,['fspc_2'+p1+'_SPEC'],0.2,3,0
  zlim,'fspc_2'+p1+'_SPEC',1,5d4,1
  ylim,'fspc_2'+p1,0,0
  ylim,'totes*',0,0
  

  get_data,'fspc_2'+p1,data=po
  wavelet_to_tplot,po.x,po.y;,dscale=0.1

  copy_data,'wavelet_power_spec','wavelet_fspc_2'+p1
  get_data,'wavelet_fspc_2'+p1,data=wo
  store_data,'wavelet_fspc_2'+p1,data={x:wo.x,y:wo.y,v:1000.*wo.v,spec:1}
  store_data,'wavelet_power_spec',/delete


  ylim,'wavelet_fspc_2'+p1,0.2,3,1
  zlim,'wavelet_fspc_2'+p1,1d-5,1d5  


  get_data,'wavelet_fspc_2'+p1,data=pspec

  goodfreq = where((pspec.v ge 0.2) and (pspec.v le 3))
  ptotes = fltarr(n_elements(pspec.x))
  for jj=0L,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq]^2,/nan)
  store_data,'xtotesW_fspc_2'+p1+'-0.2-3',data={x:pspec.x,y:ptotes}
  ylim,'xtotesW_fspc_2'+p1+'-0.2-3',min(ptotes,/nan),max(ptotes,/nan),1



;;Integrate density fluctuations from 0.2-3 mHz

;; ;;****************
;; ;;Calculate RMS pressure fluctuations
;; tinterpol_mxn,'fspc_2'+p1+'_SPEC','press_omni_SPEC'

;; get_data,'fspc_2'+p1+'_SPEC_interp',data=po

;; bandw = reform(po.v) - shift(reform(po.v),1)
;; bandw[0:1] = 0.
;; bandw[24:n_elements(po.v)-1] = 0.
;; pt = fltarr(n_elements(po.x))

;; pall = po.y^2
;; for j=0L,n_elements(po.x)-1 do pt[j] = sqrt(total(pall[j,*]*bandw))  ;RMS method (Malaspina

;; store_data,'fspc_2'+p1+'_rms',data={x:po.x,y:pt}

;; ;;********************

;; store_data,'rmscomb',data=['press_omni_rms','fspc_2'+p1+'_rms']
;; options,'rmscomb','colors',[0,250]

;;Make sure to keep FFT box larger enough that OMNI interpolation
;;issues aren't important

ylim,'press_omni_SPEC',0.2,3,0
ylim,'fspc_2'+p1+'_SPEC',0.2,3,0
ylim,'OMNI_HRO_1min_percent_interp',0,100
tplot,['press_omni_SPEC','press_omni_rms','fspc_2'+p1+'_SPEC','fspc_2'+p1+'_rms',$
      'lshell_2'+p1,'mlt_2'+p1,'OMNI_HRO_1min_percent_interp']


  get_data,'fspc_2'+p1+'_SPEC',data=pspec
  goodfreq = where((pspec.v ge 0.2) and (pspec.v le 3))
  ptotes = fltarr(n_elements(pspec.x))
  for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq]^2,/nan)
  store_data,'xtotes-0.2-3',data={x:pspec.x,y:ptotes}

  ;; goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
  ;; ptotes = fltarr(n_elements(pspec.x))
  ;; for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
  ;; store_data,'xtotes-3-10',data={x:pspec.x,y:sqrt(ptotes)}

  ;; goodfreq = where((pspec.v ge 10) and (pspec.v le 50))
  ;; ptotes = fltarr(n_elements(pspec.x))
  ;; for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
  ;; store_data,'xtotes-10-50',data={x:pspec.x,y:sqrt(ptotes)}


  ;; tplot,['fspc_2'+p1+'_SPEC','fspc_2'+p1,'xtotes*']





;;--------------------------------------------------
;;compute dynamic cross-correlation
;;--------------------------------------------------


  ;;band4 (0.2-3 mHz)
  window_minutes = 2*90.
  window = 60.*window_minutes
  lag = window/8.  ;size of each individual FFT box
  coherence_time = window*2.5

  v1 = 'press_omni'
  v2 = 'fspc_2'+p1
  TT1 = time_double('2013-12-25')
  TT2 = time_double('2014-02-17')
  pp1 = 'o'
  pp2 = strupcase(p1)

  dynamic_cross_spec_tplot,v1,0,v2,0,TT1,TT2,window,lag,coherence_time,$
                           new_name='Precip_hiss'  

  copy_data,'Precip_hiss_coherence','coh_'+pp1+pp2+'_band4'
  get_data,'coh_'+pp1+pp2+'_band4',data=coh
  store_data,'coh_'+pp1+pp2+'_band4',data={x:coh.x,y:coh.y,v:coh.v*1000.,spec:1}
  ;;--------------------

  cormin = 0.4
  get_data,'coh_'+pp1+pp2+'_band4',data=coh_band4
  goo = where(coh_band4.y lt cormin)
  if goo[0] ne -1 then coh_band4.y[goo] = !values.f_nan
  store_data,'coh_'+pp1+pp2+'_band4',data=coh_band4

  band4 = [0.2,3]
  ylim,'coh_'+pp1+pp2+'_band4',band4
  zlim,'coh_'+pp1+pp2+'_band4',cormin,1,0

  get_data,'coh_'+pp1+pp2+'_band4',data=coh
  goo = where((coh.v gt band4[0]) and (coh.v le band4[1]))
  totes = fltarr(n_elements(coh.x))
  for i=0L,n_elements(coh.x)-1 do totes[i] = (total(coh.y[i,goo],/nan)/n_elements(goo))^3
  store_data,'totes_band4',data={x:coh.x,y:totes}

  goo = where((coh_band4.v ge band4[0]) and (coh_band4.v le band4[1]),nelem)
  ylim,'totes_band4',0,1


;; ;;Calculate RMS pressure fluctuations
;; get_data,'coh_oI_band4',data=po

;; bandw = reform(po.v) - shift(reform(po.v),1)
;; bandw[0:2] = 0.
;; bandw[65:n_elements(po.v)-1] = 0.
;; pt = fltarr(n_elements(po.x))

;; pall = po.y^2
;; for j=0L,n_elements(po.x)-1 do pt[j] = sqrt(total(pall[j,*]*bandw,/nan))  ;RMS method (Malaspina

;; store_data,'coh_oI_rms',data={x:po.x,y:pt}

  get_data,'dist_pp_2'+strupcase(p1),data=dist
  zeros = replicate(0.,n_elements(dist.x))
  store_data,'zeros',data={x:dist.x,y:zeros}
  options,'zeros','linestyle',4
  store_data,'dist_pp_2'+strupcase(p1)+'_comb',data=['zeros','dist_pp_2'+strupcase(p1)]


  lf = band4[0]/1000.
  hf = band4[1]/1000.
  pl = 1/lf
  ph = 1/hf
  rbsp_detrend,v2,ph
  rbsp_detrend,v2+'_smoothed',pl
  copy_data,v2+'_smoothed_detrend',v2+'_band4'
  ylim,'coh_'+pp1+pp2+'_band4',0.2,3,0
  ylim,'coh_'+pp1+pp2+'_rms',0.5,max(pt,/nan)
  ylim,'totes_band4',0,0
  ylim,'dist_pp_2'+strupcase(p1)+'_comb',-5,5

  zlim,'wavelet_fspc_2'+p1,1d-3,1d6,1
  zlim,'wavelet_omni',1d-3,1d4,1
  ylim,'coh_'+pp1+pp2+'_band4',0.2,3,1
  ;; ylim,'xtotesW_fspc_2'+p1+'-0.2-3',0,1d10
  zlim,'xtotesW_fspc_2'+p1+'-0.2-3',1d-5,1d8,1


  tplot_options,'panel_size',1

  options,'coh_'+pp1+pp2+'_band4','ytitle','Coh '+pp1+pp2+'!CmHz'
  options,'totes_band4','ytitle','Coh total^2!C0.2-3mHz'
  options,'wavelet_omni','ytitle','Press OMNI!C[Hz]'
  options,'ptotesW_omni-0.2-3','ytitle','Press total^2!C0.2-3mHz'
  options,'wavelet_fspc_2'+p1,'ytitle',v2+'!C[Hz]'
  options,'xtotesW_fspc_2'+p1+'-0.2-3','ytitle','Xray total^2!C0.2-3mHz'

  tplot_options,'title','from create_barrel_xray_fft.pro'

  options,['wavelet_fspc_2'+p1,'wavelet_omni'],'panel_size',1


  tplot,['press_omni',$
         v2+'_smoothed',$
         'coh_'+pp1+pp2+'_band4',$
         'totes_band4',$
;         'press_omni_SPEC',$
         'wavelet_omni',$
         'ptotesW_omni-0.2-3',$
;         'press_omni_rms',$
;         'fspc_2'+p1+'_rms',$
;         'xtotes-0.2-3',$
         'wavelet_fspc_2'+p1,$
         'xtotesW_fspc_2'+p1+'-0.2-3',$
         'mlt_2'+p1,'lshell_2'+p1,$
         'dist_pp_2'+strupcase(p1)+'_comb','dist_pp_2'+strupcase(p1)+'_bin_0.5']
;         v2+'_band4']
  




  stop

end



