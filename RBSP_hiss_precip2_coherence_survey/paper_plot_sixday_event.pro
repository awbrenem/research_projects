;;formerly called plot_coh_tplot.pro

rbsp_efw_init

fileroot = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/tplot_vars_2014/'

pre = '2'
p1 = 'K'
p2 = 'L'

v1 = 'fspc_'+pre+p1+'_smoothed'
v2 = 'fspc_'+pre+p2+'_smoothed'

tplot_restore,filenames=fileroot+p1+p2+'.tplot' ;need .tplot

ylim,'delta_lshell',0,10

options,'mlt?','panel_size',0.5

;;set up yaxis labels
options,'*totes*','color',1
options,'coh_totes_band0_'+pre+p1+p2,'ytitle','Total!Ccoherence!Cband0'
options,'coh_totes_band1_'+pre+p1+p2,'ytitle','Total!Ccoherence!Cband1'
options,'coh_totes_band2_'+pre+p1+p2,'ytitle','Total!Ccoherence!Cband2'
options,'coh_totes_band3_'+pre+p1+p2,'ytitle','Total!Ccoherence!Cband3'
options,'coh_totes_band4_'+pre+p1+p2,'ytitle','Total!Ccoherence!Cband4'
options,'mlt_'+pre+p1,'ytitle','MLT '+p1
options,'mlt_'+pre+p2,'ytitle','MLT '+p2


options,v1+'_smoothed','ytitle','BARREL FSPC 1!C'+p1
options,v2+'_smoothed','ytitle','BARREL FSPC 1!C'+p2
options,'coh_'+p1+p2,'ytitle','Coherence '+p1+p2+'!C[mHz]'
options,'coh_'+p1+p2+'_band0','ytitle','Coherence '+p1+p2+'!C[mHz]'
options,'coh_'+p1+p2+'_band1','ytitle','Coherence '+p1+p2+'!C[mHz]'
options,'coh_'+p1+p2+'_band2','ytitle','Coherence '+p1+p2+'!C[mHz]'
options,'coh_'+p1+p2+'_band3','ytitle','Coherence '+p1+p2+'!C[mHz]'
options,'coh_'+p1+p2+'_band4','ytitle','Coherence '+p1+p2+'!C[mHz]'

;;--------------------------------------------------
;;Get Wind data
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



;;shift the Wind data by a set amount
get_data,'P_DENS',data=dd
store_data,'P_DENS',data={x:dd.x+60.*42,y:dd.y}

tplot,['E_DENS','elect_density','Np','Np_l','P_DENS']
tplot,['P_DENS','Pressure_omni']


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'P_DENS',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'P_DENS',data={x:xv,y:yv}
options,'P_DENS','colors',250


;; rbsp_spec,'Pressure2',npts=256/2,n_ave=1
rbsp_spec,'P_DENS',npts=256*16,n_ave=1

get_data,'P_DENS_SPEC',data=dd
store_data,'P_DENS_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
options,'P_DENS_SPEC','spec',1
;; ylim,'P_DENS_SPEC',0.4,10,1

options,'P_DENS_SPEC','ytitle','SW Pressure!Cfluctuations!C[mHz]'



ylim,['Pressure_omni_SPEC','P_DENS_SPEC'],0.1,3,0
zlim,'P_DENS_SPEC',1,1d3,1
zlim,'Pressure_omni_SPEC',1,1000,1
tplot,['Pressure_omni_SPEC','P_DENS_SPEC']






;;--------------------
;;Pressure from read_omni_cdf.pro
;;--------------------

;; .compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/OMNI/read_omni_cdf.pro

read_omni_cdf

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'Pressure',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'Pressure_omni',data={x:xv,y:yv}
options,'Pressure_omni','colors',250



;; rbsp_spec,'Pressure2',npts=256/2,n_ave=1
rbsp_spec,'Pressure_omni',npts=256,n_ave=1

get_data,'Pressure_omni_SPEC',data=dd
store_data,'Pressure_omni_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
options,'Pressure_omni_SPEC','spec',1
;; ylim,'Pressure_omni_SPEC',0.4,10,1

options,'Pressure_omni_SPEC','ytitle','SW Pressure!Cfluctuations!C[mHz]'

tplot,['E_DENS','elect_density','Np','Np_l','P_DENS','Pressure_omni_SPEC']


stop

;;--------------------------------------------------
;;Wavelet pressure on OMNI
;;--------------------------------------------------


  get_data,'Pressure_omni',data=po
  wavelet_to_tplot,po.x,po.y,dscale=0.125/2.

  get_data,'wavelet_power_spec',data=dd
  store_data,'Pressure_omni_wavelet',$
             data={x:dd.x,y:dd.y,v:1000*dd.v,spec:1,$
                   ytitle:'SW Pressure!Cfluctuations!C[mHz]'}



  ylim,'Pressure_omni_wavelet',0.1,3,0
  zlim,'Pressure_omni_wavelet',1,1d3,1
  ;; ylim,'Pressure_omni',0.1,30,1




;;Integrate pressure fluctuations from 0.1-3 mHz
  get_data,'Pressure_omni_wavelet',data=pspec

  goodfreq = where((pspec.v ge 0.1) and (pspec.v le 3))
  ptotes = fltarr(n_elements(pspec.x))
  for jj=0L,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
  store_data,'ptotesW_omni-0.1-3',data={x:pspec.x,y:sqrt(ptotes)}

  goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
  ptotes = fltarr(n_elements(pspec.x))
  for jj=0L,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
  store_data,'ptotesW_omni-3-10',data={x:pspec.x,y:sqrt(ptotes)}



stop

;;--------------------
;;OMNI pressure and precipitation, payload 1 (0.1-3 mHz)
window_minutes = 2*90.
window = 60.*window_minutes
lag = window/8.
coherence_time = window*2.5


T1 = '2014-01-07'
T2 = '2014-01-14'

dynamic_cross_spec_tplot,'Pressure_omni',0,v1,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'  
;; dynamic_cross_spec_tplot,'P_DENS',0,v1,0,T1,T2,window,lag,coherence_time,$
;;                          new_name='Precip_hiss'  

copy_data,'Precip_hiss_coherence','coh_pressure'+p1+'_band4'
get_data,'coh_pressure'+p1+'_band4',data=coh
store_data,'coh_pressure'+p1+'_band4',data={x:coh.x,y:coh.y,v:coh.v*1000.,spec:1}
get_data,'coh_pressure'+p1+'_band4',data=coh_press


cormin=0.4
goo = where(coh_press.y lt cormin)
if goo[0] ne -1 then coh_press.y[goo] = !values.f_nan
store_data,'coh_pressure'+p1+'_band4',data=coh_press



;;--------------------
;;OMNI pressure and precipitation, payload 2 (0.1-3 mHz)
window_minutes = 2*90.
window = 60.*window_minutes
lag = window/8.
coherence_time = window*2.5

dynamic_cross_spec_tplot,'Pressure_omni',0,v2,0,T1,T2,window,lag,coherence_time,$
                         new_name='Precip_hiss'  
;; dynamic_cross_spec_tplot,'P_DENS',0,v2,0,T1,T2,window,lag,coherence_time,$
;;                          new_name='Precip_hiss'  

copy_data,'Precip_hiss_coherence','coh_pressure'+p2+'_band4'
get_data,'coh_pressure'+p2+'_band4',data=coh
store_data,'coh_pressure'+p2+'_band4',data={x:coh.x,y:coh.y,v:coh.v*1000.,spec:1}
get_data,'coh_pressure'+p2+'_band4',data=coh_press


cormin=0.4
goo = where(coh_press.y lt cormin)
if goo[0] ne -1 then coh_press.y[goo] = !values.f_nan
store_data,'coh_pressure'+p2+'_band4',data=coh_press


ylim,'coh_pressure'+p1+'_band4',0.1,3,0
ylim,'coh_pressure'+p2+'_band4',0.1,3,0
zlim,'coh_pressure'+p1+'_band4',0.4,1,0
zlim,'coh_pressure'+p2+'_band4',0.4,1,0



get_data,'coh_pressureK_band4',data=coh
goo = where((coh.v gt band4[0]) and (coh.v le band4[1]))
totes = fltarr(n_elements(coh.x))
for i=0L,n_elements(coh.x)-1 do totes[i] = total(coh.y[i,goo],/nan)
store_data,'totes_pressurecoh_band4',data={x:coh.x,y:totes}


get_data,'Pressure_omni_SPEC',data=coh
goo = where((coh.v gt band4[0]) and (coh.v le band4[1]))
totes = fltarr(n_elements(coh.x))
for i=0L,n_elements(coh.x)-1 do totes[i] = total(coh.y[i,goo],/nan)
store_data,'totes_omni_band4',data={x:coh.x,y:totes}

get_data,'P_DENS_SPEC',data=coh
goo = where((coh.v gt band4[0]) and (coh.v le band4[1]))
totes = fltarr(n_elements(coh.x))
for i=0L,n_elements(coh.x)-1 do totes[i] = total(coh.y[i,goo],/nan)
store_data,'totes_wind_band4',data={x:coh.x,y:totes}


options,'*totes*','panel_size',0.6



stop

  ylim,'Pressure_omni_SPEC',0,3,0
  tplot,['Pressure_omni',$
         'totes_pressurecoh_band4','ptotesW_omni-0.1-3',$
         'Pressure_omni_SPEC',$
         'Pressure_omni_wavelet']







;;Event finder (0.2-1 mHz)
ylim,'coh_'+p1+p2,0.1,10,1
ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
tplot,[v1+'_smoothed',v2+'_smoothed','coh_'+p1+p2,'Pressure_omni_SPEC',$
       'coh_'+p1+p2+'_band1',v1+'_band1',v2+'_band1','coh_totes_band1_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1]


ylim,'coh_'+p1+p2,1,10,0
ylim,'Pressure_omni_SPEC',1,3,0
zlim,'Pressure_omni_SPEC',1d0,1d2,1
tplot,[v1+'_smoothed',v2+'_smoothed','coh_'+p1+p2,$
       'coh_'+p1+p2+'_band3',v1+'_band3',v2+'_band3','coh_totes_band3_'+pre+p1+p2,$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band2',v1+'_band2',v2+'_band2','coh_totes_band2_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1]


tplot,[v1+'_smoothed',v2+'_smoothed','coh_'+p1+p2,$
       'coh_'+p1+p2+'_band4',$
       'coh_'+p1+p2+'_band3',$
       'coh_'+p1+p2+'_band2',$
       'coh_'+p1+p2+'_band1',$
       'coh_'+p1+p2+'_band0',$
       'Pressure_omni_SPEC']


stop






ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
tplot,[v1+'_smoothed',v2+'_smoothed',$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band1','coh_totes_band1_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1,'clock_angle','cone_angle','Pressure']

ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
tplot,[v1+'_smoothed_detrend',v2+'_smoothed_detrend',$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band1','coh_totes_band1_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1,'clock_angle','cone_angle','Pressure']

ylim,'Pressure_omni_SPEC',0.1,3,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
tplot,[v1+'_smoothed_detrend',$
       v2+'_smoothed_detrend',$
;       'Pressure_omni_SPEC',$
;       'totes_omni_band4',$
       'P_DENS',$
       'P_DENS_SPEC',$
       'totes_wind_band4',$
;       'coh_pressure'+p1+'_band4',$
;       'totesP_band4',$
                                ;'coh_pressure'+p2+'_band4',$
       'coh_'+p1+p2+'_band4','coh_totes_band4_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,$
       'mlt_'+pre+p1]           ;,'clock_angle','cone_angle','Pressure']


ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
tplot,[v1+'_smoothed_detrend',$
       'Pressure_omni_SPEC','coh_pressureK_band4',$
       'lshell1','mlt_'+pre+p1,'clock_angle','cone_angle','Pressure']




tplot,[v1+'_smoothed_detrend',v2+'_smoothed_detrend',$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band1','coh_totes_band1_'+pre+p1+p2,'mlt_'+pre+p1,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'clock_angle','cone_angle','Pressure']



;;Plot individual BARREL payload specs

ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
ylim,v1+'_smoothed_SPEC',0.2,1,0
zlim,v1+'_smoothed_SPEC',1d2,1d5,1
tplot,[v1+'_smoothed_detrend',v1+'_smoothed_SPEC',$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band1','coh_totes_band1_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1,'clock_angle','cone_angle','Pressure']


ylim,'Pressure_omni_SPEC',0.2,1,0
zlim,'Pressure_omni_SPEC',1d0,1d3,1
ylim,v2+'_smoothed_SPEC',0.2,1,0
zlim,v2+'_smoothed_SPEC',1d2,1d6,1
tplot,[v2+'_smoothed_detrend',v2+'_smoothed_SPEC',$
       'Pressure_omni_SPEC','coh_'+p1+p2+'_band1','coh_totes_band1_'+pre+p1+p2,$
       'delta_lshell_'+pre+p1+p2,'delta_mlt_'+pre+p1+p2,'mlt_'+pre+p1,'clock_angle','cone_angle','Pressure']


;;--------------------
;;Plot all FSPC channels
;;--------------------
ylim,'fspc_'+pre+'?_smoothed_SPEC',0.2,1,0
zlim,'fspc_'+pre+'?_smoothed_SPEC',1d2,1d6,1
tplot,['fspc_'+pre+'?_smoothed_detrend','Pressure_omni_SPEC']
tplot,['fspc_'+pre+'?_smoothed_detrend','fspc_'+pre+'?_smoothed_SPEC','Pressure_omni','Pressure_omni_SPEC']


;;Separate by MLT sectors
mltp = 'L'

get_data,'mlt_2'+mltp,data=d
s1 = where((d.y ge 9) and (d.y lt 15))
s2 = where((d.y ge 15) and (d.y lt 21))
s3a = where((d.y ge 21) and (d.y le 24))
s3b = where((d.y ge 0) and (d.y lt 3))
s3 = [s3a,s3b]
s4 = where((d.y ge 3) and (d.y lt 9))

mltbool = fltarr(n_elements(d.x))
if s1[0] ne -1 then mltbool[s1] = 2
if s4[0] ne -1 then mltbool[s4] = 1
if s2[0] ne -1 then mltbool[s2] = 3
if s3[0] ne -1 then mltbool[s3] = 4

store_data,'mltbool_2'+mltp,data={x:d.x,y:mltbool}
ylim,'mltbool_2'+mltp,0,5

;;--------------------
;;Plot all coherence
;;--------------------
tplot,['coh_??_band1','coh_totes_band1_2??']



tinterpol_mxn,'mltbool_2K','coh_totes_band1_2KL',newname='mltbool_2K_tmp'
get_data,'coh_totes_band1_2KL',data=c
ttmp1 = fltarr(n_elements(c.x))
ttmp2 = ttmp1
ttmp3 = ttmp1
ttmp4 = ttmp1

get_data,'mltbool_2K_tmp',data=d
goo = where(d.y eq 1)
if goo[0] ne -1 then ttmp1[goo] = c.y[goo]
goo = where(d.y eq 2)
if goo[0] ne -1 then ttmp2[goo] = c.y[goo]
goo = where(d.y eq 3)
if goo[0] ne -1 then ttmp3[goo] = c.y[goo]
goo = where(d.y eq 4)
if goo[0] ne -1 then ttmp4[goo] = c.y[goo]

print,'Total of band1 from 3-9 MLT is ',total(ttmp1)
print,'Total of band1 from 9-15 MLT is ',total(ttmp2)
print,'Total of band1 from 15-21 MLT is ',total(ttmp3)
print,'Total of band1 from 21-3 MLT is ',total(ttmp4)

store_data,'coht11',data={x:c.x,y:ttmp1}
store_data,'coht12',data={x:c.x,y:ttmp2}
store_data,'coht13',data={x:c.x,y:ttmp3}
store_data,'coht14',data={x:c.x,y:ttmp4}
store_data,'coh_colored_band1_2KL',data=['coht11','coht12','coht13','coht14']
options,'coh_colored_band1_2KL','colors',[0,50,200,250]


;---band2
tinterpol_mxn,'mltbool_2K','coh_totes_band2_2KL',newname='mltbool_2K_tmp'
get_data,'coh_totes_band2_2KL',data=c
ttmp1 = fltarr(n_elements(c.x))
ttmp2 = ttmp1
ttmp3 = ttmp1
ttmp4 = ttmp1

get_data,'mltbool_2K_tmp',data=d
goo = where(d.y eq 1)
if goo[0] ne -1 then ttmp1[goo] = c.y[goo]
goo = where(d.y eq 2)
if goo[0] ne -1 then ttmp2[goo] = c.y[goo]
goo = where(d.y eq 3)
if goo[0] ne -1 then ttmp3[goo] = c.y[goo]
goo = where(d.y eq 4)
if goo[0] ne -1 then ttmp4[goo] = c.y[goo]

print,'Total of band2 from 3-9 MLT is ',total(ttmp1)
print,'Total of band2 from 9-15 MLT is ',total(ttmp2)
print,'Total of band2 from 15-21 MLT is ',total(ttmp3)
print,'Total of band2 from 21-3 MLT is ',total(ttmp4)

store_data,'coht21',data={x:c.x,y:ttmp1}
store_data,'coht22',data={x:c.x,y:ttmp2}
store_data,'coht23',data={x:c.x,y:ttmp3}
store_data,'coht24',data={x:c.x,y:ttmp4}
store_data,'coh_colored_band2_2KL',data=['coht21','coht22','coht23','coht24']
options,'coh_colored_band2_2KL','colors',[0,50,200,250]







;; tplot,['fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','mltbool_2K','coh_KL_band1','coh_totes_band1_2KL']
tplot,['fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','mltbool_2K','coh_KL_band1','coh_totes_band1_2KL','coh_colored_band1_2KL','delta_lshell_2KL','delta_mlt_2KL']

tplot,['fspc_2K_smoothed_detrend','fspc_2L_smoothed_detrend','mltbool_2K','coh_KL_band2','coh_totes_band2_2KL','coh_colored_band2_2KL','delta_lshell_2KL','delta_mlt_2KL']








;;Find distance from Goldstein's plasmasphere
;; lshell_2K
;; mlt_2K
;; get_data,'Pressure_omni_SPEC',data=p

t0 = time_double('2014-01-07/00:00')
t1 = time_double('2014-01-14/00:00')
;; y = tsample('Pressure_omni_SPEC',[t0,t1],times=tms)
y = tsample('coh_KL_band1',[t0,t1],times=tms)

ldiff = fltarr(n_elements(tms))
mdiff = fltarr(n_elements(tms))

;; for i=0,n_elements(tms)-1 do begin  $ 
;;    s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2K',tms[i]),tsample('lshell_2K',tms[i]))    & $
;;    ldiff[i] = s.distance_from_pp   & $
;;    mdiff[i] = s.mlt_offset

for i=0,n_elements(tms)-1 do begin 
   s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2K',tms[i]),tsample('lshell_2K',tms[i]))
   ldiff[i] = s.distance_from_pp
   mdiff[i] = s.mlt_offset
endfor

   store_data,'lshell_offset_2K',data={x:tms,y:ldiff}
   store_data,'mlt_offset_2K',data={x:tms,y:mdiff}


   ldiff = fltarr(n_elements(tms))
   mdiff = fltarr(n_elements(tms))

   ;; for i=0,n_elements(tms)-1 do begin  $ 
   ;;    s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2L',tms[i]),tsample('lshell_2L',tms[i]))    & $
   ;;    ldiff[i] = s.distance_from_pp   & $
   ;;    mdiff[i] = s.mlt_offset

   for i=0,n_elements(tms)-1 do begin
      s = plasmapause_goldstein_boundary(time_string(tms[i]),tsample('mlt_2L',tms[i]),tsample('lshell_2L',tms[i]))
      ldiff[i] = s.distance_from_pp 
      mdiff[i] = s.mlt_offset
   endfor

      store_data,'lshell_offset_2L',data={x:tms,y:ldiff}
      store_data,'mlt_offset_2L',data={x:tms,y:mdiff}


      ylim,['lshell_offset_2K','lshell_offset_2L'],-10,10
      tplot_options,'title','from paper_plot_sixday_event.pro'
      tplot,['Pressure_omni_SPEC','coh_KL_band1','lshell_offset_2K','lshell_offset_2L','mlt_offset_2K','mlt_offset_2L']


      stop


   end
