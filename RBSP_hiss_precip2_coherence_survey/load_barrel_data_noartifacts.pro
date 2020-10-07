;Load the BARREL data that I've process to remove artifacts (from py_create_barrel_singlepayload_tplot.pro).
;Called from py_create_coh_tplot.pro

;The data loaded here have already had solar flares removed (by py_create_barrel_singlepayload_tplot.pro)

;Calls: fill_with_uncorrelated_data.pro

;Example path and filename:
; path = ~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/folder_singlepayload/'
; fn = barrel_2E_fspc_fullmission.txt


pro load_barrel_data_noartifacts,path,fn,type,payload

  tplot_restore,filenames=path+'/'+fn

  ylim,'L_Kp2_'+payload,0,20
  ylim,'MLT_Kp2_'+payload,0,24



  ;Data processing...
  ;1) remove the data that has been turned into NaNs due to solar flares.
  ;2) fill all data gaps in the FSPC single-payload data with uncorrelated data


  ;Remove flare NaN values
  get_data,type+'_'+payload,data=dd
  goo = where(finite(dd.y) ne 0)
print,'UUUUUU'
help,type+'_'+payload
help,goo
help,dd,/st
print,'UUUUUU'
help,type
help,payload
help,dd.x[goo]
help,dd.y[goo]
print,'UUUUUU'

newname = type+'_'+payload

  if is_struct(dd) and goo[0] ne -1 then store_data,newname,data={x:dd.x[goo],y:dd.y[goo]}


  ;Remove gaps
;  get_data,type+'_'+payload,data=dd
;  boo = where(finite(dd.y) eq 0.)

;  remove_fspc_gaps,type+'_'+payload,newname=type+'_'+payload+'_tst',thresh=20





;  ;Fill gaps with uncorrelated data
;  gapmin = 4.01
;  newcadence = 4.0
;  fill_with_uncorrelated_data,type+'_'+payload,gapmin,newcadence,timesadded_start=trs1,timesadded_end=tre1
;  copy_data,type+'_'+payload+'_interp_fixed',type+'_'+payload
;  store_data,[type+'_'+payload+'_interp_fixed',type+'_'+payload+'_interp'],/delete


end
