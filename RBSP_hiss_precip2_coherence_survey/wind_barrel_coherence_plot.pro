  ;;band4 (0.1-3 mHz)
  window_minutes = 2*90.
  window = 60.*window_minutes
  lag = window/8.
  coherence_time = window*2.5

  dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,$
                           new_name='Precip_hiss'  

  copy_data,'Precip_hiss_coherence','coh_'+p1+p2+'_band4'
  copy_data,'Precip_hiss_phase','phase_'+p1+p2+'_band4'
  get_data,'coh_'+p1+p2+'_band4',data=coh
  get_data,'phase_'+p1+p2+'_band4',data=ph
  store_data,'coh_'+p1+p2+'_band4',data={x:coh.x,y:coh.y,v:coh.v*1000.,spec:1}
  store_data,'phase_'+p1+p2+'_band4',data={x:ph.x,y:ph.y,v:ph.v*1000.,spec:1}
  ;;--------------------
