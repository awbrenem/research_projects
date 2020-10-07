

pro radial_magnetic_model_profile

  rbsp_efw_init

;  angles = [0,-15,-30,-45,-60,-75,-90]
;  angles = [0,-45,-70,-90]  ;afternoon side
;  angles = [0,45,70,90]  ;morningside
  angles = [-120,-145,-170,-180]  ;morningside

  angles_str = ''
  for b=0,n_elements(angles)-1 do angles_str += strtrim(angles[b],2)+','

popen,'~/Desktop/mag_radial_profile.ps',/landscape
!p.charsize = 1


  for i=0,n_elements(angles)-1 do begin
     angle = angles[i] * !dtor

     radii = 0.2*indgen(150) * 6370.
     gsmx = radii*cos(angle)
     gsmy = radii*sin(angle)
     gsmz = gsmx
     gsmz[*] = 0.

     pos = [[gsmx],[gsmy],[gsmz]]


;     t0 = time_double('2014-01-03/21:00')
     t0 = time_double('2014-01-06/21:00')
     times = replicate(t0,150)

     da = {coord_sys:'gsm',st_type:'pos',units:'km'}
     dlimits = {spec:0,log:0,data_att:da,colors:[2,4,6],labels:['x_gse','y_gse','z_gse'],ysubtitle:'[km]'}

     store_data,'pos_gsm',data={x:times,y:pos},dlimits=dlimits

     posname = 'pos_gsm'

     ;;        model = 't89'
;;         if model eq 't89' then par = 2.0D

;; 	;; if model eq 't96' then call_procedure,'t'+model,posname,pdyn=2.0D,dsti=-30.0D,$
;; 	;; 	yimf=0.0D,zimf=-5.0D
;; 	if model eq 't89' then call_procedure,'t'+model,posname,kp=2.0		


;; ;	copy_data,'pos_gsm_b'+model,rbspx+'_mag_gsm_'+model

;;         get_data,'pos_gsm_b'+model,data=mag

;;         magnit = sqrt(mag.y[*,0]^2 + mag.y[*,1]^2 + mag.y[*,2]^2)
;;         fce = 28.*magnit
;;         fce_10 = fce * 0.1

;;         plot,radii/6370.,fce,xrange=[0,20],yrange=[100,100000],ylog=1
;;         oplot,radii/6370,fce_10

     

;--------------------------------------------------
;OMNI

     model = 't96'
;     timespan,'2014-01-03/21:00',1,/hour
     timespan,'2014-01-06/21:00',1,/hour
     omni_hro_load,tplotnames=tn
     kyoto_load_dst
     
     store_data,'omni_imf',data=['OMNI_HRO_1min_BY_GSM','OMNI_HRO_1min_BZ_GSM']
     get_tsy_params,'kyoto_dst','omni_imf','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_flow_speed',$
                    strupcase(model),/speed,/imf_yz
          
     
                                ;call_procedure,'igrf',posname,parmod=model+'_par' $
     call_procedure,'t'+model,posname,parmod=model+'_par'


     get_data,'pos_gsm_bt96',data=omni

     magnito = sqrt(omni.y[*,0]^2 + omni.y[*,1]^2 + omni.y[*,2]^2)
     fceo = 28.*magnito
     fceo_2 = fceo/2.
     fceo_10 = fceo * 0.1


;Remove values beyond the Shue magnetopause (Jan6 at 2100)
     ;; if angles[i] eq 0 then bad = where(radii/6370. ge 12)
     ;; if angles[i] eq -30 then bad = where(radii/6370. ge 12)
     ;; if angles[i] eq -45 then bad = where(radii/6370. ge 13.3)
     ;; if angles[i] eq -70 then bad = where(radii/6370. ge 15.5)
     ;; if angles[i] eq -90 then bad = where(radii/6370. ge 18.1)

;Remove values beyond the Shue magnetopause (Jan3 at 2100)
     ;; if angles[i] eq 0 then bad = where(radii/6370. ge 11.2)
     ;; if angles[i] eq -30 then bad = where(radii/6370. ge 11.8)
     ;; if angles[i] eq -45 then bad = where(radii/6370. ge 12.3)
     ;; if angles[i] eq -70 then bad = where(radii/6370. ge 14.1)
     ;; if angles[i] eq -90 then bad = where(radii/6370. ge 16.6)

;Remove values beyond the Shue magnetopause (Jan3 at 2100)
;;      if angles[i] eq -120 then bad = where(radii/6370. ge 11.2)
;;      if angles[i] eq -145 then bad = where(radii/6370. ge 11.8)
;;      if angles[i] eq -170 then bad = where(radii/6370. ge 12.3)
;;      if angles[i] eq -180 then bad = where(radii/6370. ge 14.1)
;; ;     if angles[i] eq -90 then bad = where(radii/6370. ge 16.6)
;;  ; angles = [-120,-145,-170,-180]  ;morningside


;;      if bad[0] ne -1 then fceo[bad] = !values.f_nan
;;      if bad[0] ne -1 then fceo_2[bad] = !values.f_nan
;;      if bad[0] ne -1 then fceo_10[bad] = !values.f_nan


;; title = 'Radial magnetic field profiles (GSMz=0)!Cfor 0,-15,-30,-45,-60,-75,-90 deg!Cfce, fce/2 and 0.1*fce shown'
title = 'Radial magnetic field profiles (GSMz=0)!Cfor ' + angles_str + ' deg (GSM eq)!Cfce, fce/2 and 0.1*fce shown!Cfrom radial_magnetic_model_profile.pro'

     if i eq 0 then begin
        plot,radii/6370.,fceo,xrange=[0,20],yrange=[10,100000],ylog=1,$
             title=title,ytitle='fce,fce/2,0.1*fce (Hz)',xtitle='RE'
        oplot,radii/6370.,fceo_2,linestyle=3
        oplot,radii/6370.,fceo_10,linestyle=2
     endif else begin
        oplot,radii/6370.,fceo,color=i*80.
        oplot,radii/6370.,fceo_2,linestyle=3,color=i*80.
        oplot,radii/6370.,fceo_10,color=i*80,linestyle=2
     endelse

     oplot,[0,20],[100.,100.]



;stop

endfor

pclose

end

