;Create tplot save file for each payload combo







;Calculate the coherency b/t all combinations of BARREL payloads
;This is done in multiple steps
;1) load all the BARREL data for each balloon for entire
;mission. Outputs as .tplot save file
;2) run this data for all balloon combinations through Lei's
;coherence program. Outputs as .tplot save file







;**************************************************
;These following segments of the program only need to be run
;once. They save .tplot save files
create_peakdet_tplot = 0 ;call combine_barrel_data.pro to create the PeakDet files for entire mission
create_coh_tplot = 1 ;call dynamic_cross_spec_tplot.pro to create coherence and phase plots
                                ;for all payload combinations. Note
                                ;that doing this will erase the
                                ;PeakDet files after each
                                ;combination. This is done b/c there
                                ;are lots of combinations and memory
                                ;would quickly be filled up
                                ;otherwise. So, rerun program after
                                ;this .tplot file is created
;**************************************************



;.compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/idl/combine_barrel_data.pro

tplot_options,'title','from full_mission_coherency_plot.pro'

;; 2014 campaign
;; ------
pre = '2'
date = '2013-12-27'
ndays = 47
timespan,date,ndays,/days
payloads = strupcase(['a','b','c','d','e','f','i','k','l','m','n','o','p','q','t','w','x','y'])
;payloads = strupcase(['l','m','n','o','p','q','t','w','x','y'])
mlt_min = 0.
mlt_max = 24.
combos_final = ['EP','IK','IW','KL','KW','KX','LM','LW','LX','MT','MX','MY','NY']

;; ------
;; 2013 campaign
;; pre = '1'
;; date = '2013-01-01'  ;Multiple balloons up from Jan 1, 2013 - Feb 15
;; ndays = 45
;; timespan,date,ndays,/days
;; payloads = strupcase(['a','b','c','d','g','h','i','j','k','m','o','q','r','s','t','u','v'])
;; ;Excellent coherence
;; combos_final = ['AT','AU','AV','CD','CG','CH','CR','CS','CT','GI','HQ','HR','HS','HT','IT','QT','QU','TU','UV']
;; mlt_min = 0.
;; mlt_max = 24.


;; ;all combos
;; combos_final = ['AH','AI','AQ','AT','AU','AV',$
;;                 'BJ','BD','BK','BM','BO','BI',$
;;                 'CD','CG','CI','CK','CO','CH','CQ','CR','CS','CT',$
;;                 'DJ','DK','DM','DI','DO','DG','DH','DQ','DR',$
;;                 'GI','GJ','GK','GO','GQ','GR','GS','GT','GU',$
;;                 'HI','HK','HQ','HR','HS','HT','HU','HV',$
;;                 'IJ','IK','IM','IO','IQ','IR','IS','IT','IU','IV',$
;;                 'JK','JM','JO',$
;;                 'KM','KO','KQ',$
;;                 'MO',$
;;                 'QR','QS','QT','QU','QV',$
;;                 'RS',$
;;                 'ST','SU',$
;;                 'TU','TV',$
;;                 'UV']

;; ;OK coherence
;; combos_final = ['AH','AI','AQ','BK','DG','DH','GJ','HU','HV','IU','IV','QR','TV']


rbsp_efw_init

charsz_plot = 0.8               ;character size for plots
charsz_win = 1.2
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1

;days of BARREL campaign
dates = time_string(86400.*indgen(5 + 30 + 12) + time_double(date))



;**************************************************
;Find all sc combinations
n = n_elements(payloads)
combos = strarr(n*(n+1)/2 - n_elements(payloads))
q=0
for b=0,n_elements(payloads)-1 do begin
   for j=b+1,n_elements(payloads)-1 do begin
      combos[q] = payloads[b]+payloads[j]
      q++
   endfor
endfor
;**************************************************



T1 = date
T2 = time_string(time_double(date) + 86400.*(ndays+1))



create_barrel_tplot,payloads,dates,/fspc,restore=restore

py_create_coh_tplot,combos,T1,T2

coh_remove_bad_vals

filter_coh_tplot,combos

;Create a structure with relevant values for all requested payload combos
create_combo_struct,combos



;; if create_peakdet_tplot then begin

;; ;   for j=0,n_elements(payloads)-1 do combine_barrel_data,pre + payloads[j],dates
;;    for j=0,n_elements(payloads)-1 do combine_barrel_data,pre + payloads[j],dates,/fspc

;;    fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/'
;;    tplot_save,'*',filename=fileroot+'barrel_fullmission'+pre ;don't add .tplot


;; endif else tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/barrel_fullmission'+pre+'.tplot'






;**************************************************
;Smooth and detrend data
;**************************************************

;; Get rid of NaN values in the peak detector data. This messes up the downsampling

;; for i=0,n_elements(payloads)-1 do begin
;;    get_data,'PeakDet_'+pre+payloads[i],data=dd
;;    goo = where(dd.y lt 0.)
;;    if goo[0] ne -1 then dd.y[goo] = !values.f_nan
;;    xv = dd.x
;;    yv = dd.y
;;    interp_gap,xv,yv
;;    store_data,'PeakDet_'+pre+payloads[i],data={x:xv,y:yv}
;;    options,'PeakDet_'+pre+payloads[i],'colors',250
;; endfor



;; rbsp_detrend,['PeakDet_'+pre+'?'],60.*0.2

;; for i=0,n_elements(payloads)-1 do copy_data,'PeakDet_'+pre+payloads[i]+'_smoothed','PeakDet_'+pre+payloads[i]+'s'

;; ylim,['PeakDet_'+pre+'?s'],0,10000
;; tplot,['PeakDet_'+pre+'?s']

;; rbsp_detrend,['PeakDet_'+pre+'?s'],60.*30.

;; ylim,['PeakDet_'+pre+'?s_detrend'],-800,800
;; tplot,['PeakDet_'+pre+'?s_detrend']





;**********************************************************************
;Code for creating all combinations of cross-correlation
;**********************************************************************


;; if create_coh_tplot then begin

;;    window = 60.*30.
;;    lag = window/4.
;;    coherence_time = window*2.5
;;    cormin = 0.4


   ;; T1 = date
   ;; T2 = time_string(time_double(date) + 86400.*(ndays+1))
   ;; T1 = '2013-12-27/00:00:00'
   ;; T2 = '2014-02-17/24:00:00'


;;    stop
;; ;; combos = ['EP','IK']
;; ;******
;; ;TMPP*****
;; ;   COMBOS = ['EP','IK','IW','KL','KW','KX','LM','LW','LX','MT','MX','MY','NY']

;; ;Run cross spec for all payload combinations
;;    for bb=0,n_elements(combos)-1 do begin
;;       p1 = strmid(combos[bb],0,1)
;;       p2 = strmid(combos[bb],1,1)

;;       v1 = 'PeakDet_'+pre+p1+'s_detrend'
;;       v2 = 'PeakDet_'+pre+p2+'s_detrend'

;;       dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
;;                                new_name='Precip_hiss'
;;       copy_data,'Precip_hiss_coherence','coh_'+p1+p2
;;       copy_data,'Precip_hiss_phase','phase_'+p1+p2

;;       get_data,'coh_'+p1+p2,data=coh
;;       get_data,'phase_'+p1+p2,data=ph


;; ;**************************************************
;; ;Test out various filters
;; ;**************************************************

;; ;Need to remove NaN times from coh
;;       totes = fltarr(n_elements(coh.x))
;;       for uu=0,n_elements(coh.x)-1 do totes[uu] = total(coh.y[uu,*])
;;       good = where(finite(totes) ne 0.)

;;       if good[0] ne -1 then begin
;;          image = coh.y[good,*]
;;          times_init = coh.x[good]

;;                                 ;get rid of remaining NaN values
;;          hoo = where(finite(image) eq 0)
;;          if hoo[0] ne -1 then image[hoo] = 0.



;; ;**************************************************
;; ;Lee filter
;; ;**************************************************

;;          ntime_smooth = 20


;;          filteredImage = LEEFILT(image, 6)
;;          fispec = filteredimage
;;          fispec[*] = 0.
;;          fitots = fltarr(n_elements(image[*,0]))
;;          fitots2 = fltarr(n_elements(image[*,0]))

;;                                 ;running time smooth filter. This
;;                                 ;helps beat down the intense spikes
;;                                 ;from SEP events and emphasizes the
;;                                 ;longer-duration actual events
;;          for hh=ntime_smooth+1,n_elements(image[*,0])-ntime_smooth-1 do begin
;;             for yy=0,n_elements(image[0,*])-1 do begin
;;                fispec[hh,yy] = total(filteredimage[hh-ntime_smooth:hh+ntime_smooth,yy])
;;             endfor
;;          endfor


;;          for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,0:40])
;;          for hh=0,n_elements(image[*,0])-1 do fitots2[hh] = total(fispec[hh,0:40])


;;          store_data,'coh_'+p1+p2+'_leefilt6',data={x:times_init,y:filteredimage,v:coh.v}
;;          store_data,'coh_'+p1+p2+'_leefilts6',data={x:times_init,y:fispec,v:coh.v}
;;          store_data,'coh_'+p1+p2+'_slicelee6',data={x:times_init,y:fitots}
;;          store_data,'coh_'+p1+p2+'_slicelee62',data={x:times_init,y:fitots2}


;; ;tplot,['fispec6','coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_slicelee6','coh_'+p1+p2+'_slicelee62']


;;       endif


;;       t0t = times_init[0]
;;       t1t = times_init[n_elements(times_init)-1]


;;       options,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],'spec',1
;;       ylim,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],0.0008,0.1,1
;; ;         ylim,['coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],0.0008,0.1,1
;;       ;; window,4,xsize=900,ysize=1800

;;       timespan,t0t,(t1t-t0t),/sec






;;       goo = where(coh.y le cormin)
;;       if goo[0] ne -1 then coh.y[goo] = !values.f_nan
;;       if goo[0] ne -1 then ph.y[goo] = !values.f_nan
;;       boo = where(finite(coh.y) eq 0)
;;       if boo[0] ne -1 then ph.y[boo] = !values.f_nan
;;       store_data,'coh_'+p1+p2,data=coh
;;       store_data,'phase_'+p1+p2,data=ph
;;       options,'coh_'+p1+p2,'ytitle','Precip Coherence!C'+pre+p1+' vs '+pre+p2+'!Cfreq[Hz]'
;;       options,'phase_'+p1+p2,'ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
;;       ylim,['phase_'+p1+p2],-0.001,0.01

;;       dif_data,'L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2
;;       get_data,'L_Kp2_'+pre+p1+'-L_Kp2_'+pre+p2,data=dl
;;       store_data,'dlshell_Kp2_'+p1+p2,data={x:dl.x,y:abs(dl.y)}

;;       dif_data,'MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2
;;       get_data,'MLT_Kp2_'+pre+p1+'-MLT_Kp2_'+pre+p2,data=ml
;;       store_data,'dmlt_Kp2_'+p1+p2,data={x:ml.x,y:abs(ml.y)}

;;       dif_data,'L_Kp6_'+pre+p1,'L_Kp6_'+pre+p2
;;       get_data,'L_Kp6_'+pre+p1+'-L_Kp6_'+pre+p2,data=dl
;;       store_data,'dlshell_Kp6_'+p1+p2,data={x:dl.x,y:abs(dl.y)}

;;       dif_data,'MLT_Kp6_'+pre+p1,'MLT_Kp6_'+pre+p2
;;       get_data,'MLT_Kp6_'+pre+p1+'-MLT_Kp6_'+pre+p2,data=ml
;;       store_data,'dmlt_Kp6_'+p1+p2,data={x:ml.x,y:abs(ml.y)}

;;       store_data,'lcomb',data=['L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2]
;;       options,'lcomb','ytitle','Lshell!C'+p1+'=black!C'+p2+'=red'
;;       options,'lcomb','colors',[0,250]
;;       store_data,'mltcomb',data=['MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2]
;;       options,'mltcomb','ytitle','MLT!C'+p1+'=black!C'+p2+'=red'
;;       options,'mltcomb','colors',[0,250]


;;       get_data,'coh_'+p1+p2+'_slicelee62',data=dd
;;       goo = where(dd.y eq 0.)
;;       if goo[0] ne -1 then dd.y[goo] = !values.f_nan
;;       store_data,'coh_'+p1+p2+'_slicelee62',data=dd
;;       ylim,'coh_'+p1+p2+'_slicelee62',min(dd.y,/nan),max(dd.y,/nan)

;;       ylim,'lcomb',1,10,1
;;       ylim,'mltcomb',0,24
;;       ylim,'dlshell_Kp2_'+p1+p2,0.1,20,1
;;       ylim,'dmlt_Kp2_'+p1+p2,0.1,24,1
;;       ylim,'dlshell_Kp6_'+p1+p2,0,20
;;       ylim,'dmlt_Kp6_'+p1+p2,0,24
;;                                 ;tplot,['coh_'+p1+p2,'phase_'+p1+p2,v1,v2,'dlshell_Kp2_'+p1+p2,'dmlt_Kp2_'+p1+p2]

;;                                 ;    store_data,v1,/delete
;;                                 ;    store_data,v2,/delete

;;       ;; Set z-scale for the Leefiltered spec. I want "events" to
;;       ;; really pop out.
;;       get_data,'coh_'+p1+p2+'_leefilts6',data=lf
;;       maxx = max(lf.y,/nan)
;;       minn = min(lf.y,/nan)
;;       dz = (maxx - minn)/3.
;;       zlim,'coh_'+p1+p2+'_leefilts6',(minn+dz),maxx/1.2



;;       options,'coh_'+p1+p2+'_leefilts6','ytitle','coh!C'+p1+p2+'!C leefilter'+'!Csmoothed'

;;       !p.charsize = 0.8
;; ;      popen,'~/Desktop/full_mission_coherence_'+p1+p2+'.ps'
;;       tplot,[v1,v2,'coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6',$
;;              'coh_'+p1+p2+'_leefilts6','coh_'+p1+p2+'_slicelee62',$
;;              'dlshell_Kp2_'+p1+p2,'dmlt_Kp2_'+p1+p2,$
;;              'lcomb','mltcomb']
;; ;      pclose

;;       stop
;;                                 ;-------
;;                                 ;temporary....delete older variables when making simple plots.
;;                                 ;-------
;;       store_data,'coh_'+p1+p2+'*',/delete
;;    endfor




;;    fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/'
;;    tplot_save,['coh_??','phase_??'],filename=fileroot+'barrel_fullmission'+pre+'_coherency'
;;    tplot_save,['dlshell_Kp2_??','dmlt_Kp2_??'],filename=fileroot+'barrel_fullmission'+pre+'_dlshell_dmlt_Kp2'
;;    tplot_save,['dlshell_Kp6_??','dmlt_Kp6_??'],filename=fileroot+'barrel_fullmission'+pre+'_dlshell_dmlt_Kp6'
;; endif else begin
;;    tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/barrel_fullmission'+pre+'_coherency.tplot'
;;    tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/barrel_fullmission'+pre+'_dlshell_dmlt_Kp2.tplot'
;;    tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/barrel_fullmission'+pre+'_dlshell_dmlt_Kp6.tplot'
;; endelse








;**************************************************

;For every payload combination calculate the following arrays and save
;as one big array
;a1 -> payload combination (e.g. 'KL')
;a2 -> delta-Lshell
;a3 -> delta-MLT
;a4 -> coherence for select period
;a5 -> array of times


;**************************************************
;; LIST OF EVENTS WITH OBVIOUS COHERENCE

;EP - feb09 1900 - feb09 2400
;IK - jan04 1200 - jan05 0200
;IW - jan01 1500 - jan05 2000
;KL - jan06 1500 - jan11 0600
;KW - jan04 1400 - jan08 1200
;KX - jan08 1200 - jan11 0600
;LM - jan11 1200 - jan13 0600
;LW - jan06 1800 - jan07 1800
;LX - jan08 1200 - jan12 0600
;MT - jan12 1300 - jan13 0600   ;maybe
;MX - jan11 1200 - jan12 0300
;MY - jan11 2000 - jan12 0600
;NY - jan18 1400 - jan19 0000
;**************************************************
;***ALSO FILTER BY DENSITY***I'll probably have to ask Jerry
;Goldstein to send me plasmapause movies to do this....
;**************************************************


;REMOVE SPIKES
;RUN ALL LOCAL TIMES
;RUN ALL PAYLOAD COMBINATIONS (may not have to limit to certain combos
;if I'm using the cohavg

;jan2  1845-1906   ;saturated peak detector
;jan3  1347-1348
;jan4  1155-1212   ;saturated peak detector
;jan7  1010-1015





;Remove coherence values for these exceptions
for uu=0,n_elements(plds)-1 do begin
   tmp = plds[uu]
   u0 = strmid(tmp,0,1)
   u1 = strmid(tmp,1,1)
   get_data,'coh_'+u0+u1,data=cc
   goo = where((cc.x ge time_double(tt0[uu])) and (cc.x le time_double(tt1[uu])))
   if goo[0] ne -1 then cc.y[goo,*] = !values.f_nan
   store_data,'coh_'+u0+u1,data=cc
endfor



;FILTER RESULTS BY MLT



;combotest = ['KL','AB']
combotest = combos_final
;periods_final = [30.,15.,10.,5.,3.3,2.5,1.5,1.,0.75,0.5]  ;periods to save data for


tplot_options,'title','from full_mission_coherence_plot.pro!CMLTs b/t '+strtrim(mlt_min,2)+' - '+strtrim(mlt_max,2)


;fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/'
fileroot = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/Coherence_idl_files/'


window,1
window,2

!p.charsize = 0.8


a1 = ''
a2 = 0.                         ;dlshell
a3 = 0.                         ;dmlt
a4 = 0.                         ;coh.y
a5 = 0d                         ;times
a6 = 0.                         ;coh avg
a7 = 0.                         ;lshell1
a8 = 0.                         ;lshell2
a9 = 0.                         ;mlt1
a10 = 0.                        ;mlt2
a11 = 0.                        ;PeakDet1 values
a12 = 0.                        ;PeakDet2 values


for i=0,n_elements(combotest)-1 do begin

   p1 = strmid(combotest[i],0,1)
   p2 = strmid(combotest[i],1,1)

   v1 = 'PeakDet_'+pre+p1+'s_detrend'
   v2 = 'PeakDet_'+pre+p2+'s_detrend'


                                ;Get time range for zoom-in
   get_data,v1,data=vv1
   get_data,v2,data=vv2
   tmin1 = min(vv1.x,/nan)
   tmax1 = max(vv1.x,/nan)
   tmin2 = min(vv2.x,/nan)
   tmax2 = max(vv2.x,/nan)

;; print,time_string(tmin1)
;; print,time_string(tmax1)
;; print,time_string(tmin2)
;; print,time_string(tmax2)


   mint = tmin1 > tmin2
   maxt = tmax1 < tmax2

   if mint lt maxt then begin
      tlimit,mint,maxt


      get_data,'coh_'+p1+p2,data=coh

      tinterpol_mxn,'L_Kp2_'+pre+p1,coh.x,newname='L_Kp2_'+pre+p1+'_ct'
      tinterpol_mxn,'L_Kp2_'+pre+p2,coh.x,newname='L_Kp2_'+pre+p2+'_ct'
      tinterpol_mxn,'MLT_Kp2_'+pre+p1,coh.x,newname='MLT_Kp2_'+pre+p1+'_ct'
      tinterpol_mxn,'MLT_Kp2_'+pre+p2,coh.x,newname='MLT_Kp2_'+pre+p2+'_ct'
      tinterpol_mxn,'dlshell_Kp2_'+p1+p2,coh.x,newname='dL_'+p1+p2
      tinterpol_mxn,'dmlt_Kp2_'+p1+p2,coh.x,newname='dMLT_'+p1+p2
      tinterpol_mxn,'PeakDet_'+pre+p1,coh.x,newname='PeakDet_'+pre+p1+'_ct'
      tinterpol_mxn,'PeakDet_'+pre+p2,coh.x,newname='PeakDet_'+pre+p2+'_ct'




                                ;Remove coherence values outside of allowed MLT range
      get_data,'MLT_Kp2_'+pre+p1+'_ct',data=mlt1
      get_data,'MLT_Kp2_'+pre+p2+'_ct',data=mlt2


      goo1 = where((mlt1.y le mlt_min) or (mlt1.y ge mlt_max))
      goo2 = where((mlt2.y le mlt_min) or (mlt2.y ge mlt_max))

      if goo1[0] ne -1 then coh.y[goo1,*] = !values.f_nan
      if goo2[0] ne -1 then coh.y[goo2,*] = !values.f_nan
      store_data,'coh_'+p1+p2,data=coh
      ylim,'coh_'+p1+p2,0,0.01
      zlim,'coh_'+p1+p2,0,1


      periods = 1/coh.v/60.     ;min

;select period
;pd = 1. ;min
;      pd = periods_final[j]
      pd = 1.                   ;min
      pdstr = string(pd,format='(F4.1)')
      pdstr = strtrim(pdstr,2)


      goo = where(periods le pd)
      pselect = goo[0]
      print,'Selected wave period is: ',periods[pselect], ' min'

      cohtmp = coh.y[*,goo[0]]
      store_data,'coh_'+pdstr+'min_'+p1+p2,data={x:coh.x,y:cohtmp}
      options,'coh_'+pdstr+'min_'+p1+p2,'ytitle','Coherence!C'+pdstr+' min!C'+p1+p2

      get_data,'dMLT_'+p1+p2,data=dd
      goob = where(dd.y ge 20.)
      if goob[0] ne -1 then dd.y[goob] = dd.y[goob] - 24.
      goob = where(dd.y le -20.)
      if goob[0] ne -1 then dd.y[goob] = dd.y[goob] + 24.
      store_data,'dMLT_'+p1+p2,data=dd


;**************************************************
                                ;Average all periods for each
                                ;time. This should get rid of much of
                                ;the salt-pepper noise
      freqmin = 0.0005
      freqmax = 0.01
      fmin = string(freqmin*1000.,format='(f4.1)')
      fmax = string(freqmax*1000.,format='(f4.1)')
      boo = where((coh.v ge freqmin) and (coh.v le freqmax))

      cohavg = fltarr(n_elements(coh.x))
      for qq=0.,n_elements(coh.x)-1 do begin
         cohavg[qq] = total(coh.y[qq,boo],/nan)
         qoo = where(finite(coh.y[qq,boo] eq 1))
         if qoo[0] ne -1 then cohavg[qq] = cohavg[qq]/float(n_elements(qoo))
      endfor

      store_data,'cohavg_'+p1+p2,data={x:coh.x,y:cohavg}
      ylim,'cohavg_'+p1+p2,0,1,0
      options,'cohavg_'+p1+p2,'ytitle','Avg coh for freqs!Cfrom '+fmin+ '-'+fmax + ' mHz'

;**************************************************

      uoo = where(cohavg eq 0.)
      if uoo[0] ne -1 then cohavg[uoo] = !values.f_nan

      get_data,'coh_'+pdstr+'min_'+p1+p2,data=coh
      get_data,'dL_'+p1+p2,data=dl
      get_data,'dMLT_'+p1+p2,data=dmlt
      get_data,'L_Kp2_'+pre+p1+'_ct',data=lshell1
      get_data,'L_Kp2_'+pre+p2+'_ct',data=lshell2
      get_data,'MLT_Kp2_'+pre+p1+'_ct',data=mlt1
      get_data,'MLT_Kp2_'+pre+p2+'_ct',data=mlt2
      get_data,'PeakDet_'+pre+p1+'_ct',data=pd1
      get_data,'PeakDet_'+pre+p2+'_ct',data=pd2

      wset,2

      !p.multi = [0,0,4]
      plot,abs(dl.y),cohavg,xrange=[0,10],yrange=[0,1],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
      plot,abs(dmlt.y),cohavg,xrange=[0,10],yrange=[0,1],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
      plot,lshell1.y,cohavg,xrange=[0,10],yrange=[0,1],xtitle='Lshell'+pre+p1,ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
      oplot,lshell2.y,cohavg,color=250,psym=4
      plot,mlt1.y,cohavg,xrange=[0,24],yrange=[0,1],xtitle='MLT'+pre+p1,ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
      oplot,mlt2.y,cohavg,color=250,psym=4


      wset,1

      ylim,['L_Kp2_'+pre+p1+'_ct','L_Kp2_'+pre+p2+'_ct','dL_'+p1+p2],0.1,10,1
      ylim,'coh_'+pdstr+'min_'+p1+p2,0.5,1,0
      ylim,'dMLT_'+p1+p2,0.1,10,1
                                ;tlimit,/full
;      tplot,[v1,v2,'coh_'+p1+p2,'cohavg_'+p1+p2,'coh_'+pdstr+'min_'+p1+p2,'dL_'+p1+p2,'dMLT_'+p1+p2]

      ;; get_data,v1,data=vv1
      ;; dv = deriv(vv1.x,vv1.y)
      ;; yoo = where(dv ge 200)

      ;; get_data,'coh_'+p1+p2,data=ccoh
      ;; get_data,'cohavg_'+p1+p2,data=ccohavg

      ;; if yoo[0] ne -1 then ccoh.y[yoo,*] = !values.f_nan
      ;; if yoo[0] ne -1 then ccohavg.y[yoo,*] = !values.f_nan

      ;; store_data,'coh_'+p1+p2,data=ccoh
      ;; store_data,'cohavg_'+p1+p2,data=ccohavg



      store_data,'Lcomb',data=['L_Kp2_'+pre+p1,'L_Kp2_'+pre+p2]
      store_data,'MLTcomb',data=['MLT_Kp2_'+pre+p1,'MLT_Kp2_'+pre+p2]
      options,'Lcomb','colors',[0,250]
      options,'MLTcomb','colors',[0,250]
      options,'Lcomb','ytitle','L_'+pre+p1+'(black)!C'+'L_'+pre+p2+'(red)'
      options,'MLTcomb','ytitle','MLT_'+pre+p1+'(black)!C'+'MLT_'+pre+p2+'(red)'
      ylim,'Lcomb',0,8
      ylim,'MLTcomb',0,24

      tplot,[v1,v2,'coh_'+p1+p2,'cohavg_'+p1+p2,'dL_'+p1+p2,'dMLT_'+p1+p2,'Lcomb','MLTcomb']

;      stop

      popen,'~/Desktop/full_mission_coherence_'+p1+p2+'.ps'
      tplot
      pclose



;; !p.multi = [0,0,2]
;; plot,abs(dl.y),coh.y,xrange=[0,10],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
;; plot,abs(dmlt.y),coh.y,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4


      a1 = [a1,replicate(combotest[i],n_elements(dl.x))]
      a2 = [a2,dl.y]
      a3 = [a3,dmlt.y]
      a4 = [a4,coh.y]
      a5 = [a5,coh.x]
      a6 = [a6,cohavg]
      a7 = [a7,lshell1.y]
      a8 = [a8,lshell2.y]
      a9 = [a9,mlt1.y]
      a10 = [a10,mlt2.y]
      a11 = [a11,pd1.y]
      a12 = [a12,pd2.y]

      print,'***** ',i
      print,'***** imax=',n_elements(combotest)-1


   endif


endfor


;Remove first element
nelem = n_elements(a1)
a1 = a1[1:nelem-1]
a2 = a2[1:nelem-1]
a3 = a3[1:nelem-1]
a4 = a4[1:nelem-1]
a5 = a5[1:nelem-1]
a6 = a6[1:nelem-1]
a7 = a7[1:nelem-1]
a8 = a8[1:nelem-1]
a9 = a9[1:nelem-1]
a10 = a10[1:nelem-1]
a11 = a11[1:nelem-1]
a12 = a12[1:nelem-1]




;; for jj=0,n_elements(payloads)-1 do tinterpol_mxn,'PeakDet_'+pre+payloads[jj],a5
;; ylim,'PeakDet_'+pre+'?_interp',0,10000
;; tplot,'PeakDet_'+pre+'?_interp'






;; ;Plot coherence for all payload combinations
;;    !p.multi = [0,0,2]
;;    plot,abs(a2),a4,xrange=[0,2],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!Call payload combinations!Cfor '+strtrim(periods[pselect],2)+' min fluctuations',psym=4
;;    plot,abs(a3),a4,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!Call payload combinations!Cfor '+strtrim(periods[pselect],2)+' min fluctuations',psym=4


;**************************************************
;Plot coherence for all payload combinations
!p.multi = [0,0,6]


;;                                 ;Find points for certain days

;; tb0 = time_double('2014-01-02/00:00')
;; tb1 = time_double('2014-01-02/24:00')
;; boo2 = where((a5 ge tb0) and (a5 le tb1))
;; tb0 = time_double('2014-01-03/00:00')
;; tb1 = time_double('2014-01-03/24:00')
;; boo3 = where((a5 ge tb0) and (a5 le tb1))
;; tb0 = time_double('2014-01-04/00:00')
;; tb1 = time_double('2014-01-04/24:00')
;; boo4 = where((a5 ge tb0) and (a5 le tb1))
;; tb0 = time_double('2014-01-05/00:00')
;; tb1 = time_double('2014-01-05/24:00')
;; boo5 = where((a5 ge tb0) and (a5 le tb1))
;; tb0 = time_double('2014-01-06/00:00')
;; tb1 = time_double('2014-01-06/24:00')
;; boo6 = where((a5 ge tb0) and (a5 le tb1))


plot,abs(a2),a6,xrange=[0,10],xtitle='delta-Lshell',ytitle='Coherence',title='BARREL mission '+pre+'!CAvg Coherence from '+fmin+'-'+fmax+' mHz'+'!Call payload combinations',psym=4 ;,ymargin=[4,6]
;; oplot,abs(a2[boo2]),a6[boo2],color=200,psym=4
;; oplot,abs(a2[boo3]),a6[boo3],color=250,psym=4
;; oplot,abs(a2[boo4]),a6[boo4],color=120,psym=4
;; oplot,abs(a2[boo5]),a6[boo5],color=170,psym=4
;; oplot,abs(a2[boo6]),a6[boo6],color=50,psym=4


plot,abs(a3),a6,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',psym=4
;; oplot,abs(a3[boo2]),a6[boo2],color=200,psym=4
;; oplot,abs(a3[boo3]),a6[boo3],color=250,psym=4
;; oplot,abs(a3[boo4]),a6[boo4],color=120,psym=4
;; oplot,abs(a3[boo5]),a6[boo5],color=170,psym=4
;; oplot,abs(a3[boo6]),a6[boo6],color=50,psym=4


plot,a7,a6,xrange=[0,10],xtitle='Lshell',ytitle='Coherence',psym=4
oplot,a8,a6,psym=4
plot,a7,a11,xtitle='Lshell',ytitle='PeakDet',psym=4,yrange=[3000,12000],xrange=[0,10],/nodata,ystyle=1
oplot,a7,a11,color=50,psym=4
oplot,a8,a12,psym=4,color=50

plot,a9,a6,xrange=[0,24],xtitle='MLT',ytitle='Coherence',psym=4
oplot,a10,a6,psym=4
plot,a9,a11,xtitle='MLT',ytitle='PeakDet',psym=4,yrange=[3000,12000],xrange=[0,24],/nodata,ystyle=1
oplot,a9,a11,color=50,psym=4
oplot,a10,a12,psym=4,color=50


;**************************************************

stop


;tplot_save,'*',filename=fileroot+'barrel_fullmission' ;don't add .tplot


;Save results to IDL save file
save,a1,a2,a3,a4,a5,a6,filename=fileroot + 'coherence'+pre+'_for_'+strtrim(periods[pselect],2) + '_min_period_fluctuations_of_hiss_and_xrays.idl'



;; get_data,'PeakDet_2Es_detrend',data=tst

;; r = deriv(tst.x,tst.y)

;; r = dydt_spike_test(tst.x,tst.y)

;; store_data,'tst_deriv',data={x:tst.x,y:r}

;; Function dydt_spike_test, t0, y0, dydt_lim = dydt_lim, $
;;                           sigma_y = sigma_y, nsig = nsig, $
;;                           no_degap = no_degap, $
;;                           degap_dt = degap_dt, $
;;                           degap_margin = degap_margin, $
;;                           _extra = _extra




;endfor


;List of times to perform the full coherence analysis on. I need to do
;this to avoid having all the salt and pepper data points overwhelming
;the results. Also, short duration spikes seen on multiple payloads
;often have a high, broadband coherence.




;; p = 'I'
;; date = '2014-01-07'
;; rbsp_load_barrel_lc,p,date
;; timespan,date
;; tplot,'PeakDet_2'+p
;; rbsp_detrend,['PeakDet_2'+p],60.*0.9
;; copy_data,'PeakDet_2'+p+'_smoothed','PeakDet_2'+p+'s'
;; tplot,['PeakDet_2'+p,'PeakDet_2'+p+'s']
;; rbsp_detrend,'PeakDet_2'+p+'s',60.*30.
;; tplot,['PeakDet_2'+p,'PeakDet_2'+p+'s','PeakDet_2'+p+'s_detrend']

;; get_data,'PeakDet_2'+p+'s_detrend',data=dd
;; vals = deriv(dd.x,dd.y)
;; store_data,'PeakDet_2'+p+'s_detrend_deriv',data={x:dd.x,y:abs(vals)}
;; ylim,'PeakDet_2'+p+'s_detrend_deriv',0,500
;; tplot,['PeakDet_2'+p,'PeakDet_2'+p+'s_detrend_deriv']


;; ;Normal smoothing I do





;;    rbsp_detrend,['PeakDet_2Es'],60.*9.

;; copy_data,'PeakDet_2Es_smoothed','PeakDet_2Es'
;; rbsp_detrend,'PeakDet_2Es',60.*30.


;; rbsp_detrend,'PeakDet_2Es',60.*0.2



;; tplot,['PeakDet_2Es','PeakDet_2Es_detrend']


stop


;--------------------------------------------------
;Clean up coherence spectrograms
;--------------------------------------------------

stop

;Save and restore specific files
fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/'
tplot_save,'coh_??',filename=fileroot+'coherence_spectra_for_testing' ;don't add .tplot
tplot_restore,filenames=fileroot+'coherence_spectra_for_testing.tplot' ;need .tplot



;; get_data,'coh_AV',data=image
;; goo = where(finite(image.y) eq 0)
;; if goo[0] ne -1 then image.y[goo] = 0.

;; image = image.y



;; ;image = dist(128) + 5*randomn(1, 128, 128)
;; ; Keep only 100 out of 16384 coefficients:
;; denoise = WV_DENOISE(image, 'Daubechies', 2, COEFF=100, $
;;    DENOISE_STATE=denoise_state)

;; denoise2 = WV_DENOISE(image, COEFF=100, $
;;     DENOISE_STATE=denoise_state, THRESHOLD=1)




;; window, xsize=256, ysize=155
;; tvscl, image, 0
;; tvscl, denoise2, 1
;; xyouts, [64, 196], [5, 5], ['Image', 'Filtered'], $
;;    /device, align=0.5, charsize=2
;; print, 'Percent of power retained: ', denoise_state.percent


;; faketimes = time_double('2013-01-31') + dindgen(4096)

;; store_data,'coh_AV_denoise',data={x:faketimes,y:denoise2}
;; tplot,'coh_AV_denoise'



;; ;; IDL prints:
;; ;; Percent of power retained:        93.151491
;; ;; Change to a “soft” threshold (use DENOISE_STATE to avoid re-computing):


;; get_data,'coh_AH',data=image
;; times_init = image.x
;; image = image.y

;; filteredImage = LEEFILT(image, 1)
;; store_data,'leefilt',data={x:times_init,y:filteredimage}
;; options,'leefilt','spec',1
;; tplot,['coh_AH','leefilt']


end








;;    filteredImage = LEEFILT(image, 6)
;;    fitots = fltarr(n_elements(image[*,0]))
;;    for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;;    store_data,'coh_'+p1+p2+'_leefilt6',data={x:times_init,y:filteredimage,v:coh.v}
;;    store_data,'coh_'+p1+p2+'_slicelee6',data={x:times_init,y:fitots}

;;    filteredImage = LEEFILT(image, 8)
;;    fitots = fltarr(n_elements(image[*,0]))
;;    for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;;    store_data,'coh_'+p1+p2+'_leefilt8',data={x:times_init,y:filteredimage,v:coh.v}
;;    store_data,'coh_'+p1+p2+'_slicelee8',data={x:times_init,y:fitots}

;;    options,'coh_'+p1+p2+'_leefilt*','spec',1
;; ;   tplot,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt*']



;**************************************************
;try median filter
;**************************************************

;; filteredimage = median(image, 2)
;; fitots = fltarr(n_elements(image[*,0]))
;; for hh=5,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh-4:hh+4,*])
;; store_data,'coh_'+p1+p2+'_medfilt2',data={x:times_init,y:filteredimage,v:coh.v}
;; store_data,'coh_'+p1+p2+'_slicemed1',data={x:times_init,y:fitots}

;; filteredimage = median(image, 3)
;; fitots = fltarr(n_elements(image[*,0]))
;; for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;; store_data,'coh_'+p1+p2+'_medfilt3',data={x:times_init,y:filteredimage,v:coh.v}
;; store_data,'coh_'+p1+p2+'_slicemed3',data={x:times_init,y:fitots}

;; filteredimage = median(image, 6)
;; fitots = fltarr(n_elements(image[*,0]))
;; for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;; store_data,'coh_'+p1+p2+'_medfilt6',data={x:times_init,y:filteredimage,v:coh.v}
;; store_data,'coh_'+p1+p2+'_slicemed6',data={x:times_init,y:fitots}

;; filteredimage = median(image, 8)
;; fitots = fltarr(n_elements(image[*,0]))
;; for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;; store_data,'coh_'+p1+p2+'_medfilt8',data={x:times_init,y:filteredimage,v:coh.v}
;; store_data,'coh_'+p1+p2+'_slicemed8',data={x:times_init,y:fitots}

;; filteredimage = median(image, 12)
;; fitots = fltarr(n_elements(image[*,0]))
;; for hh=0,n_elements(image[*,0])-1 do fitots[hh] = total(filteredimage[hh,*])
;; store_data,'coh_'+p1+p2+'_medfilt12',data={x:times_init,y:filteredimage,v:coh.v}
;; store_data,'coh_'+p1+p2+'_slicemed12',data={x:times_init,y:fitots}

;; options,'coh_'+p1+p2+'_medfilt*','spec',1


;**************************************************
;try wavelet filter
;**************************************************

;;    denoise = WV_DENOISE(image,'Daubechies',4,coeff=100, $
;;                         DENOISE_STATE=denoise_state)
;;    denoise = WV_DENOISE(image,coeff=100,threshold=1,denoise_state=denoise_state)
;;    print, 'Percent of power retained: ', denoise_state.percent


;;    t0t = times_init[0]
;;    t1t = times_init[n_elements(times_init)-1]

;;    newtimes = t0t + (t1t-t0t)*dindgen(n_elements(denoise[*,0]))/(n_elements(denoise[*,0])-1)

;;    store_data,'coh_'+p1+p2+'_wvfilt',data={x:newtimes,y:denoise}
;;    options,'coh_'+p1+p2+'_wvfilt','spec',1
;; ;   tplot,'coh_'+p1+p2+'_wvfilt'
