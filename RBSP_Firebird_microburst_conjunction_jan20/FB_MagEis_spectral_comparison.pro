;--------------------------------------------------
;;Load Firebird data files

  path = '/Users/aaronbreneman/Desktop/Research/OTHER/meetings/2016-Aerospace/'
  fname = 'FU_4_Hires_2016-01-20_L1_v02.txt'


openr,lun,path+fname,/get_lun

jnk = ''
for i=0,107 do readf,lun,jnk

data = strarr(90000,27)
i=0L
while not eof(lun) do begin  $
   readf,lun,jnk   & $
   data[i,*] = strsplit(jnk,/extract)  & $
   i++


close,lun
free_lun,lun


times = data[*,0]
goo = where(times eq '')
v = goo[0]-1
times = times[0:v]

;;ad hoc time correction for the FB4 data on Jan 20th at ~19:40

stop
times = time_double(times)

;; #    "hr0": {
;; #        "DEPEND_0": "Epoch",
;; #        "DEPEND_1": "Channel",
;; #        "DIMENSION": [6],
;; #        "ELEMENT_LABELS": ["251.5 kev", "333.5 kev", "452.0 kev", "620.5 kev", "852.8 kev", ">984 kev"],
;; #        "ELEMENT_NAMES": ["hr0_0", "hr0_1", "hr0_2", "hr0_3", "hr0_4", "hr0_5"],


store_data,'hr0_0',data={x:times,y:float(data[0:v,11])}
store_data,'hr0_1',data={x:times,y:float(data[0:v,12])}
store_data,'hr0_2',data={x:times,y:float(data[0:v,13])}
store_data,'hr0_3',data={x:times,y:float(data[0:v,14])}
store_data,'hr0_4',data={x:times,y:float(data[0:v,15])}
store_data,'hr0_5',data={x:times,y:float(data[0:v,16])}

options,'hr0_0','ytitle','hr0!C251.5 keV'
options,'hr0_1','ytitle','hr0!C333.5 keV'
options,'hr0_2','ytitle','hr0!C452 keV'
options,'hr0_3','ytitle','hr0!C620.5 keV'
options,'hr0_4','ytitle','hr0!C852.8 keV'
options,'hr0_5','ytitle','hr0!C>984 keV'


store_data,'hr0',data=['hr0_0','hr0_1','hr0_2','hr0_3']
options,'hr0','colors',[0,50,100,250]

copy_data,'hr0','hr0_v2'
ylim,'hr0_v2',1,1000,1

tplot,['hr0_0','hr0_1','hr0_2','hr0_3','hr0_4','hr0_5']
tlimit,'2016-01-20/19:43:53','2016-01-20/19:44:09'




;Load MagEIS data and plot spectral shape.
fn = 'rbspa_rel03_ect-mageis-L3_20160120_v7.5.1.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/MagEIS/'
cdf2tplot,path+fn

;slice 0 of 11 is the 8 deg bin
;slice 1 is 24 deg (8 not present at time of events)
evalsM = [31.5,53.8,79.8,108.3,143.5,183.4,226.1,231.8,342.1,464.4,593.,741.6,901.8,999.,1077.7,1547.,1701.,2275.,2651.,3681.,4216.,5000.,5001.,5002.,5003.]
get_data,'FEDU',tt,dd


;clearly we need to subtract a running average b/c the counts slowly
;climb over 1 min, probably due to FB rotation out of loss cone.

rbsp_detrend,['hr0_0','hr0_1','hr0_2','hr0_3','hr0_4','hr0_5'],60.*0.5
tplot,['hr0_0','hr0_1','hr0_2','hr0_3','hr0_4','hr0_5']+'_detrend'


;Energy bins for FIREBIRD
evals = [251.5,333.5,452.,620.5,852.8,984.]

t0sfb = '2016-01-20/19:43:53'
t1sfb = '2016-01-20/19:44:05'
t0 = time_double(t0sfb)
t1 = time_double(t1sfb)

goo = tsample('hr0_0_detrend',[t0,t1],times=tms)
fb_vals = fltarr(6,n_elements(goo))

for i=0,n_elements(goo)-1 do begin $
t = tms[i] & $
fb_vals[0,i] = tsample('hr0_0_detrend',t) & $
fb_vals[1,i] = tsample('hr0_1_detrend',t) & $
fb_vals[2,i] = tsample('hr0_2_detrend',t) & $
fb_vals[3,i] = tsample('hr0_3_detrend',t) & $
fb_vals[4,i] = tsample('hr0_4_detrend',t) & $
fb_vals[5,i] = tsample('hr0_5_detrend',t)


;---------

t0s = '2016-01-20/19:42:00'
t1s = '2016-01-20/19:45:00'
t0 = time_double(t0s)
t1 = time_double(t1s)
goo2 = tsample('FEDU',[t0,t1],times=tms2)
mag_vals = fltarr(25,n_elements(tms2))
pa_bin = 1.

for i=0,n_elements(tms2)-1 do begin $
t = tms2[i] & $
boo = reform(tsample('FEDU',t)) & $
mag_vals[*,i] = boo[*,pa_bin]



popen,'~/Desktop/grab1.ps',/landscape
!p.charsize = 0.8
!p.multi = [0,0,1]
plot,evals,fb_vals[*,0],xrange=[200,1000],psym=-4,yrange=[1d-2,1d5],/ylog,$
title='ENERGY SPECTRA COMPARISON!CFIREBIRD uB counts!Cand MagEIS 24 deg flux (red)',$
xtitle='energy (keV)'
for i=0,n_elements(goo)-1 do oplot,evals,fb_vals[*,i],psym=-4,color=i/4.
for i=0,n_elements(tms2)-1 do oplot,evalsm,mag_vals[*,i],color=250,psym=-4,thick=3
xyouts,/normal,0.5,0.72,'MagEIS times (chorus)'
xyouts,/normal,0.5,0.7,t0s
xyouts,/normal,0.5,0.68,t1s
xyouts,/normal,0.7,0.72,'FIREBIRD times (uB)'
xyouts,/normal,0.7,0.7,t0sfb
xyouts,/normal,0.7,0.68,t1sfb
pclose




;Normalize MagEIS and FB values to their respective values at 250 keV



;!p.multi = [0,0,2]
;plot,evals,[hr0,hr1,hr2,hr3,hr4,hr5]/hr0,xrange=[200,1000],psym=-4

;mag = reform(tsample('FEDU',t);,times=tms2))
;print,time_string(tms,prec=3)
;print,time_string(tms2,prec=3)
