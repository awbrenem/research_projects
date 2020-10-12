pro remove_fspc_gaps,tname,newname=newname,thresh=thresh

  get_data,tname,data=dat


  sr = rbsp_sample_rate(dat.x,out_med_avg=medavg)
  medavg = medavg[0]

  if ~keyword_set(newname) then newname=tname

  ;; Gap threshold
  if ~keyword_set(thresh) then thresh = 20


  deltat = shift(dat.x,-1) - dat.x


;start and end index of each gap
  gapsI = where(deltat ge thresh)
  gapeI = floor(gapsI + medavg*deltat[gapsI])


  print,time_string(dat.x[gapsI[10]]), time_string(dat.x[gapeI[10]])
  for i=0,100 do print,gapsI[i],gapeI[i]

  
;end times of each gap
  gapsI_unix = dat.x[gapsI]
  gapeI_unix = dat.x[gapeI]

;alternative calculation of gap duration
  dur_gap = gapeI_unix - gapsI_unix

  for i=0,n_elements(dur_gap)-1 do print,time_string(gapsI_unix[i]) + ' - ' + time_string(gapeI_unix[i]), dur_gap[i]

  for i=0,n_elements(dur_gap)-1 do begin
     goo = where((dat.x ge gapsI_unix[i]) and (dat.x le gapeI_unix[i]))
     ;; if goo[0] ne -1 then dat.x[goo] = !values.f_nan
     if goo[0] ne -1 then dat.y[goo] = !values.f_nan
  endfor


  xv = dat.x
  yv = dat.y
  interp_gap,xv,yv


  store_data,newname,data={x:xv,y:yv}

  options,[tname,newname],'psym',-4
  tplot,[tname,newname]
  stop

  


end
