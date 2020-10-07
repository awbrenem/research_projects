;Map the FB4 values to the equator for a variety of FB timeshifts.
;Save tplot variables for each timeshift and model.


;model = 't04s'
;model = 't96'
;model = 't01'

pro fb_mapping_various_timeshifts,tshift,model


sc = 'a'
ts = time_double(['2016-01-19/22:00','2016-01-20/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds

dur = ts[1]-ts[0]
storm_start = time_string(ts[0])


;Now map the Firebird 4 to magnetic equator

fileroot = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/'
tplot_restore,filenames=fileroot+'fb4_coord_jan20_accurate.tplot'

gsm_coord = 'fb4_gsm'
get_data,gsm_coord,tt,dd

tinterpol_mxn,'fb4_gsm','rbspa_state_pos_gsm',newname='fb4_gsm'


for i=0,n_elements(tshift)-1 do begin


  tstr = strtrim(string(tshift[i],format='(f4.1)'),2)

;Apply time shift
store_data,gsm_coord,tt + tshift[i],dd*6370.
sc = 'fb4'

aaron_map_with_tsy,model,storm_start,dur,'FB4',gsm_coord


tplot,['FB4!CL-shell-'+model,$
  'FB4!Cequatorial-foot-MLT!C'+model,$
  'FB4!Cnorth-foot-MLT!C'+model,$
  'FB4!Csouth-foot-MLT!C'+model]

  fileroot = '~/Desktop/'
  tplot_save,['FB4!CL-shell-'+model,$
    'FB4!Cequatorial-foot-MLT!C'+model,$
'FB4!Cnorth-foot-MLT!C'+model,$
'FB4!Csouth-foot-MLT!C'+model],$
      filename=fileroot+'fb4_'+model+'_tshift='+tstr+'sec_lshell_MLT_hires'



endfor

end
