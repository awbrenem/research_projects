
;Find Lshell and MLT differences b/t balloon payloads and create a bunch
;of fancy tplot variables.

pro get_barrel_dl_dmlt_vars,l1,l2,mlt1,mlt2,suffix

  ;Find Lshell difference
  dif_data,l1,l2,newname='dL_'+suffix
  get_data,'dL_'+suffix,data=goo
  store_data,'dL_'+suffix,data={x:goo.x,y:abs(goo.y)}
  ylim,'dL_'+suffix,0,10,0

  ;Find MLT difference
  mlt_difference_find,mlt1,mlt2
  copy_data,'dMLT','dMLT_'+suffix
  store_data,'dMLT',/delete
  ylim,'dMLT_'+suffix,0,24


  ;create variable for MLT that has dashed line at noon
  get_data,'dMLT_'+suffix,data=d
  store_data,'noonlineDelta',d.x,replicate(12.,n_elements(d.x))
  store_data,mlt1+'_noonlineDelta',data=[mlt1,'noonlineDelta']
  options,'noonlineDelta','linestyle',2

  ;create variable for Lshell that has dashed line at zero
  store_data,'zerolineDelta',d.x,replicate(0.,n_elements(d.x))
  options,'zerolineDelta','linestyle',2


  ;Combine all Lshell plots
  store_data,'dL_'+suffix+'_both',data=[l1,l2,'dL_'+suffix,'zerolineDelta']
  options,'dL_'+suffix+'_both','colors',[0,50,250,0]
  ylim,'dL_'+suffix+'_both',0,10

  ;Combine all MLT plots
  store_data,'dMLT_'+suffix+'_both',data=[mlt1,mlt2,'dMLT_'+suffix,'noonlineDelta']
  options,'dMLT_'+suffix+'_both','colors',[0,50,250,0]
  ylim,'dMLT_'+suffix+'_both',0,24


  ;Remove zero values that can happen
  get_data,'dMLT_'+suffix,tt,dd
  goo = where(dd eq 0.)
  if goo[0] ne -1 then dd[goo] = !values.f_nan
  store_data,'dMLT_'+suffix,tt,dd

;  tplot,['dL_'+suffix,'dMLT_'+suffix,'dMLT_'+suffix+'_both','dMLT_'+suffix+'_both']
end
