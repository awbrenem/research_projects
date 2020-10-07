;Apply a Lee filter to the coherence spectra from Lei's
;coherence program. Called from create_coh_ascii.pro

;*******************
;OBSOLETE --- SEE PY_FILTER_COH_TPLOT.PRO
;*******************

pro filter_coh_tplot,tname



;**************************************************
;Lee filter
;**************************************************

  tname = tnames(tname)
  get_data,tname,data=coh


  p1 = strmid(tname,4,1)
  p2 = strmid(tname,5,1)
  ntime_smooth = 20


  goo = where(finite(coh.y) eq 0.)
  if goo[0] ne -1 then coh.y[goo] = 0.


  filteredImage = LEEFILT(coh.y, 6)  
  fispec = filteredimage
  fispec[*] = 0.
  fitots = fltarr(n_elements(coh.y[*,0]))
  fitots2 = fltarr(n_elements(coh.y[*,0]))



                                ;running time smooth filter. This
                                ;helps beat down the intense spikes
                                ;from SEP events and emphasizes the
                                ;longer-duration actual events
  for hh=ntime_smooth+1,n_elements(coh.y[*,0])-ntime_smooth-1 do begin
     for yy=0,n_elements(coh.y[0,*])-1 do begin
        fispec[hh,yy] = total(filteredimage[hh-ntime_smooth :hh+ntime_smooth,yy]) 
     endfor
  endfor


  for hh=0,n_elements(coh.y[*,0])-1 do fitots[hh] = total(filteredimage[hh,0:40])
  for hh=0,n_elements(coh.y[*,0])-1 do fitots2[hh] = total(fispec[hh,0:40])


  store_data,'coh_'+p1+p2+'_leefilt6',data={x:coh.x,y:filteredimage,v:coh.v}
  store_data,'coh_'+p1+p2+'_leefilts6',data={x:coh.x,y:fispec,v:coh.v}
  store_data,'coh_'+p1+p2+'_slicelee6',data={x:coh.x,y:fitots}
  store_data,'coh_'+p1+p2+'_slicelee62',data={x:coh.x,y:fitots2}


;tplot,['fispec6','coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_slicelee6','coh_'+p1+p2+'_slicelee62']


;  stop


;****is this necessary??****
  get_data,'coh_'+p1+p2+'_slicelee62',data=dd
  goo = where(dd.y eq 0.)
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan
  store_data,'coh_'+p1+p2+'_slicelee62',data=dd
  ylim,'coh_'+p1+p2+'_slicelee62',min(dd.y,/nan),max(dd.y,/nan)
;******************************


  t0t = coh.x[0]
  t1t = coh.x[n_elements(coh.x)-1]


  options,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],'spec',1
  ylim,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],0.0008,0.1,1
;         ylim,['coh_'+p1+p2+'_leefilt6','coh_'+p1+p2+'_leefilts6'],0.0008,0.1,1
  ;; window,4,xsize=900,ysize=1800

;  timespan,t0t,(t1t-t0t),/sec



;;       cormin = 0.4
;;       goo = where(coh.y le cormin)
;;       if goo[0] ne -1 then coh.y[goo] = !values.f_nan
;; ;      if goo[0] ne -1 then ph.y[goo] = !values.f_nan
;;       boo = where(finite(coh.y) eq 0)
;;       ;; if boo[0] ne -1 then ph.y[boo] = !values.f_nan
;;       store_data,'coh_'+p1+p2,data=coh
;; ;      store_data,'phase_'+p1+p2,data=ph
;; ;      options,'coh_'+p1+p2,'ytitle','Precip Coherence!C'+pre+p1+' vs '+pre+p2+'!Cfreq[Hz]'
;;  ;     options,'phase_'+p1+p2,'ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
;;   ;    ylim,['phase_'+p1+p2],-0.001,0.01


  ;; Set z-scale for the Leefiltered spec. I want "events" to
  ;; really pop out. 
  get_data,'coh_'+p1+p2+'_leefilts6',data=lf
  maxx = max(lf.y,/nan)
  minn = min(lf.y,/nan)
  dz = (maxx - minn)/3.
  zlim,'coh_'+p1+p2+'_leefilts6',(minn+dz),maxx/1.2



  options,'coh_'+p1+p2+'_leefilts6','ytitle','coh!C'+p1+p2+'!C leefilter'+'!Csmoothed'

  !p.charsize = 0.8
;      popen,'~/Desktop/full_mission_coherence_'+p1+p2+'.ps'
  ;; tplot,['coh_'+p1+p2,'coh_'+p1+p2+'_leefilt6',$
  ;;        'coh_'+p1+p2+'_leefilts6','coh_'+p1+p2+'_slicelee62',$
  ;;        'dlshell_Kp2_'+p1+p2,'dmlt_Kp2_'+p1+p2,$
  ;;        'lcomb','mltcomb']
;      pclose

;  stop

end
