;;Make a plot of the integrated fluctuations in the SW 0.1-3 mHz
;;pressure fluctuations vs time. Compare to integrated 0.1-3 mHz
;;coherence during this time. 

;; .compile /Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/ace_wind/read_ace_wind.pro
;; read_ace_wind


pro plot_missionwide_coherence


  ;;Load files created from
;;  /Users/aaronbreneman/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/create_barrel_xray_fft.pro


  noload_tplot = 1


;;   path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/wind/barrel_mission2/'
;;   fn = 'wi_ems_3dp_20131225000000_20140214235958.cdf'
;;   cdf2tplot,files=path+fn
;;   fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
;;   cdf2tplot,files=path+fn
;;   fn = 'wi_k0s_3dp_20131225000105_20140214235952.cdf'
;;   cdf2tplot,files=path+fn
;;   fn = 'wi_k0s_swe_20131225000105_20140214235829.cdf'
;;   cdf2tplot,files=path+fn
;;   fn = 'wi_pms_3dp_20131225000002_20140215000000.cdf'
;;   cdf2tplot,files=path+fn



;; ;;shift the Wind data by a set amount
;;   get_data,'P_DENS',data=dd
;;   store_data,'P_DENS',data={x:dd.x+60.*42,y:dd.y}

;;   ;; tplot,['E_DENS','elect_density','Np','Np_l','P_DENS']
;;   ;; tplot,['P_DENS','Pressure_omni']


;; ;Get rid of NaN values in the peak detector data. This messes up the downsampling
;;   get_data,'P_DENS',data=dd
;;   goo = where(dd.y lt 0.)
;;   if goo[0] ne -1 then dd.y[goo] = !values.f_nan
;;   xv = dd.x
;;   yv = dd.y
;;   interp_gap,xv,yv
;;   store_data,'P_DENS',data={x:xv,y:yv}
;;   options,'P_DENS','colors',250


;; ;; rbsp_spec,'Pressure2',npts=256/2,n_ave=1
;;   rbsp_spec,'P_DENS',npts=256*16,n_ave=1

;;   get_data,'P_DENS_SPEC',data=dd
;;   store_data,'P_DENS_SPEC',data={x:dd.x,y:dd.y,v:1000*dd.v}
;;   options,'P_DENS_SPEC','spec',1
;; ;; ylim,'P_DENS_SPEC',0.4,10,1

;;   options,'P_DENS_SPEC','ytitle','SW Pressure!Cfluctuations!C[mHz]'



;;   ylim,['Pressure_omni_SPEC','P_DENS_SPEC'],0.1,3,0
;;   zlim,'P_DENS_SPEC',1,1d3,1
;;   zlim,'Pressure_omni_SPEC',1,1000,1
;;   ylim,'P_DENS',0.1,30,1


;; ;;Integrate density fluctuations from 0.1-3 mHz
;;   get_data,'P_DENS_SPEC',data=pspec

;;   goodfreq = where((pspec.v ge 0.1) and (pspec.v le 3))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes-0.1-3',data={x:pspec.x,y:sqrt(ptotes)}

;;   goodfreq = where((pspec.v ge 3) and (pspec.v le 10))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes-3-10',data={x:pspec.x,y:sqrt(ptotes)}

;;   goodfreq = where((pspec.v ge 10) and (pspec.v le 50))
;;   ptotes = fltarr(n_elements(pspec.x))
;;   for jj=0,n_elements(pspec.x)-1 do ptotes[jj] = total(pspec.y[jj,goodfreq],/nan)
;;   store_data,'ptotes-10-50',data={x:pspec.x,y:sqrt(ptotes)}


;; ;; ylim,'ptotes-0.1-3',1,50000,1
;;   ylim,'ptotes-0.1-3',1,1000,1
;;   ylim,'ptotes-3-10',1,1000,1
;;   ylim,'ptotes-10-50',1,1000,1
;;   ;; tplot,['P_DENS','P_DENS_SPEC','ptotes-0.1-3','ptotes-3-10','ptotes-10-50']



  path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/tplot_vars_2014/'



  combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']

  
  ;;load the data?
  if ~keyword_set(noload_tplot) then for i=0,n_elements(combos)-1 do $
     tplot_restore,filenames=path + combos[c] + '.tplot'


  coh_fin = 0.
  psw_fin = 0.
  jj=0.

  get_data,'ptotes-0.1-3',data=ptotes

  for c=0,n_elements(combos)-1 do begin



;;Interpolate to common times
     get_data,'coh_'+combos[c]+'_band4',data=coh
     goo = where((coh.v gt 0.1) and (coh.v le 3))
     totes = fltarr(n_elements(coh.x))
     for i=0L,n_elements(coh.x)-1 do totes[i] = total(coh.y[i,goo],/nan)/n_elements(goo)
     store_data,'totes_'+combos[c]+'_band4',data={x:coh.x,y:totes^3}


     tinterpol_mxn,'totes_'+combos[c]+'_band4','ptotes-0.1-3'
     tinterpol_mxn,'delta_lshell_2'+combos[c],'ptotes-0.1-3'

     get_data,'delta_lshell_2'+combos[c]+'_interp',data=dl
     get_data,'totes_'+combos[c]+'_band4_interp',data=t

     bad = where(dl.y gt 1.)
     if bad[0] ne -1 then t.y[bad] = !values.f_nan
     bad = where(t.y eq 0.)
     if bad[0] ne -1 then t.y[bad] = !values.f_nan
     
     store_data,'totes_'+combos[c]+'_band4_good',data={x:t.x,y:t.y}

     options,'coh_'+combos[c]+'_band4','spec',1
     ylim,'coh_'+combos[c]+'_band4',0.1,3,0

     goo = where(finite(t.y) ne 0.)
     if goo[0] ne -1 then begin
        coh_fin = [coh_fin, t.y[goo]]
        psw_fin = [psw_fin, ptotes.y[goo]]
     endif
  endfor


  ;;plot integrated coherence vs integrated SW pressure from 0.1-3 mHz
  plot,psw_fin,coh_fin,/xlog,xrange=[0.1,200],psym=4,yrange=[0,0.15]

  ;;plot integrated coherence vs Lshell separation


  stop
tplot,['P_DENS_SPEC','ptotes-0.1-3',$
'totes_KL_band4_good',$
'totes_IW_band4_good',$
'totes_TK_band4_good',$
'totes_TL_band4_good',$
'totes_TX_band4_good',$
'totes_WK_band4_good',$
'totes_WL_band4_good',$
'totes_WX_band4_good',$
'totes_KX_band4_good',$
'totes_LX_band4_good',$
'totes_LA_band4_good',$
'totes_LB_band4_good',$
'totes_LE_band4_good',$
'totes_LO_band4_good',$
'totes_LP_band4_good',$
'totes_XA_band4_good',$
'totes_XB_band4_good',$
'totes_AB_band4_good',$
'totes_AE_band4_good',$
'totes_AO_band4_good',$
'totes_AP_band4_good',$
'totes_BE_band4_good',$
'totes_BO_band4_good',$
'totes_BP_band4_good',$
'totes_EO_band4_good',$
'totes_EP_band4_good',$
'totes_OP_band4_good']

  ylim,'totes_??_band4_good',0,0.2
  tplot,['P_DENS_SPEC','ptotes-0.1-3','totes_??_band4_good']

end

