;****things to check
;--see if the chorus is being properly integrated over
;--compare detrending of chorus to detrending of PeakDet. Make sure
;they are the same








;Note that this is the same as full_mission_coherency_plot.pro but for
;combinations of a single satellite and balloon instead of two balloons


;Calculate the coherency b/t all combinations of BARREL payloads
;This is done in multiple steps
;1) load all the BARREL data for each balloon for entire
;mission. Outputs as .tplot save file
;2) run this data for all balloon combinations through Lei's
;coherence program. Outputs as .tplot save file

;.compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/idl/combine_rbsp_data.pro

;**************************************************
;These following segments of the program only need to be run
;once. They save .tplot save files 
create_rbsp_tplot = 0 ;call combine_rbsp_data.pro to create the Efield/Bfield files for entire mission
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

tplot_options,'title','from full_mission_coherency_plot_sc_and_balloon.pro'

;; ;; 2014 campaign
;; ;; ------
;; pre = '2'
;; date = '2013-12-27'
;; ndays = 47
;; ;; date = '2014-01-01'
;; ;; ndays = 10
;; timespan,date,ndays,/days
;; payloads = strupcase(['a','b','c','d','e','f','i','k','l','m','n','o','p','q','t','w','x','y'])
;; ;;payloads = strupcase(['i','k','l','w','x'])
;; mlt_min = 0.
;; mlt_max = 24.
;; probe = 'b'

;DATA POINTS TO REMOVE
;; plds = ['AB','AB','AC','AL','BO','DO','DO','EO','EO','EP','EP','EQ',$
;;         'FO','FP','FQ','IK','IW','LO','LX','OQ','PQ']
;; tt0 = ['2014-01-25/23:30',$
;;        '2014-01-29/03:00',$
;;        '2014-01-20/18:00',$
;;        '2014-01-25/23:30',$
;;        '2014-01-27/20:00',$
;;        '2014-01-27/17:00',$
;;        '2014-01-28/13:00',$
;;        '2014-01-31/16:00',$
;;        '2014-02-02/17:00',$
;;        '2014-01-31/16:00',$
;;        '2014-02-02/17:00',$
;;        '2014-02-02/17:00',$
;;        '2014-02-02/17:00',$
;;        '2014-02-02/17:00',$
;;        '2014-02-02/17:00',$
;;        '2014-01-07/23:00',$
;;        '2014-01-09/01:30',$
;;        '2014-01-28/19:00',$
;;        '2014-01-07/17:00',$
;;        '2014-02-02/17:30',$
;;        '2014-02-02/17:30']

;; tt1 = ['2014-01-26/02:30',$
;;        '2014-01-29/06:00',$
;;        '2014-01-20/22:00',$
;;        '2014-01-26/03:00',$
;;        '2014-01-27/24:00',$
;;        '2014-01-27/20:20',$
;;        '2014-01-28/17:00',$
;;        '2014-01-31/18:00',$
;;        '2014-02-02/19:00',$
;;        '2014-01-31/18:00',$
;;        '2014-02-02/19:00',$
;;        '2014-02-02/19:00',$
;;        '2014-02-02/19:00',$
;;        '2014-02-02/19:00',$
;;        '2014-02-02/19:00',$
;;        '2014-01-08/00:30',$
;;        '2014-01-09/02:30',$
;;        '2014-01-28/20:20',$
;;        '2014-01-07/20:00',$
;;        '2014-02-02/19:00',$
;;        '2014-02-02/19:00']

;; combos_final = ['EP','IK','IW','KL','KW','KX','LM','LW','LX','MT','MX','MY','NY']


;; ;AB jan25 2330 - jan26 0230
;; ;   jan29 0300 - 0600
;; ;AC jan20 1800 - 2200
;; ;AL jan25 2330 - jan26 0300
;; ;BO jan27 2000 - 2400
;; ;DO jan27 1700 - 2020
;; ;   jan28 1300 - 1700
;; ;EO jan31 1600 - 1800
;; ;   feb02 1700 - 1900
;; ;EP jan31 1600 - 1800
;; ;   feb02 1700 - 1900

;; ;EQ feb02 1700 - 1900
;; ;FO feb02 1700 - 1900
;; ;FP feb02 1700 - 1900
;; ;FQ feb02 1700 - 1900
;; ;IK jan07 2300 - jan08 0030
;; ;IW jan09 0130 - 0230
;; ;LO jan28 1900 - 2020
;; ;LX jan07 1700 - 2000
;; ;OQ feb02 1730 - 1900
;; ;PQ feb02 1730 - 1900

;; ;; ------
;; ;; 2013 campaign
pre = '1'
date = '2013-01-01'  ;Multiple balloons up from Jan 1, 2013 - Feb 15
ndays = 45      
timespan,date,ndays,/days
payloads = strupcase(['a','b','c','d','g','h','i','j','k','m','o','q','r','s','t','u','v'])
probe = 'a'
mlt_min = 0.
mlt_max = 24.

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

;Excellent coherence
;combos_final = ['AT','AU','AV','CD','CG','CH','CR','CS','CT','GI','HQ','HR','HS','HT','IT','QT','QU','TU','UV']
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

;days of BARRELcampaign
;dates = time_string(86400.*indgen(5 + 30 + 12) + time_double(date))
dates = time_string(86400.*indgen(ndays) + time_double(date))
;payloads = strupcase(['a','b','c'])

;**************************************************
;CODE FOR CREATING FULL MISSION TPLOT FILES
;**************************************************
if create_rbsp_tplot then begin
   if pre eq '1' then combine_rbsp_data,probe,dates,'Ew'
   if pre eq '2' then combine_rbsp_data,probe,dates,'Bw'
   fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/' 
   tplot_save,'*',filename=fileroot+'rbsp_fullmission'+pre ;don't add .tplot
endif else tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/rbsp_fullmission'+pre+'.tplot'



if pre eq '1' then rbsp_detrend,'wave_rms',60.*0.05
if pre eq '2' then rbsp_detrend,'wave_rms',60.*0.2
copy_data,'wave_rms_smoothed','wave_rmss'
rbsp_detrend,'wave_rmss',60.*30.
tplot,'wave_rmss_detrend'
ylim,'wave_rmss_detrend',0,0
tplot,['wave_rms','wave_rmss','wave_rmss_detrend']


;stop

tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/barrel_fullmission'+pre+'.tplot'


;**************************************************
;Smooth and detrend data
;**************************************************



;; Get rid of NaN values in the peak detector data. This messes up the downsampling

for i=0,n_elements(payloads)-1 do begin   
   get_data,'PeakDet_'+pre+payloads[i],data=dd    
   goo = where(dd.y lt 0.)   
   if goo[0] ne -1 then dd.y[goo] = !values.f_nan  
   xv = dd.x   
   yv = dd.y   
   interp_gap,xv,yv   
   store_data,'PeakDet_'+pre+payloads[i],data={x:xv,y:yv}   
   options,'PeakDet_'+pre+payloads[i],'colors',250
endfor



if pre eq '1' then rbsp_detrend,['PeakDet_'+pre+'?'],60.*0.05
if pre eq '2' then rbsp_detrend,['PeakDet_'+pre+'?'],60.*0.2
for i=0,n_elements(payloads)-1 do copy_data,'PeakDet_'+pre+payloads[i]+'_smoothed','PeakDet_'+pre+payloads[i]+'s'

ylim,['PeakDet_'+pre+'?s'],0,10000
tplot,['PeakDet_'+pre+'?s']

rbsp_detrend,['PeakDet_'+pre+'?s'],60.*30.

ylim,['PeakDet_'+pre+'?s_detrend'],-800,800
tplot,['PeakDet_'+pre+'?s_detrend']



;**********************************************************************
;Code for creating all combinations of cross-correlation
;**********************************************************************


if create_coh_tplot then begin

   if pre eq '2' then begin
      window = 60.*30.
      lag = window/4.
      coherence_time = window*2.5
      cormin = 0.4
   endif else begin
      window = 60.*30.
      lag = window/4.
      coherence_time = window*2.5
      cormin = 0.4
   endelse

   T1 = date
   T2 = time_string(time_double(date) + 86400.*(ndays+1))
   ;; T1 = '2013-12-27/00:00:00'
   ;; T2 = '2014-02-17/24:00:00'


   for bb=0,n_elements(payloads)-1 do begin
      p1 = strmid(payloads[bb],0,1)
      p2 = probe

      v1 = 'PeakDet_'+pre+p1+'s_detrend'
      if pre eq '1' then v2 = 'wave_rmss'
      if pre eq '2' then v2 = 'wave_rmss_detrend'


      ;;                           ;Remove very low wave and peak
      ;;                           ;detector values
      ;; get_data,v1,data=v1goo
      ;; goo = where((v1goo.y le 150) and (v1goo.y ge -150)) 
      ;; if goo[0] ne -1 then v1goo.y[goo] = !values.f_nan
      ;; store_data,v1,data=v1goo

      ;; get_data,v2,data=v2goo
      ;; if pre eq '1' then goo = where((v2goo.y le 0.3) and (v2goo.y ge -0.3)) 
      ;; if pre eq '2' then goo = where((v2goo.y le 0.005) and (v2goo.y ge -0.005)) 
      ;; if goo[0] ne -1 then v2goo.y[goo] = !values.f_nan
      ;; store_data,v2,data=v2goo


      dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'  
      copy_data,'Precip_hiss_coherence','coh_'+p1+p2
      copy_data,'Precip_hiss_phase','phase_'+p1+p2
      
      get_data,'coh_'+p1+p2,data=coh
      get_data,'phase_'+p1+p2,data=ph
      goo = where(coh.y le cormin)
      if goo[0] ne -1 then coh.y[goo] = !values.f_nan
      if goo[0] ne -1 then ph.y[goo] = !values.f_nan
      boo = where(finite(coh.y) eq 0)
      if boo[0] ne -1 then ph.y[boo] = !values.f_nan


      store_data,'coh_'+p1+p2,data=coh
      store_data,'phase_'+p1+p2,data=ph
      options,'coh_'+p1+p2,'ytitle','Precip Coherence!C'+pre+p1+' vs '+pre+p2+'!Cfreq[Hz]'
      options,'phase_'+p1+p2,'ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
      ylim,['coh_'+p1+p2,'phase_'+p1+p2],-0.001,0.01



      dif_data,'L_Kp2_'+pre+p1,'rbsp'+probe+'_state_lshell'
      get_data,'L_Kp2_'+pre+p1+'-rbsp'+probe+'_state_lshell',data=dl
      store_data,'dlshell_Kp2_'+p1+p2,data={x:dl.x,y:abs(dl.y)}

      dif_data,'MLT_Kp2_'+pre+p1,'rbsp'+probe+'_state_mlt'
      get_data,'MLT_Kp2_'+pre+p1+'-rbsp'+probe+'_state_mlt',data=ml
      store_data,'dmlt_Kp2_'+p1+p2,data={x:ml.x,y:abs(ml.y)}

      dif_data,'L_Kp6_'+pre+p1,'rbsp'+probe+'_state_lshell'
      get_data,'L_Kp6_'+pre+p1+'-rbsp'+probe+'_state_lshell',data=dl
      store_data,'dlshell_Kp6_'+p1+p2,data={x:dl.x,y:abs(dl.y)}

      dif_data,'MLT_Kp6_'+pre+p1,'rbsp'+probe+'_state_mlt'
      get_data,'MLT_Kp6_'+pre+p1+'-rbsp'+probe+'_state_mlt',data=ml
      store_data,'dmlt_Kp6_'+p1+p2,data={x:ml.x,y:abs(ml.y)}

      ylim,'dlshell_Kp2_'+p1+p2,0,20
      ylim,'dmlt_Kp2_'+p1+p2,0,24 
      ylim,'dlshell_Kp6_'+p1+p2,0,20
      ylim,'dmlt_Kp6_'+p1+p2,0,24 

   endfor




   fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/'
   tplot_save,['coh_??','phase_??'],filename=fileroot+'rbsp_barrel_fullmission'+pre+'_coherency'
   tplot_save,['dlshell_Kp2_??','dmlt_Kp2_??'],filename=fileroot+'rbsp_barrel_fullmission'+pre+'_dlshell_dmlt_Kp2'
   tplot_save,['dlshell_Kp6_??','dmlt_Kp6_??'],filename=fileroot+'rbsp_barrel_fullmission'+pre+'_dlshell_dmlt_Kp6'
endif else begin
   tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/rbsp_barrel_fullmission'+pre+'_coherency.tplot'
   tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/rbsp_barrel_fullmission'+pre+'_dlshell_dmlt_Kp2.tplot'
   tplot_restore,filenames='~/Desktop/Research/RBSP_hiss_precip/idl/rbsp_barrel_fullmission'+pre+'_dlshell_dmlt_Kp6.tplot'
endelse




;; ;Limit the coherence spectrum based on wave amplitude and other
;; ;properties...

;; for bb=0,n_elements(payloads)-1 do begin

;;    get_data,'coh_'+payloads[bb] + probe,data=coh

;;    tinterpol_mxn,'wave_rmss_detrend',coh.x
;;    tinterpol_mxn,'PeakDet_'+pre+payloads[bb]+'s_detrend',coh.x
;;    get_data,'wave_rmss_detrend_interp',data=wave
;;    get_data,'PeakDet_'+pre+payloads[bb]+'s_detrend_interp',data=pd
 
;;    ;; tplot,['coh_'+payloads[bb] + probe,'wave_rmss_detrend','wave_rmss_detrend_interp',$
;;    ;;       'PeakDet_'+pre+payloads[bb]+'s_detrend','PeakDet_'+pre+payloads[bb]+'s_detrend_interp']



;;    if pre eq '1' then goo = where((wave.y le 0.1) and (wave.y ge -0.1))
;;    if pre eq '2' then goo = where((wave.y le 0.005) and (wave.y ge -0.005))
;;    if goo[0] ne -1 then coh.y[goo,*] = !values.f_nan

;;    goo = where((pd.y le 100) and (pd.y ge -100))
;;    if goo[0] ne -1 then coh.y[goo,*] = !values.f_nan

;;    store_data,'coh_'+payloads[bb] + probe,data=coh


;; ;;    tplot,['coh_'+payloads[bb] + probe,'wave_rmss_detrend','wave_rmss_detrend_interp',$
;; ;;          'PeakDet_'+pre+payloads[bb]+'s_detrend','PeakDet_'+pre+payloads[bb]+'s_detrend_interp']

;; ;; stop

;; endfor





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




;periods_final = [30.,15.,10.,5.,3.3,2.5,1.5,1.,0.75,0.5]  ;periods to save data for


tplot_options,'title','from full_mission_coherence_plot_sc_and_balloon.pro!CMLTs b/t '+strtrim(mlt_min,2)+' - '+strtrim(mlt_max,2)
fileroot = '~/Desktop/Research/RBSP_hiss_precip/idl/' 

window,1
window,2

!p.charsize = 0.8

;for j=0,n_elements(periods_final)-1 do begin
a1 = ''
a2 = 0.
a3 = 0.
a4 = 0.
a5 = 0d                         ;times
a6 = 0.                         ;coh avg



for i=0,n_elements(payloads)-1 do begin

   p1 = strmid(payloads[i],0,1)
   p2 = probe

   v1 = 'PeakDet_'+pre+p1+'s_detrend'
;   v2 = 'PeakDet_'+pre+p2+'s_detrend'
   v2 = 'wave_rmss_detrend'

                                ;Get time range for zoom-in
   get_data,v1,data=vv1
   get_data,v2,data=vv2
   tmin1 = min(vv1.x,/nan)
   tmax1 = max(vv1.x,/nan)
   tmin2 = min(vv2.x,/nan)
   tmax2 = max(vv2.x,/nan)

   mint = tmin1 > tmin2
   maxt = tmax1 < tmax2

   if mint lt maxt then begin
      tlimit,mint,maxt 

      
      get_data,'coh_'+p1+p2,data=coh

      tinterpol_mxn,'L_Kp2_'+pre+p1,coh.x,newname='L_Kp2_'+pre+p1+'_ct'
      tinterpol_mxn,'rbsp'+probe+'_state_lshell',coh.x,newname='L_Kp2_'+pre+p2+'_ct'
      tinterpol_mxn,'MLT_Kp2_'+pre+p1,coh.x,newname='MLT_Kp2_'+pre+p1+'_ct'
      tinterpol_mxn,'rbsp'+probe+'_state_mlt',coh.x,newname='MLT_Kp2_'+pre+p2+'_ct'
      tinterpol_mxn,'dlshell_Kp2_'+p1+p2,coh.x,newname='dL_'+p1+p2
      tinterpol_mxn,'dmlt_Kp2_'+p1+p2,coh.x,newname='dMLT_'+p1+p2


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



;;Limit the coherence spectrum based on integrated coherence

      goo = where(cohavg lt 0.3)
      if goo[0] ne -1 then coh.y[goo,*] = !values.f_nan
      store_data,'coh_'+p1+p2,data=coh
      






;**************************************************

      uoo = where(cohavg eq 0.)
      if uoo[0] ne -1 then cohavg[uoo] = !values.f_nan

      get_data,'coh_'+pdstr+'min_'+p1+p2,data=coh
      get_data,'dL_'+p1+p2,data=dl
      get_data,'dMLT_'+p1+p2,data=dmlt


      wset,2

      !p.multi = [0,0,2]
      plot,abs(dl.y),cohavg,xrange=[0,10],yrange=[0,1],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
      plot,abs(dmlt.y),cohavg,xrange=[0,10],yrange=[0,1],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4




      wset,1

      ylim,['L_Kp2_'+pre+p1+'_ct','L_Kp2_'+pre+p2+'_ct','dL_'+p1+p2],0.1,10,1
      ylim,'coh_'+pdstr+'min_'+p1+p2,0.5,1,0
      ylim,'dMLT_'+p1+p2,0.1,10,1

;      tplot,[v1,v2,'coh_'+p1+p2,'cohavg_'+p1+p2,'coh_'+pdstr+'min_'+p1+p2,'dL_'+p1+p2,'dMLT_'+p1+p2]

      tplot,[v1,v2,'coh_'+p1+p2,'cohavg_'+p1+p2,'dL_'+p1+p2,'dMLT_'+p1+p2]

      stop

      popen,'~/Desktop/full_mission_coherence_'+p1+p2+'.ps'
      tplot
      pclose



;; !p.multi = [0,0,2]
;; plot,abs(dl.y),coh.y,xrange=[0,10],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4
;; plot,abs(dmlt.y),coh.y,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!C'+p1+' vs '+p2,psym=4


      a1 = [a1,replicate(payloads[i],n_elements(dl.x))]
      a2 = [a2,dl.y]
      a3 = [a3,dmlt.y]
      a4 = [a4,coh.y]
      a5 = [a5,coh.x]
      a6 = [a6,cohavg]


      print,'***** ',i
      print,'***** imax=',n_elements(payloads)-1


   endif


endfor


stop


;Remove first element
nelem = n_elements(a1)
a1 = a1[1:nelem-1]
a2 = a2[1:nelem-1]
a3 = a3[1:nelem-1]
a4 = a4[1:nelem-1]
a5 = a5[1:nelem-1]
a6 = a6[1:nelem-1]


;; ;Plot coherence for all payload combinations
;;    !p.multi = [0,0,2]
;;    plot,abs(a2),a4,xrange=[0,2],xtitle='delta-Lshell',ytitle='Coherence',title='Coherence!Call payload combinations!Cfor '+strtrim(periods[pselect],2)+' min fluctuations',psym=4
;;    plot,abs(a3),a4,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',title='Coherence!Call payload combinations!Cfor '+strtrim(periods[pselect],2)+' min fluctuations',psym=4


;**************************************************
;Plot coherence for all payload combinations
!p.multi = [0,0,2]


                                ;Find points for certain days

tb0 = time_double('2014-01-02/00:00')
tb1 = time_double('2014-01-02/24:00')
boo2 = where((a5 ge tb0) and (a5 le tb1))
tb0 = time_double('2014-01-03/00:00')
tb1 = time_double('2014-01-03/24:00')
boo3 = where((a5 ge tb0) and (a5 le tb1))
tb0 = time_double('2014-01-04/00:00')
tb1 = time_double('2014-01-04/24:00')
boo4 = where((a5 ge tb0) and (a5 le tb1))
tb0 = time_double('2014-01-05/00:00')
tb1 = time_double('2014-01-05/24:00')
boo5 = where((a5 ge tb0) and (a5 le tb1))
tb0 = time_double('2014-01-06/00:00')
tb1 = time_double('2014-01-06/24:00')
boo6 = where((a5 ge tb0) and (a5 le tb1))




plot,abs(a2),a6,xrange=[0,10],xtitle='delta-Lshell',ytitle='Coherence',title='Avg Coherence from '+fmin+'-'+fmax+' mHz'+'!Call payload combinations',psym=4
oplot,abs(a2[boo2]),a6[boo2],color=200,psym=4
oplot,abs(a2[boo3]),a6[boo3],color=250,psym=4
oplot,abs(a2[boo4]),a6[boo4],color=120,psym=4
oplot,abs(a2[boo5]),a6[boo5],color=170,psym=4
oplot,abs(a2[boo6]),a6[boo6],color=50,psym=4


plot,abs(a3),a6,xrange=[0,10],xtitle='delta-MLT',ytitle='Coherence',title='Avg Coherence from '+fmin+'-'+fmax+' mHz'+'!Call payload combinations',psym=4
oplot,abs(a3[boo2]),a6[boo2],color=200,psym=4
oplot,abs(a3[boo3]),a6[boo3],color=250,psym=4
oplot,abs(a3[boo4]),a6[boo4],color=120,psym=4
oplot,abs(a3[boo5]),a6[boo5],color=170,psym=4
oplot,abs(a3[boo6]),a6[boo6],color=50,psym=4



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

end












