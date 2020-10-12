pro call_get_fft_comparison




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






end