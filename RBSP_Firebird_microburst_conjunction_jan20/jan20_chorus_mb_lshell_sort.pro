;pro jan20_microburst_comparison,sc,fb,date,no_spice_load=no_spice_load
  ;rbsp_efw_position_velocity_crib



;  fileroot = '~/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/tplot/'
;  tplot_restore,filenames=fileroot+'ts04_vars_jan19-23.tplot'


;------------------------------------------------
;Load accurate (TS04) L-values for RBSP-a and FB4
;(see github.umn.edu/magnetic-field-modeling-mapping/call_aaron_map_with_tsy.pro)
;------------------------------------------------

;fileroot = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/datafiles/'
;tplot_restore,filenames=fileroot+'rbspa_fb4_ts04_lshell.tplot'
fileroot = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/IDL/'
tplot_restore,filenames=fileroot+'rbspa_fb4_ts04_lshell_MLT_hires.tplot'

tplot_restore,filenames=fileroot+'RBSPb_tsy04_mapping_20160120.tplot'


;rename these for symmetry b/t RBSPa and RBSPb
copy_data,'RBSPb!Cequatorial-foot-MLT!Ct04s','RBSPb!Cequatorial-foot-MLT!Ct04'
copy_data,'RBSPb!CL-shell-t04s','RBSPb!CL-shell-t04'


rbsp_efw_position_velocity_crib
;;--------------------------------------------------
;;Load RBSPa FBK data
;;--------------------------------------------------

  sc = 'b'
  fb = '4'
  date = '2016-01-20'
  timespan,date

  tplot_options,'title','from jan20_chorus_mb_lshell_sort.pro'

  rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
  rbsp_load_efw_fbk,probe='b',type='calibrated',/pt
  rbsp_load_efw_spec,probe='a',type='calibrated'
  rbsp_load_efw_spec,probe='b',type='calibrated'
;  rbsp_load_efw_waveform,probe='a',datatype='vb2'

  rbsp_split_fbk,'a'
  rbsp_split_fbk,'b'


;--------------------
;remove all spec values not representing chorus
  cdf2tplot,files='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
  get_data,'Magnitude',ttmp,bmag
  fcea = 28.*bmag
  flowa = fcea*0.1
  store_data,'fcea',ttmp,fcea
  store_data,'flowa',ttmp,flowa
  store_data,'speccomba',data=['rbspa_efw_64_spec0','fcea','flowa']


  cdf2tplot,files='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/rbsp-b_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
  get_data,'Magnitude',ttmp,bmag
  fceb = 28.*bmag
  flowb = fceb*0.1
  store_data,'fceb',ttmp,fceb
  store_data,'flowb',ttmp,flowb
  store_data,'speccombb',data=['rbspb_efw_64_spec0','fceb','flowb']


;info = {probe:'a',fbk_mode:'7',fbk_type:'Ew'}
;rbsp_efw_fbk_freq_interpolate,'rbspa_efw_fbk_7_fb1_pk',info

ylim,'speccomba',10,10000,1
tplot,['speccomba']  ;,'rbspa_efw_fbk_7_fb1_pk','rbspa_fbk_freq_of_max_orig','rbspa_fbk_freq_of_max_adj']
ylim,'speccombb',10,10000,1
tplot,['speccombb']  ;,'rbspa_efw_fbk_7_fb1_pk','rbspa_fbk_freq_of_max_orig','rbspa_fbk_freq_of_max_adj']

get_data,'rbspa_efw_64_spec0',ts,spec,specv
tinterpol_mxn,'fcea',ts,newname='fcea'
tinterpol_mxn,'flowa',ts,newname='flowa'
get_data,'fcea',ttmp,fcea
get_data,'flowa',ttmp,flowa

for i=0,n_elements(ts)-2 do begin
  goo = where((specv lt flowa[i]) or (specv gt fcea[i]))
  if goo[0] ne -1 then spec[i,goo] = 0.
endfor

store_data,'rbspa_efw_64_spec0',ts,spec,specv
options,'rbspa_efw_64_spec0','spec',1
ylim,'rbspa_efw_64_spec0',10,10000,1
zlim,'rbspa_efw_64_spec0',1d-6,1d-2,1

tplot,['rbspa_efw_64_spec0']


get_data,'rbspb_efw_64_spec0',ts,spec,specv
tinterpol_mxn,'fceb',ts,newname='fceb'
tinterpol_mxn,'flowb',ts,newname='flowb'
get_data,'fceb',ttmp,fceb
get_data,'flowb',ttmp,flowb

for i=0,n_elements(ts)-2 do begin
  goo = where((specv lt flowb[i]) or (specv gt fceb[i]))
  if goo[0] ne -1 then spec[i,goo] = 0.
endfor

store_data,'rbspb_efw_64_spec0',ts,spec,specv
options,'rbspb_efw_64_spec0','spec',1
ylim,'rbspb_efw_64_spec0',10,10000,1
zlim,'rbspb_efw_64_spec0',1d-6,1d-2,1

tplot,['rbspb_efw_64_spec0']

;--------------------




;Calculate RMS hiss amplitude

  tplot,['rbspa_efw_64_spec0','RBSPa!CL-shell-t04']

  fcals = rbsp_efw_get_gain_results()
  fbinsL = fcals.cal_spec.freq_spec64L
  fbinsH = fcals.cal_spec.freq_spec64H
  bandw = fbinsH - fbinsL

  get_data,'rbspa_efw_64_spec0',data=eu
;  eu.y[*,0:22] = 0.


  nelem = n_elements(eu.x)
  et = fltarr(nelem)
  ;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
  ball = eu.y^2

  for j=0L,nelem-1 do et[j] = sqrt(total(ball[j,*]*bandw,/nan)) ;RMS method (Malaspina's method)
  store_data,'Efield_chorusa',data={x:eu.x,y:et}
  tplot,'Efield_chorusa'




  tplot,['rbspb_efw_64_spec0','rbspb_state_lshell']

  fcals = rbsp_efw_get_gain_results()
  fbinsL = fcals.cal_spec.freq_spec64L
  fbinsH = fcals.cal_spec.freq_spec64H
  bandw = fbinsH - fbinsL

  get_data,'rbspb_efw_64_spec0',data=eu
;  eu.y[*,0:22] = 0.


  nelem = n_elements(eu.x)
  et = fltarr(nelem)
  ;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
  ball = eu.y^2

  for j=0L,nelem-1 do et[j] = sqrt(total(ball[j,*]*bandw,/nan)) ;RMS method (Malaspina's method)
  store_data,'Efield_chorusb',data={x:eu.x,y:et}
  tplot,'Efield_chorusb'


;  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk'],0,3000,0
;  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']


;  rbsp_detrend,'rbsp?_fbk1_7pk_5',60.*0.2
;  rbsp_detrend,'rbsp?_fbk2_7pk_5',60.*0.2


;  tinterpol_mxn,'rbspa_state_lshell','rbspa_fbk1_7pk_5'
;  tinterpol_mxn,'RBSPa!CL-shell-t04','rbspa_fbk1_7pk_5'
tinterpol_mxn,'RBSPa!CL-shell-t04','Efield_chorusa'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04','Efield_chorusa'
tinterpol_mxn,'RBSPb!CL-shell-t04','Efield_chorusb'
tinterpol_mxn,'RBSPb!Cequatorial-foot-MLT!Ct04','Efield_chorusb'


;tinterpol_mxn,'rbspb_state_lshell','Efield_chorusb'
;tinterpol_mxn,'rbspb_state_mlt','Efield_chorusb'



  ;total times that RBSPa is outside of PS
  t0a = time_double('2016-01-20/16:00')
  t1a = time_double('2016-01-20/20:00')

  ;subset of total times for outbound pass. Peak Lvalue at ~19:00
  t0oa = time_double('2016-01-20/16:00')
  t1oa = time_double('2016-01-20/20:00')

  t0ia = time_double('2016-01-20/20:00')
  t1ia = time_double('2016-01-20/23:30')


  ;total times that RBSPb is outside of PS
  t0b = time_double('2016-01-20/15:30')
  t1b = time_double('2016-01-20/22:30')

  ;subset of total times for outbound pass. Peak Lvalue at ~19:00
  t0ob = time_double('2016-01-20/15:30')
  t1ob = time_double('2016-01-20/19:00')

  t0ib = time_double('2016-01-20/19:00')
  t1ib = time_double('2016-01-20/23:30')


;get_data,'RBSPa!CL-shell-t04',ttmp,lshell


;  rbsp_detrend,'rbspa_fbk1_7pk_5',60.*0.2
;  rbsp_detrend,'rbspa_fbk2_7pk_5',60.*0.2
rbsp_detrend,'Efield_chorus?',60.


  la = tsample('RBSPa!CL-shell-t04_interp',[t0a,t1a],times=t)
  fa = tsample('Efield_chorusa_smoothed',[t0a,t1a],times=t)
  ma = tsample('RBSPa!Cequatorial-foot-MLT!Ct04_interp',[t0a,t1a],times=t)

  ;outbound pass
  loa = tsample('RBSPa!CL-shell-t04_interp',[t0oa,t1oa],times=toa)
  foa = tsample('Efield_chorusa_smoothed',[t0oa,t1oa],times=t)
  moa = tsample('RBSPa!Cequatorial-foot-MLT!Ct04_interp',[t0oa,t1oa],times=t)

  ;inbound pass
  lia = tsample('RBSPa!CL-shell-t04_interp',[t0ia,t1ia],times=tia)
  fia = tsample('Efield_chorusa_smoothed',[t0ia,t1ia],times=t)
  mia = tsample('RBSPa!Cequatorial-foot-MLT!Ct04_interp',[t0ia,t1ia],times=t)



;  lb = tsample('rbspb_state_lshell_interp',[t0b,t1b],times=t)
  lb = tsample('RBSPb!CL-shell-t04_interp',[t0b,t1b],times=t)
  fb = tsample('Efield_chorusb_smoothed',[t0b,t1b],times=t)
  mb = tsample('RBSPb!Cequatorial-foot-MLT!Ct04_interp',[t0b,t1b],times=t)

  ;outbound pass
;  lob = tsample('rbspb_state_lshell_interp',[t0ob,t1ob],times=tob)
  lob = tsample('RBSPb!CL-shell-t04_interp',[t0ob,t1ob],times=tob)
  fob = tsample('Efield_chorusb_smoothed',[t0ob,t1ob],times=t)
;  mob = tsample('rbspb_state_mlt_interp',[t0ob,t1ob],times=t)
  mob = tsample('RBSPb!Cequatorial-foot-MLT!Ct04_interp',[t0ob,t1ob],times=t)

  ;inbound pass
;  lib = tsample('rbspb_state_lshell_interp',[t0ib,t1ib],times=tib)
  lib = tsample('RBSPb!CL-shell-t04_interp',[t0ib,t1ib],times=tib)
  fib = tsample('Efield_chorusb_smoothed',[t0ib,t1ib],times=t)
;  mib = tsample('rbspb_state_mlt_interp',[t0ib,t1ib],times=t)
  mib = tsample('RBSPb!Cequatorial-foot-MLT!Ct04_interp',[t0ib,t1ib],times=t)




  lvtmp = [3.62,3.8,4.0,4.2,4.4,4.6,4.8,5.0,5.2,5.4,5.6,5.62,5.64,5.66,5.68,5.7,5.72,5.74,5.76,5.78]
  tocomp = dblarr(20)
  ticomp = dblarr(20)

  for q=0,n_elements(lvtmp)-1 do begin
      goo = where(loa ge lvtmp[q])
      if goo[0] ne -1 then tocomp[q] = toa[goo[0]]
      goo = where(lia le lvtmp[q])
      if goo[0] ne -1 then ticomp[q] = tia[goo[0]]
  endfor
  ;time difference in hrs b/t outbound and inbound passes for each L
  tdiffa = (ticomp - tocomp)/3600.



  lvtmp = [3.62,3.8,4.0,4.2,4.4,4.6,4.8,5.0,5.2,5.4,5.6,5.62,5.64,5.66,5.68,5.7,5.72,5.74,5.76,5.78]
  tocomp = dblarr(20)
  ticomp = dblarr(20)

  for q=0,n_elements(lvtmp)-1 do begin
      goo = where(lob ge lvtmp[q])
      if goo[0] ne -1 then tocomp[q] = tob[goo[0]]
      goo = where(lib le lvtmp[q])
      if goo[0] ne -1 then ticomp[q] = tib[goo[0]]
  endfor
  ;time difference in hrs b/t outbound and inbound passes for each L
  tdiffb = (ticomp - tocomp)/3600.




  ;;--------------------------------------------------
  ;;Load Firebird data files
  ;;--------------------------------------------------


    path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/datafiles/'
    fname = 'FU_4_Hires_2016-01-20_L1_v02.txt'



  openr,lun,path+fname,/get_lun

  jnk = ''
  for i=0,107 do readf,lun,jnk

  data = strarr(90000,27)
  i=0L
  while not eof(lun) do begin
     readf,lun,jnk
     data[i,*] = strsplit(jnk,/extract)
     i++
  endwhile

  close,lun
  free_lun,lun


  times = data[*,0]
  goo = where(times eq '')
  v = goo[0]-1
  times = times[0:v]

  ;;ad hoc time correction for the FB4 data on Jan 20th at ~19:40
  times = time_double(times) + 0.  ;4.1



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


  tinterpol_mxn,'FB4!CL-shell-t04','hr0_0'

  rbsp_detrend,'hr0_0',0.5

  l2a = tsample('FB4!CL-shell-t04_interp',[t0a,t1a],times=t)
  f2a = tsample('hr0_0_smoothed',[t0a,t1a],times=t2)
  l22a = tsample('FB4!CL-shell-t04_interp',[t0ia,t1ia],times=t)
  f22a = tsample('hr0_0_smoothed',[t0ia,t1ia],times=t2)

  l2b = tsample('FB4!CL-shell-t04_interp',[t0b,t1b],times=t)
  f2b = tsample('hr0_0_smoothed',[t0b,t1b],times=t2)
  l22b = tsample('FB4!CL-shell-t04_interp',[t0ib,t1ib],times=t)
  f22b = tsample('hr0_0_smoothed',[t0ib,t1ib],times=t2)

;-----------------------------------------------------------------------------
;Plot the Results
;-----------------------------------------------------------------------------

;conjunction is at L=5.7

;  !p.charsize = 2
;  !p.multi = [0,0,3]
;  plot,l,f,xrange=[4.5,5.8],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001,10],$
;       title='from jan20_chorus_mb_lshell_sort.pro'
;  plot,l,m,ytitle='RBSPa MLT',xrange=[4.5,5.8]
;
;  plot,l2,f2,xrange=[4.5,5.8],xstyle=1,ytitle='FB4 counts Lsort!Csmoothed',/ylog,$
;       title='from jan20_chorus_mb_lshell_sort.pro'

;;  plot,l,b,xrange=[4.5,5.5],xstyle=1,ytitle='FBK Bw Lsort!Csmoothed',/ylog,yrange=[0.01,1000]
;  plot,l,f,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001,10]
;  plot,l,m,ytitle='RBSPa MLT',xrange=[3,6]
;;  plot,l,b,xrange=[2,6],xstyle=1,ytitle='FBK Bw Lsort!Csmoothed',/ylog,yrange=[0.01,1000]
;  plot,l2,f2,xrange=[3,6],xstyle=1,ytitle='FB4 counts Lsort!Csmoothed',/ylog,yrange=[1d0,1d3]



;plot,l2,f2,xrange=[3,6],xstyle=1,ytitle='FB4 counts',yrange=[0,500],ystyle=1


!p.multi = [0,0,4]
plot,loa,foa^2,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001^2,10^2]
oplot,lia,fia^2,color=50
plot,l2a,f2a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',/ylog,yrange=[10,500],ystyle=1
plot,loa,moa,xrange=[3,6],yrange=[5,15]
oplot,lia,mia,color=50
plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiffa

!p.multi = [0,0,4]
plot,lob,fob^2,xrange=[3,6],xstyle=1,ytitle='RBSPb Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001^2,10^2]
oplot,lib,fib^2,color=50
plot,l2b,f2b,xrange=[3,6],xstyle=1,ytitle='FB4 counts',/ylog,yrange=[10,500],ystyle=1
plot,lob,mob,xrange=[3,6],yrange=[5,15]
oplot,lib,mib,color=50
plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiffb


;combine both RBSPa and RBSPb on single plot
!p.multi = [0,0,5]
plot,loa,foa^2,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001^2,10^2]
oplot,lia,fia^2,color=50
plot,lob,fob^2,xrange=[3,6],xstyle=1,ytitle='RBSPb Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001^2,10^2]
oplot,lib,fib^2,color=50
plot,l2a,f2a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',/ylog,yrange=[10,500],ystyle=1
plot,loa,moa,xrange=[3,6],yrange=[5,15]
oplot,lia,mia,color=50
plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiffa
;oplot,lvtmp,tdiffb,color=250


;Plot power on a linear scale
;combine both RBSPa and RBSPb on single plot
!p.multi = [0,0,7]
plot,loa,foa^2,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',yrange=[0,4]
plot,lia,fia^2,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',yrange=[0,0.5]
plot,lob,fob^2,xrange=[3,6],xstyle=1,ytitle='RBSPb Ew Spec Lsort!Csmoothed',yrange=[0,12]
;plot,lib,fib^2,xrange=[3,6],xstyle=1,ytitle='RBSPb Ew Spec Lsort!Csmoothed',yrange=[0,0.5]
plot,l2a,f2a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',yrange=[0,400],ystyle=1
plot,loa,moa,xrange=[3,6],yrange=[5,15]
oplot,lia,mia,color=50
plot,lob,mob,xrange=[3,6],yrange=[5,15]
oplot,lib,mib,color=50
plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiffa
oplot,lvtmp,tdiffb,color=250






!p.multi = [0,0,4]
plot,loa,foa^2,xrange=[4.5,5.8],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001^2,10^2]
oplot,lia,fia^2,color=50
plot,l2a,f2a,xrange=[4.5,5.8],xstyle=1,ytitle='FB4 counts',/ylog,yrange=[20,500],ystyle=1
plot,loa,moa,xrange=[4.5,5.8],yrange=[5,15],xstyle=1
oplot,lia,mia,color=50
plot,[0,0],/nodata,xrange=[4.5,5.8],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)',xstyle=1
oplot,lvtmp,tdiffa



;Linear y-scale
!p.multi = [0,0,4]
plot,loa,foa,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',yrange=[0.,4]
oplot,lia,fia,color=50
plot,l2a,f2a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',yrange=[0,400],ystyle=1
plot,loa,moa,xrange=[3,6],yrange=[5,15]
oplot,lia,mia,color=50
plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiffb










;Compare the two FB4 passes (######NEED EXPANDED TSY04 L-VALUES FOR FB4!!!!!!)
!p.multi = [0,0,4]
plot,l2a,f2a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',yrange=[0,400],ystyle=1
plot,l22a,f22a,xrange=[3,6],xstyle=1,ytitle='FB4 counts',yrange=[0,400],ystyle=1
;oplot,l22,f22


plot,[0,0],/nodata,xrange=[3,6],yrange=[0,8],xtitle='L (TSY04)',ytitle='Time diff!COutbound-Inbound)'
oplot,lvtmp,tdiff
















end



;!p.multi = [0,0,2]
;plot,lo,fo,xrange=[5.2,5.8],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001,10]
;oplot,li,fi,color=50
;oplot,l2,f2/150.,color=250
;plot,lo,mo,xrange=[5.2,5.8],yrange=[5,15]
;oplot,li,mi,color=50

;!p.multi = [0,0,2]
;plot,lo,fo,xrange=[5.6,5.8],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001,10]
;oplot,li,fi,color=50
;oplot,l2,f2/150.,color=250
;plot,lo,mo,xrange=[5.6,5.8],yrange=[5,15]
;oplot,li,mi,color=50

;plot,li,fi,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort!Csmoothed',/ylog,yrange=[0.0001,10]
;oplot,l2,f2/150.,color=250


;  !p.charsize = 2
;  !p.multi = [0,0,2]
;  plot,lo,fo,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort outbound!Csmoothed',/ylog,yrange=[0.0001,10],$
;       title='from jan20_chorus_mb_lshell_sort.pro'
;  plot,li,fi,xrange=[3,6],xstyle=1,ytitle='RBSPa Ew Spec Lsort inbound!Csmoothed',/ylog,yrange=[0.0001,10],$
;            title='from jan20_chorus_mb_lshell_sort.pro'
;
